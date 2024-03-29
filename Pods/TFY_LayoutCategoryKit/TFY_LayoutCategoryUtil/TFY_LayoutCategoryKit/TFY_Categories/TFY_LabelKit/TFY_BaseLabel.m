//
//  TFY_BaseLabel.m
//  TFY_LayoutCategoryUtil
//
//  Created by 田风有 on 2022/10/23.
//  Copyright © 2022 田风有. All rights reserved.
//

#import "TFY_BaseLabel.h"
#import "TFY_LabelLayoutManager.h"

#define kAdjustFontSizeEveryScalingFactor (M_E / M_PI)
//总得有个极限
static CGFloat kTFYLabelFloatMax = 10000000.0f;
static CGFloat kTFYLabelAdjustMinFontSize = 1.0f;
static CGFloat kTFYLabelAdjustMinScaleFactor = 0.01f;

static NSArray * kTFYLabelStylePropertyNames() {
    static NSArray *_stylePropertyNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //TODO: 这个highlighted在tableview滚动到的时候会设置下(即使cell的selectStyle为None)，然后就造成resetText，很鸡巴，耗费性能，这个似乎没辙，实在有必要，后期+个属性来开关
        _stylePropertyNames = @[@"font",@"textAlignment",@"textColor",@"highlighted",
                                @"highlightedTextColor",@"shadowColor",@"shadowOffset",@"enabled",@"lineHeightMultiple",@"lineSpacing"];
    });
    return _stylePropertyNames;
}

static inline CGSize _TFYLabel_CGSizePixelRound(CGSize size) {
    static CGFloat scale = 0.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

@interface TFY_LabelStylePropertyRecord : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign) CGFloat lineHeightMultiple; //行高的multiple
@property (nonatomic, assign) CGFloat lineSpacing; //行间距

@end
@implementation TFY_LabelStylePropertyRecord
@end

@interface TFY_BaseLabel ()<NSLayoutManagerDelegate>

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) TFY_LabelLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, assign) TFYLastTextType lastTextType;

@property (nonatomic, strong) TFY_LabelStylePropertyRecord *styleRecord;

//为什么需要这个，是因为setAttributedText之后内部可能会对其进行了改动，然后例如再次更新style属性，然后更新绘制会出问题。索性都以记录的最原始的为准。
@property (nonatomic, copy) NSAttributedString *lastAttributedText;
//读取的时候需要
@property (nonatomic, copy) NSString *lastText;

@end

@implementation TFY_BaseLabel

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.lineHeightMultiple = 1.0f;
    
    //设置TextKit初始相关
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    //label helper相关
    if ([super attributedText]) {
        self.attributedText = [super attributedText];
    }else{
        self.text = [super text];
    }
    
    //kvo 监视style属性
    for (NSString *key in kTFYLabelStylePropertyNames()) {
        [self.styleRecord setValue:[self valueForKey:key] forKey:key];
        //不直接使用NSKeyValueObservingOptionInitial来初始化赋值record，是防止无用的resettext
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)dealloc
{
    //kvo 移除监视style属性
    for (NSString *key in kTFYLabelStylePropertyNames()) {
        [self removeObserver:self forKeyPath:key context:nil];
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([kTFYLabelStylePropertyNames() containsObject:keyPath]) {
        //存到记录对象里
        [_styleRecord setValue:[object valueForKey:keyPath] forKey:keyPath];
        
        id old = change[NSKeyValueChangeOldKey];
        id new = change[NSKeyValueChangeNewKey];
        if ([old isEqual:new]||(!old&&!new)) {
            return;
        }
        
        [self reSetText];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - getter
- (NSTextStorage *)textStorage
{
    if (!_textStorage) {
        _textStorage = [NSTextStorage new];
    }
    return _textStorage;
}

- (TFY_LabelLayoutManager *)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [TFY_LabelLayoutManager new];
        _layoutManager.allowsNonContiguousLayout = NO;
        _layoutManager.delegate = self;
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer
{
    if (!_textContainer) {
        _textContainer = [NSTextContainer new];
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.lineFragmentPadding = 0.0f;
        _textContainer.size = self.frame.size;
    }
    return _textContainer;
}

- (TFY_LabelStylePropertyRecord *)styleRecord
{
    if (!_styleRecord) {
        _styleRecord = [TFY_LabelStylePropertyRecord new];
    }
    return _styleRecord;
}

- (NSAttributedString *)attributedText
{
    return _lastTextType==TFYLastTextTypeAttributed?_lastAttributedText:[self attributedTextForTextStorageFromLabelProperties];
}

- (NSString*)text
{
    return _lastTextType==TFYLastTextTypeAttributed?_lastAttributedText.string:_lastText;
}

#pragma mark - set text
- (void)setLastTextType:(TFYLastTextType)lastTextType
{
    _lastTextType = lastTextType;
    //重置下
    self.lastText = nil;
    self.lastAttributedText = nil;
}

- (void)setText:(NSString *)text
{
    NSAssert(!text||[text isKindOfClass:[NSString class]], @"text must be NSString");
    
    self.lastTextType = TFYLastTextTypeNormal;
    self.lastText = text;
    
    [self invalidateIntrinsicContentSize];
    //    [super setText:text];
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSAssert(!attributedText||[attributedText isKindOfClass:[NSAttributedString class]], @"text must be NSAttributedString");
    
    self.lastTextType = TFYLastTextTypeAttributed;
    self.lastAttributedText = attributedText;
    
    [self invalidateIntrinsicContentSize];
    //    [super setAttributedText:attributedText];
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
    //    NSLog(@"set attr text %p",self);
}

#pragma mark - common helper
- (CGSize)drawTextSizeWithBoundsSize:(CGSize)size
{
    //bounds改了之后，要根据insets调整绘制区域的大小
    CGFloat width = fmax(0, size.width-_textInsets.left-_textInsets.right);
    CGFloat height = fmax(0, size.height-_textInsets.top-_textInsets.bottom);
    return CGSizeMake(width, height);
}

- (void)reSetText
{
    if (_lastTextType == TFYLastTextTypeNormal) {
        self.text = _lastText;
    }else{
        self.attributedText = _lastAttributedText;
    }
}

/**
 *  根据label的属性来进行处理并返回给textStorage使用的
 */
- (NSMutableAttributedString*)attributedTextForTextStorageFromLabelProperties
{
    if (_lastTextType==TFYLastTextTypeNormal) {
        if (!_lastText) {
            return [[NSMutableAttributedString alloc]initWithString:@""];
        }
        
        //根据text和label默认的一些属性得到attributedText
        return [[NSMutableAttributedString alloc] initWithString:_lastText attributes:[self attributesFromLabelProperties]];
    }
    
    if (!_lastAttributedText) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    //遍历并且添加Label默认的属性
    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc]initWithString:_lastAttributedText.string attributes:[self attributesFromLabelProperties]];
    
    [_lastAttributedText enumerateAttributesInRange:NSMakeRange(0, newAttrStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count>0) {
            //            [newAttrStr removeAttributes:[attrs allKeys] range:range];
            [newAttrStr addAttributes:attrs range:range];
        }
    }];
    return newAttrStr;
}

- (NSDictionary *)attributesFromLabelProperties
{
    //颜色
    UIColor *color = self.styleRecord.textColor;
    if (!_styleRecord.enabled) {
        color = [UIColor lightGrayColor];
    }
    else if (_styleRecord.highlighted) {
        color = _styleRecord.highlightedTextColor;
    }
    if (!color) {
        color = _styleRecord.textColor;
        if (!color) {
            color = [UIColor darkTextColor];
        }
    }
    
    //阴影
    NSShadow *shadow = shadow = [[NSShadow alloc] init];
    if (_styleRecord.shadowColor) {
        shadow.shadowColor = _styleRecord.shadowColor;
        shadow.shadowOffset = _styleRecord.shadowOffset;
    }else {
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowColor = nil;
    }
    
    //水平位置
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = _styleRecord.textAlignment;
    paragraph.lineSpacing = _styleRecord.lineSpacing;
    paragraph.lineHeightMultiple = _styleRecord.lineHeightMultiple;
    
    if (!_styleRecord.font) {
        _styleRecord.font = [UIFont systemFontOfSize:17.0f];
    }
    //最终
    NSDictionary *attributes = @{NSFontAttributeName : _styleRecord.font,
                                 NSForegroundColorAttributeName : color,
                                 NSShadowAttributeName : shadow,
                                 NSParagraphStyleAttributeName : paragraph,
                                 };
    return attributes;
}


- (CGRect)textRectForBounds:(CGRect)bounds attributedString:(NSAttributedString*)attributedString limitedToNumberOfLines:(NSInteger)numberOfLines lineCount:(NSInteger*)lineCount
{
    //这种算是特殊情况，如果为空字符串，那就没必要必要了，也忽略textInset，这样比较合理
    if (attributedString.length<=0) {
        bounds.size = CGSizeZero;
        return bounds;
    }
    
    CGSize drawTextSize = [self drawTextSizeWithBoundsSize:bounds.size];
    if (drawTextSize.width<=0||drawTextSize.height<=0){
        CGRect textBounds = CGRectZero;
        textBounds.origin = bounds.origin;
        textBounds.size = CGSizeMake(fmin(_textInsets.left+_textInsets.right,CGRectGetWidth(bounds)), fmin(_textInsets.top+_textInsets.bottom,CGRectGetHeight(bounds)));
        return textBounds;
    }
    
    CGRect textBounds = CGRectZero;
    @autoreleasepool {
        CGSize savedTextContainerSize = _textContainer.size;
        NSInteger savedTextContainerNumberOfLines = _textContainer.maximumNumberOfLines;
        
        //这一句的原因参考resizeTextContainerSize
        if (drawTextSize.height<kTFYLabelFloatMax) {
            drawTextSize.height += self.lineSpacing;
        }
        _textContainer.size = drawTextSize;
        _textContainer.maximumNumberOfLines = numberOfLines;
        
        NSAttributedString *savedAttributedString = nil;
        if (![_textStorage isEqual:attributedString]) {
            savedAttributedString = [_textStorage copy];
            [_textStorage setAttributedString:attributedString];
        }
        
        NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
        if (lineCount) {
            [_layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
                (*lineCount)++;
            }];
            //在最后字符为换行符的情况下，实际绘制出来的是会多那个一行，这里作为AppleBUG修正
            if ([_textStorage.string isNewlineCharacterAtEnd]) {
                (*lineCount)++;
            }
        }
        
        textBounds = [_layoutManager usedRectForTextContainer:_textContainer];
        
        //还原
        if (savedAttributedString) {
            [_textStorage setAttributedString:savedAttributedString];
        }
        _textContainer.size = savedTextContainerSize;
        _textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
    //最终修正
    textBounds.size.width =  fmin(ceilf(textBounds.size.width), drawTextSize.width);
    textBounds.size.height = fmin(ceilf(textBounds.size.height), drawTextSize.height);
    textBounds.origin = bounds.origin;
    
    textBounds.size = CGSizeMake(fmin(CGRectGetWidth(textBounds)+_textInsets.left+_textInsets.right,CGRectGetWidth(bounds)), fmin(CGRectGetHeight(textBounds)+_textInsets.top+_textInsets.bottom,CGRectGetHeight(bounds)));
    
    //    NSLog(@"bounds:%@ result:%@ %p",NSStringFromCGRect(bounds),NSStringFromCGRect(textBounds),self);
    return textBounds;
}

#pragma mark - draw
- (BOOL)adjustsCurrentFontSizeToFitWidthWithScaleFactor:(CGFloat)scaleFactor numberOfLines:(NSInteger)numberOfLines originalAttributedText:(NSAttributedString*)originalAttributedText bounds:(CGRect)bounds resultAttributedString:(NSAttributedString**)resultAttributedString
{
    __block BOOL mustReturnYES = NO;
    if (self.minimumScaleFactor > scaleFactor) {
        scaleFactor = self.minimumScaleFactor; //这个的话 就不能在循环验证了
        mustReturnYES = YES;
    }
    //总得有个极限
    scaleFactor = fmax(scaleFactor, kTFYLabelAdjustMinScaleFactor);
    
    //遍历并且设置一个新的字体
    NSMutableAttributedString *attrStr = [originalAttributedText mutableCopy];
    
    if (scaleFactor!=1.0f) { //如果是1.0f的话就没有调整font size的必要
        [attrStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            UIFont *font = (UIFont *)value;
            if (font&&[font isKindOfClass:[UIFont class]]) {
                NSString *fontName = font.fontName;
                CGFloat newSize = font.pointSize*scaleFactor;
                if (newSize<kTFYLabelAdjustMinFontSize) { //字体的极限
                    mustReturnYES = YES;
                }
                UIFont *newFont = [UIFont fontWithName:fontName size:newSize];
                
                //                [attrStr removeAttribute:NSFontAttributeName range:range];
                [attrStr addAttribute:NSFontAttributeName value:newFont range:range];
            }
        }];
    }
    
    //返回是否需要继续调整字体大小
    if (mustReturnYES) {
        if (resultAttributedString) {
            (*resultAttributedString) = attrStr;
        }
        return YES;
    }
    
    
    CGSize currentTextSize = CGSizeZero;
    if (numberOfLines>0) {
        NSInteger lineCount = 0;
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), kTFYLabelFloatMax) attributedString:attrStr limitedToNumberOfLines:0 lineCount:&lineCount].size;
        //如果求行数大于设置行数，也不认为塞满了
        if (lineCount>numberOfLines) {
            return NO;
        }
    }else{
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), kTFYLabelFloatMax) attributedString:attrStr limitedToNumberOfLines:0 lineCount:NULL].size;
    }
    
    //大小已经足够就认作OK
    if (currentTextSize.width<=CGRectGetWidth(bounds)&&currentTextSize.height<=CGRectGetHeight(bounds)) {
        if (resultAttributedString) {
            (*resultAttributedString) = attrStr;
        }
        return YES;
    }
    
    return NO;
}

- (void)drawTextInRect:(CGRect)rect
{
    //    NSLog(@"draw text %p",self);
    //不调用super方法
    //            [super drawTextInRect:rect]; //这里调用可以查看是否绘制和原来的不一致
    
    //如果绘制区域本身就为0，就应该直接返回，不做多余操作。
    CGSize drawSize = [self drawTextSizeWithBoundsSize:self.bounds.size];
    if (drawSize.width<=0||drawSize.height<=0){
        return;
    }
    
    if (self.adjustsFontSizeToFitWidth) {
        //初始scale，每次adjust都需要从头开始，因为也可能有当前font被adjust小过需要还原。
        CGFloat scaleFactor = 1.0f;
        BOOL mustContinueAdjust = YES;
        NSAttributedString *attributedString = [self attributedTextForTextStorageFromLabelProperties];
        
        //numberOfLine>0时候可以直接尝试找寻一个preferredScale
        if (self.numberOfLines>0) {
            //一点点矫正,以使得内容能放到当前的size里
            
            //找到当前text绘制在一行时候需要占用的宽度，其实这个值很可能不够，因为多行时候可能会因为wordwrap的关系多行+起的总宽度会多。但是这个能找到一个合适的矫正过程的开始值，大大减少矫正次数。
            
            //还有一种情况就是，有可能由于字符串里带换行符的关系造成压根不可能绘制到一行，这时候应该取会显示的最长的那一行。所以这里需要先截除必然不会显示的部分。
            NSUInteger stringlineCount = [attributedString.string lineCount];
            if (stringlineCount>self.numberOfLines) {
                //这里说明必然要截取
                attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, [attributedString.string lengthToLineIndex:self.numberOfLines-1])];
            }
            
            CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, kTFYLabelFloatMax, kTFYLabelFloatMax) attributedString:attributedString limitedToNumberOfLines:0 lineCount:NULL].size.width;
            textWidth = fmax(0, textWidth-_textInsets.left-_textInsets.right);
            if (textWidth>0) {
                CGFloat availableWidth = _textContainer.size.width*self.numberOfLines;
                if (textWidth > availableWidth) {
                    //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                    scaleFactor = availableWidth / textWidth;
                }
            }else{
                mustContinueAdjust = NO;
            }
        }
        
        if (mustContinueAdjust) {
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *resultAttributedString = attributedString;
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:self.numberOfLines originalAttributedText:attributedString bounds:self.bounds resultAttributedString:&resultAttributedString]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
            [_textStorage setAttributedString:resultAttributedString];
        }
    }
    
    
    //这里根据container的size和manager布局属性以及字符串来得到实际绘制的range区间
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    
    //获取绘制区域大小
    CGRect drawBounds = [_layoutManager usedRectForTextContainer:_textContainer];
    
    //因为label是默认垂直居中的，所以需要根据实际绘制区域的bounds来调整出居中的offset
    CGPoint textOffset = [self textOffsetWithTextSize:drawBounds.size];
    
    if (_doBeforeDrawingTextBlock) {
        //而实际上drawBounds的宽度可能不是我们想要的，我们想要的是_textContainer的宽度，但是高度需要是真实绘制高度
        CGSize drawSize = CGSizeMake(_textContainer.size.width, drawBounds.size.height);
        _doBeforeDrawingTextBlock(rect,textOffset,drawSize);
    }
    
    //绘制文字
    [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

//这个计算出来的是绘制起点
- (CGPoint)textOffsetWithTextSize:(CGSize)textSize
{
    CGPoint textOffset = CGPointZero;
    //根据insets和默认垂直居中来计算出偏移
    textOffset.x = _textInsets.left;
    CGFloat paddingHeight = (self.bounds.size.height- _textInsets.top - _textInsets.bottom - textSize.height) / 2.0f;
    textOffset.y = paddingHeight+_textInsets.top;
    
    return textOffset;
}


//- (NSUInteger)layoutManager:(NSLayoutManager *)layoutManager
//       shouldGenerateGlyphs:(const CGGlyph *)glyphs
//                 properties:(const NSGlyphProperty *)props
//           characterIndexes:(const NSUInteger *)charIndexes
//                       font:(UIFont *)aFont
//              forGlyphRange:(NSRange)glyphRange
//{
//    NSLog(@"shouldGenerateGlyphs:  start:%ld end:%ld",*charIndexes,charIndexes[glyphRange.length-1]);
////    if (*charIndexes>=100) {
////        return 0;
////    }
//    [layoutManager setGlyphs:glyphs properties:props characterIndexes:charIndexes font:aFont forGlyphRange:glyphRange];
//    return glyphRange.length;
//}

#pragma mark - sizeThatsFit
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    //fit实现与drawTextInRect大部分一个屌样，所以不写注释了。
    if (numberOfLines>1&&self.adjustsFontSizeToFitWidth) {
        CGFloat scaleFactor = 1.0f;
        NSAttributedString *attributedString = [self attributedTextForTextStorageFromLabelProperties];
        
        NSUInteger stringlineCount = [attributedString.string lineCount];
        if (stringlineCount>self.numberOfLines) {
            //这里说明必然要截取
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, [attributedString.string lengthToLineIndex:self.numberOfLines-1])];
        }
        
        CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, kTFYLabelFloatMax, kTFYLabelFloatMax) attributedString:attributedString limitedToNumberOfLines:0 lineCount:NULL].size.width;
        textWidth = fmax(0, textWidth-_textInsets.left-_textInsets.right);
        if (textWidth>0) {
            CGFloat availableWidth = _textContainer.size.width*numberOfLines;
            if (textWidth > availableWidth) {
                //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                scaleFactor = availableWidth / textWidth;
            }
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *resultAttributedString = attributedString;
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:numberOfLines originalAttributedText:attributedString bounds:bounds resultAttributedString:&resultAttributedString]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
            
            //计算当前adjust之后的合适大小,为什么不用adjust里面的 因为也可能有异常情况，例如压根adjust就没走到计算大小那一步啊什么的。
            CGRect textBounds = [self textRectForBounds:bounds attributedString:resultAttributedString limitedToNumberOfLines:numberOfLines lineCount:NULL];
            
            return textBounds;
        }
    }
    return  [self textRectForBounds:bounds attributedString:_textStorage limitedToNumberOfLines:numberOfLines lineCount:NULL];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size = [super sizeThatFits:size];
    return _TFYLabel_CGSizePixelRound(size);
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return _TFYLabel_CGSizePixelRound(size);
}

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [self sizeThatFits:CGSizeMake(maxWidth, kTFYLabelFloatMax)];
    size.width = fmin(size.width, maxWidth); //在numberOfLine为1模式下返回的可能会比maxWidth大，所以这里我们限制下
    return size;
}

#pragma mark - set 修改container size相关
- (void)resizeTextContainerSize
{
    if (_textContainer) {
        //usedRectForTextContainer的BUG，textContainer提供的容器大小一定要假设最后一行也有底部行间距的大小的，否则结果会少一行。
        //计算结果来说的话就没有最后一行的行间距，很奇葩。
        CGSize size = [self drawTextSizeWithBoundsSize:self.bounds.size];
        if (size.height<kTFYLabelFloatMax) {
            size.height+=self.lineSpacing;
        }
        _textContainer.size = size;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeTextContainerSize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeTextContainerSize];
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    _textInsets = insets;
    [self resizeTextContainerSize];
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - set container相关属性
- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    BOOL isChanged = (numberOfLines!=_textContainer.maximumNumberOfLines);
    
    [super setNumberOfLines:numberOfLines];
    
    _textContainer.maximumNumberOfLines = numberOfLines;
    
    if (isChanged) {
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    
    _textContainer.lineBreakMode = lineBreakMode;
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - set 其他
- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor
{
    [super setMinimumScaleFactor:minimumScaleFactor];
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setDoBeforeDrawingTextBlock:(void (^)(CGRect rect,CGPoint beginOffset,CGSize drawSize))doBeforeDrawingTextBlock
{
    _doBeforeDrawingTextBlock = [doBeforeDrawingTextBlock copy];
    
    [self setNeedsDisplay];
}

#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(__unused id)sender
{
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions
- (void)copy:(__unused id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}


@end


@implementation NSMutableAttributedString (TFY_Label)

- (void)removeAllNSOriginalFontAttributes
{
    [self enumerateAttribute:@"NSOriginalFont" inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value){
            [self removeAttribute:@"NSOriginalFont" range:range];
        }
    }];
}


- (void)removeAttributes:(NSArray *)names range:(NSRange)range
{
    for (NSString *name in names) {
        [self removeAttribute:name range:range];
    }
}
@end


@implementation NSString (TFY_Label)

- (NSUInteger)lineCount
{
    if (self.length<=0) { return 0; }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    if ([self isNewlineCharacterAtEnd]) {
        return numberOfLines+1;
    }
    
    return numberOfLines;
}

- (BOOL)isNewlineCharacterAtEnd
{
    if (self.length<=0) {
        return NO;
    }
    //检查最后是否有一个换行符
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSRange lastRange = [self rangeOfCharacterFromSet:separator options:NSBackwardsSearch];
    return (NSMaxRange(lastRange) == self.length);
}

- (NSString*)subStringToLineIndex:(NSUInteger)lineIndex
{
    NSUInteger index = [self lengthToLineIndex:lineIndex];
    
    return [self substringToIndex:index];
}

- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex
{
    if (self.length<=0) {
        return 0;
    }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        NSRange lineRange = [self lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);
        
        if (numberOfLines==lineIndex) {
            NSString *lineString = [self substringWithRange:lineRange];
            if (![lineString isNewlineCharacterAtEnd]) {
                return index;
            }
            //把这行对应的换行符给忽略
            if (NSMaxRange([lineString rangeOfString:@"\r\n"])==lineString.length) {
                return index-2;
            }
            
            return index - 1;
        }
    }
    
    return 0;
}

- (NSAttributedString*)linkAttributedStringWithLinkRegex:(NSRegularExpression*)linkRegex groupIndexForDisplay:(NSInteger)groupIndexForDisplay groupIndexForValue:(NSInteger)groupIndexForValue{
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:self];
    return [attStr linkAttributedStringWithLinkRegex:linkRegex groupIndexForDisplay:groupIndexForDisplay groupIndexForValue:groupIndexForValue];
}

@end

@implementation NSAttributedString (TFY_Label)

+ (instancetype)attributedStringWithHTML:(NSString*)htmlString
{
    NSData* htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    if (htmlData) {
        __block id attributedString = nil;
        dispatch_block_t block = ^{
            attributedString = [[self alloc] initWithData:htmlData
                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                       documentAttributes:nil
                                                    error:NULL];
        };
        
        //这个解析必须在主线程执行，文档上要求的
        if ([NSThread isMainThread]) {
            block();
        }else{
            dispatch_sync(dispatch_get_main_queue(), block);
        }
        
        return attributedString;
    }
    
    return nil;
}

- (NSAttributedString*)linkAttributedStringWithLinkRegex:(NSRegularExpression*)linkRegex groupIndexForDisplay:(NSInteger)groupIndexForDisplay groupIndexForValue:(NSInteger)groupIndexForValue {
    NSParameterAssert(linkRegex);
    NSAssert(groupIndexForDisplay>0&&groupIndexForValue>0, @"groupIndexForDisplay and groupIndexForValue must >0!");
    
    NSInteger length = [self length];
    if (length<=0) {
        return self;
    }
    
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //正则匹配所有内容
    NSArray *results = [linkRegex matchesInString:self.string
                                          options:NSMatchingWithTransparentBounds
                                            range:NSMakeRange(0, length)];
    
    //遍历结果，找到结果中被()包裹的区域作为显示内容
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSAssert([result numberOfRanges]>1&&[result numberOfRanges]>groupIndexForDisplay&&[result numberOfRanges]>groupIndexForValue, @"Please ensure that group sign `()` in the linkRegex is correct!");
        NSRange range = [result rangeAtIndex:0];
        
        //把前面的非匹配出来的区域加进来
        NSAttributedString *subAttrStr = [self attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        [resultAttributedString appendAttributedString:subAttrStr];
        //下次循环从当前匹配区域的下一个位置开始
        location = NSMaxRange(range);
        
        //找到要显示的区域内容加上
        NSRange rangeForDisplay = [result rangeAtIndex:groupIndexForDisplay];
        NSMutableAttributedString *displayStr = [[self attributedSubstringFromRange:rangeForDisplay]mutableCopy];
        //对其添加link属性
        NSString *linkValue = nil;
        if (groupIndexForValue==groupIndexForDisplay) {
            linkValue = displayStr.string;
        }else{
            NSRange rangeForValue = [result rangeAtIndex:groupIndexForValue];
            linkValue = [self attributedSubstringFromRange:rangeForValue].string;
        }
        [displayStr addAttribute:NSLinkAttributeName value:linkValue range:NSMakeRange(0, displayStr.length)];
        
        [resultAttributedString appendAttributedString:displayStr];
    }
    
    if (location < length) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, length - location);
        NSAttributedString *subAttrStr = [self attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    
    return resultAttributedString;
}

@end
