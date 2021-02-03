//
//  TFY_BannerView.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BannerView.h"
#import "TFY_BannerFlowLayout.h"
#import "TFY_BannerOverLayout.h"
#import "TFY_BannerPageControl.h"
#import "TFY_BannerDiverseLayout.h"
#define COUNT 500

@interface TFY_BannerView ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    BOOL beganDragging;
    CGFloat marginTime;
}
@property(strong,nonatomic)UICollectionView *myCollectionV;
@property(strong,nonatomic)UICollectionViewFlowLayout *flowL ;
@property(strong,nonatomic)TFY_BannerPageControl *bannerControl ;
@property(strong,nonatomic)NSArray *data;
@property(strong,nonatomic)TFY_BannerParam *param;
@property(copy,nonatomic)NSString *gcd_timer;
@property(strong,nonatomic)NSTimer *timer;
@property(weak,nonatomic)UIVisualEffectView *effectView;
@property(assign,nonatomic)NSInteger lastIndex;
@property(strong,nonatomic)UIView *line;
@end

@implementation TFY_BannerView

- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param withView:(UIView*)parentView{
    if (self = [super init]) {
        self.param = param;
        if (parentView) {
            [parentView addSubview:self];
        }
        self.param.tfy_Frame = CGRectMake(self.param.tfy_Frame.origin.x,
                                       self.param.tfy_Frame.origin.y,
                                       (int)self.param.tfy_Frame.size.width,
                                       (int)self.param.tfy_Frame.size.height);
        [self setFrame:self.param.tfy_Frame];
        self.data = [NSArray arrayWithArray:self.param.tfy_Data];
        [self setUp];
    }
    return self;
}

/**
 *  调用方法
 *
 */
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param{
    if (self = [super init]) {
        self.param = param;
        self.param.tfy_Frame = CGRectMake(self.param.tfy_Frame.origin.x,
                                       self.param.tfy_Frame.origin.y,
                                       (int)self.param.tfy_Frame.size.width,
                                       (int)self.param.tfy_Frame.size.height);
        [self setFrame:self.param.tfy_Frame];
        self.data = [NSArray arrayWithArray:self.param.tfy_Data];
        [self setUp];
    }
    return self;
}

//横竖屏更新布局。
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.myCollectionV.frame = self.bounds;
    self.bgImgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*self.param.tfy_EffectHeight);
    self.effectView.frame = self.bgImgView.frame;
    
    [self layoutIfNeeded];
}

- (void)updateUI{
    self.data = [NSArray arrayWithArray:self.param.tfy_Data];
    [self resetCollection];
}

- (void)resetCollection{
    self.bannerControl.numberOfPages = self.data.count;
    self.bannerControl.hidden = self.data.count==1?YES:NO;

    [UIView animateWithDuration:0.0 animations:^{
        [self.myCollectionV reloadData];
        if (self.param.tfy_SelectIndex >= 0 || self.param.tfy_Repeat) {
            NSIndexPath *path = [NSIndexPath indexPathForRow: self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex inSection:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrolToPath:path animated:NO];
                self.bannerControl.currentPage = self.param.tfy_SelectIndex;
                self.param.myCurrentPath = self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex;
                if (self.param.tfy_AutoScroll) {
                    [self createTimer];
                }else{
                    [self cancelTimer];
                }
            });
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollEnd:[NSIndexPath indexPathForRow: self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex inSection:0]];
        });
    } completion:^(BOOL finished) {}];
    
    if (self.param.tfy_SpecialStyle == SpecialStyleLine&&self.param.tfy_Data.count) {
        [self addSubview:self.line];
        self.line.hidden = NO;
        self.line.backgroundColor = [UIColor redColor];
        if (self.param.tfy_SpecialCustumLine) {
            self.param.tfy_SpecialCustumLine(self.line);
        }
        
        CGFloat lineHeight = CGRectGetHeight(self.line.frame)?:2;
        CGFloat lineWidth = CGRectGetWidth(self.param.tfy_Frame)/self.param.tfy_Data.count;
        self.line.frame = CGRectMake(0, CGRectGetHeight(self.param.tfy_Frame) -lineHeight,  lineWidth, lineHeight);
    }else{
        self.line.hidden = YES;
    }
}

- (void)setUp{
    if (self.data&&self.data.count==1) {
        self.param.tfy_Repeat = NO;
        self.param.tfy_AutoScroll = NO;
    }
    
    if (self.param.tfy_Marquee) {
        self.param.tfy_AutoScroll = YES;
        self.param.tfy_HideBannerControl = YES;
        marginTime = 0.005;
        self.param.tfy_Repeat = YES;
    }
    self.param.tfy_Frame = CGRectIntegral(self.param.tfy_Frame);
    
    if (self.param.tfy_ScreenScale<1&&self.param.tfy_ScreenScale>0) {
        CGRect rect = self.param.tfy_Frame;
        rect.origin.x = rect.origin.x * self.param.tfy_ScreenScale;
        rect.origin.y = rect.origin.y * self.param.tfy_ScreenScale;
        rect.size.width = rect.size.width * self.param.tfy_ScreenScale;
        rect.size.height = rect.size.height * self.param.tfy_ScreenScale;
        self.param.tfy_Frame = rect;
        self.frame = self.param.tfy_Frame;
        
        CGSize size = self.param.tfy_ItemSize;
        size.width *= self.param.tfy_ScreenScale;
        size.height *= self.param.tfy_ScreenScale;
        self.param.tfy_ItemSize = size;
        
        self.param.tfy_LineSpacing*=self.param.tfy_ScreenScale;
        
        UIEdgeInsets sets = self.param.tfy_SectionInset;
        sets.top*=self.param.tfy_ScreenScale;
        sets.right*=self.param.tfy_ScreenScale;
        sets.bottom*=self.param.tfy_ScreenScale;
        sets.left*=self.param.tfy_ScreenScale;
        self.param.tfy_SectionInset = sets;
    }
    
    if (self.param.tfy_ItemSize.height == 0 || self.param.tfy_ItemSize.width == 0) {
        self.param.tfy_ItemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }

    else if(self.param.tfy_ItemSize.height>CGRectGetHeight(self.frame)){
        self.param.tfy_ItemSize = CGSizeMake(self.param.tfy_ItemSize.width, CGRectGetHeight(self.frame));
    }else if(self.param.tfy_ItemSize.width>CGRectGetWidth(self.frame)){
        self.param.tfy_ItemSize = CGSizeMake(CGRectGetWidth(self.frame), self.param.tfy_ItemSize.height);
    }
    int width = self.param.tfy_ItemSize.width;
    int height = self.param.tfy_ItemSize.height;
    self.param.tfy_ItemSize = CGSizeMake(width, height);
    
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            self.flowL = [[TFY_BannerFlowLayout alloc] initConfigureWithModel:self.param];
            break;
        case CardtypeFallen:
            self.param.tfy_Repeat = YES;
            if (self.param.tfy_ScaleFactor == 0.5) {
                self.param.tfy_ScaleFactor = 0.8f;
            }
            self.flowL = [[TFY_BannerOverLayout alloc] initConfigureWithModel:self.param];
            break;
        case CardtypeMultifunction:
            self.flowL = [[TFY_BannerDiverseLayout alloc] initConfigureWithModel:self.param];
            break;
        default:
            break;
    }
    
    [self addSubview:self.myCollectionV];
    
    self.myCollectionV.scrollEnabled = self.param.tfy_CanFingerSliding;
    
    [self.myCollectionV registerClass:[Collectioncell class] forCellWithReuseIdentifier:NSStringFromClass([Collectioncell class])];
    [self.myCollectionV registerClass:[CollectionTextCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionTextCell class])];
    
    if (self.param.tfy_MyCellClassNames) {
        if ([self.param.tfy_MyCellClassNames isKindOfClass:[NSString class]]) {
            
           [self.myCollectionV registerClass:NSClassFromString(self.param.tfy_MyCellClassNames) forCellWithReuseIdentifier:self.param.tfy_MyCellClassNames];
            
        } else if ([self.param.tfy_MyCellClassNames isKindOfClass:[NSArray class]]) {
            
            [(NSArray*)self.param.tfy_MyCellClassNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                     [self.myCollectionV registerClass:NSClassFromString(obj) forCellWithReuseIdentifier:obj];
                }
            }];
        }
    }
    
    self.myCollectionV.frame = self.bounds;
    self.myCollectionV.pagingEnabled = (self.param.tfy_ItemSize.width == CGRectGetWidth(self.myCollectionV.frame) && self.param.tfy_LineSpacing == 0)||self.param.tfy_Vertical;
    
    self.bannerControl = [[TFY_BannerPageControl alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame)-20, 30)];
    self.bannerControl.pageControlType = PageControlTypeCircle;
    if (self.param.tfy_CustomControl) {
        self.param.tfy_CustomControl(self.bannerControl);
    }
    if (!self.param.tfy_HideBannerControl) {
        [self addSubview:self.bannerControl];
    }
    
    self.bgImgView = [[TFY_BannerImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*self.param.tfy_EffectHeight)];
//    self.bgImgView.contentMode = self.param.tfy_ImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleToFill;
    [self addSubview:self.bgImgView];
    [self sendSubviewToBack:self.bgImgView];
    self.bgImgView.hidden = !self.param.tfy_Effect;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.param.tfy_EffectStyle];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bgImgView.bounds;
    effectView.alpha = self.param.tfy_EffectAlpha;
//    effectView.contentMode = self.param.tfy_ImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleToFill;
    [self.bgImgView addSubview:effectView];
    self.effectView = effectView;
    
    [self resetCollection];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = self.param.tfy_Repeat?indexPath.row%self.data.count:indexPath.row;
    id dic = self.data[index];
    UICollectionViewCell *tmpCell = nil;
    if (self.param.tfy_MyCell) {
        tmpCell = self.param.tfy_MyCell([NSIndexPath indexPathForRow:index inSection:indexPath.section], collectionView, dic,self.bgImgView,self.data);
    } else {
        //默认视图
        Collectioncell *cell = (Collectioncell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Collectioncell class]) forIndexPath:indexPath];
        cell.param = self.param;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setIconData:cell.icon withData:dic[self.param.tfy_DataParamIconName]];

        }else{
            [self setIconData:cell.icon withData:dic];
        }
        tmpCell = cell;
    }
    return tmpCell;
}

- (void)setIconData:(TFY_BannerImageView*)icon withData:(id)data{
    if (!data) return;
    if ([data isKindOfClass:[NSString class]]) {
        if ([(NSString*)data hasPrefix:@"http"] || [(NSString*)data hasPrefix:@"https"]) {
        UIImage *defaultimage = [UIImage imageNamed:self.param.tfy_PlaceholderImage?self.param.tfy_PlaceholderImage:@""];
        [icon tfy_setImageWithURL:(NSString*)data placeholderImage:defaultimage];
        }else{
            icon.image = [UIImage imageNamed:(NSString*)data];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.param.tfy_Repeat?self.data.count*COUNT:self.data.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.param.tfy_EventClick) {
        NSInteger index = self.param.tfy_Repeat?indexPath.row%self.data.count:indexPath.row;
        id dic = self.data[index];
        self.param.tfy_EventClick(dic, index);
    }
    if (self.param.tfy_EventCenterClick) {
        NSInteger index = self.param.tfy_Repeat?indexPath.row%self.data.count:indexPath.row;
        id dic = self.data[index];
        BOOL center = [self checkCellInCenterCollectionView:collectionView AtIndexPath:indexPath];
        UICollectionViewCell *currentCell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.param.tfy_EventCenterClick(dic, index,center,currentCell);
    }
    if (self.param.tfy_ClickCenter) {
        NSArray *visibleCellIndex = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [visibleCellIndex sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        if (sortedIndexPaths.count>0) {
            NSInteger center = sortedIndexPaths.count/2;
            UICollectionViewCell *tmpCell = [collectionView cellForItemAtIndexPath:indexPath];
            for (int i = 0; i < sortedIndexPaths.count; i++) {
                UICollectionViewCell *cell = sortedIndexPaths[i];
                if (cell == tmpCell) {
                    NSIndexPath *nextIndexPath = nil;
                    if (i>center || i<center) {
                        nextIndexPath = [NSIndexPath indexPathForItem: indexPath.row inSection:0];
                        self.param.myCurrentPath = indexPath.row;
                        [self scrolToPath:nextIndexPath animated:YES];
                        [collectionView setUserInteractionEnabled:NO];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [collectionView setUserInteractionEnabled:YES];
                        });
                    }
                    break;
                }
            }
        }
    }
}

/*
 检测是否是中间的cell 当前判断依据为最大的cell 如果cell大小一样 那么取显示的first第一个
 */
- (BOOL)checkCellInCenterCollectionView:(UICollectionView *)collectionView AtIndexPath:(NSIndexPath *)indexPath{
    BOOL center = NO;
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *indexArr = [NSMutableArray new];
    for (int i = 0; i<[collectionView visibleCells].count; i++) {
        UICollectionViewCell *cell = [collectionView visibleCells][i];
        [arr addObject:[NSString stringWithFormat:@"%.0f",cell.frame.size.height]];
        [indexArr addObject:cell];
    }
    float max = [[arr valueForKeyPath:@"@max.floatValue"] floatValue];
           
    NSInteger cellIndex = [arr indexOfObject:[NSString stringWithFormat:@"%.0f",max]];
    if (cellIndex == NSNotFound) {
        if (arr.count%2 == 0) {
            cellIndex = arr.count/2 ;
        }else{
            cellIndex = arr.count/2+1 ;
        }
    }
    if (cellIndex<indexArr.count) {
        UICollectionViewCell *cell = indexArr[cellIndex];
        UICollectionViewCell *currentCell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell == currentCell) {
            center = YES;
        }
    }
    return center;
}

//滚动处理
- (void)scrolToPath:(NSIndexPath*)path animated:(BOOL)animated{
    
    if (self.param.tfy_Repeat?(path.row> self.data.count*COUNT-1):(path.row> self.data.count-1)){
        [self cancelTimer];
        return;
    }
    if (self.data.count==0) return;
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon://普通
            if ([self.myCollectionV isPagingEnabled]) {
                [self.myCollectionV setContentOffset: self.param.tfy_Vertical?
                 CGPointMake(0, path.row *CGRectGetHeight(self.myCollectionV.frame)):
                 CGPointMake(path.row *CGRectGetWidth(self.myCollectionV.frame), 0)
                                            animated:animated];
            }else{
                [self.myCollectionV scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
            }
            break;
        case CardtypeFallen://重叠
            [self.myCollectionV setContentOffset: self.param.tfy_Vertical?
             CGPointMake(0, path.row *CGRectGetHeight(self.myCollectionV.frame)):
             CGPointMake(path.row *CGRectGetWidth(self.myCollectionV.frame), 0)
                                        animated:animated];
            break;
        case CardtypeMultifunction://多样式
            
            break;
        default:
            break;
    }
    if ([self.myCollectionV isPagingEnabled]) return;
    
    if(self.param.tfy_ContentOffsetX>0.5){
        self.myCollectionV.contentOffset = CGPointMake(self.myCollectionV.contentOffset.x-(self.param.tfy_ContentOffsetX-0.5)*CGRectGetWidth(self.myCollectionV.frame), self.myCollectionV.contentOffset.y);
    }else if(self.param.tfy_ContentOffsetX<0.5){
        self.myCollectionV.contentOffset = CGPointMake(self.myCollectionV.contentOffset.x+CGRectGetWidth(self.myCollectionV.frame) *(0.5-self.param.tfy_ContentOffsetX), self.myCollectionV.contentOffset.y);
    }
}

#pragma mark - 私有方法

- (NSInteger)currentIndex
{
    if (CGRectGetHeight(self.frame) == 0 || CGRectGetWidth(self.frame) == 0) {
        return 0;
    }
    
    NSInteger index     = 0;
    NSInteger cellCount = [self.myCollectionV numberOfItemsInSection:0];
    
    if (self.param.tfy_scrollType == DiverseImageScrollCardSeven) {
        CGFloat anglePerItem   = self.param.tfy_anglePerItem;
        CGFloat angleAtExtreme = (cellCount - 1) * self.param.tfy_anglePerItem;
        CGFloat factor;
        // 默认停下来时，旋转的角度
        CGFloat proposedAngle;
        if (self.param.tfy_Vertical) {
            factor        = angleAtExtreme / (self.myCollectionV.contentSize.height - CGRectGetHeight(self.frame));
            proposedAngle = factor * self.myCollectionV.contentOffset.y;

        }else {
            factor        = angleAtExtreme / (self.myCollectionV.contentSize.width - CGRectGetWidth(self.frame));
            proposedAngle = factor * self.myCollectionV.contentOffset.x;
        }
        CGFloat ratio = proposedAngle / anglePerItem;
        index         = roundf(ratio);
    }else {
        if (self.param.tfy_Vertical) {
            index = roundf((self.myCollectionV.contentOffset.y + CGRectGetHeight(self.frame) / 2 - (self.param.tfy_ItemSize.height + self.param.tfy_space) / 2) / (self.param.tfy_ItemSize.height + self.param.tfy_space));
        }else {
            index = roundf((self.myCollectionV.contentOffset.x + CGRectGetWidth(self.frame) / 2 - (self.param.tfy_ItemSize.width + self.param.tfy_space) / 2) / (self.param.tfy_ItemSize.width + self.param.tfy_space));
        }
    }
    if (index < 0) {
        index = 0;
    }
    if (index >= cellCount) {
        index = cellCount - 1;
    }
    return index;
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.data.count;
}


//定时器
- (void)createTimer {
    SEL sel = NSSelectorFromString(self.param.tfy_Marquee?@"autoMarqueenScrollAction":@"autoScrollAction");
    CGFloat value_time = self.param.tfy_Marquee?marginTime:self.param.tfy_AutoScrollSecond;
    switch (self.param.tfy_Time) {
        case BannTimeTypeGCD:{
            NSString *time = [BannerTime bannerTimerWithTarget:self selector:sel StartTime:1 interval:value_time repeats:YES mainQueue:YES];
            self.gcd_timer = time;
        }
            break;
        case BannTimeTypeTime:{
            if (self.timer == nil) {
                NSTimer *timer = [NSTimer timerWithTimeInterval:value_time target:self selector:sel userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                self.timer = timer;
            }
        }
            break;
        default:
            break;
    }
}

//定时器方法 自动滚动
- (void)autoScrollAction{
    if (beganDragging) return;
    if (!self.superview) return;
    if (!self.param.tfy_AutoScroll) {
        [self cancelTimer];
        return;
    }
    self.param.myCurrentPath += 1;
    if (self.param.tfy_Repeat&&  self.param.myCurrentPath == (self.data.count*COUNT - 1)) {
       self.param.myCurrentPath = 0;
    }
    else if(!self.param.tfy_Repeat&&  self.param.myCurrentPath == self.data.count){
        [self cancelTimer];
        return;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem: self.param.myCurrentPath inSection:0];
    [self scrolToPath:nextIndexPath animated:YES];
}

//定时器方法 跑马灯
- (void)autoMarqueenScrollAction{
    if (!self.superview) return;
    if (!self.param.tfy_AutoScroll) {
        [self cancelTimer];
        return;
    }
    NSValue *value = nil;
    if (self.param.tfy_Vertical) {
        CGFloat OffsetY = self.myCollectionV.contentOffset.y + self.param.tfy_MarqueeRate;
        if (OffsetY >self.myCollectionV.contentSize.height) {
            OffsetY = self.myCollectionV.contentSize.height/2;
        }
        value = [NSValue valueWithCGPoint:CGPointMake(self.myCollectionV.contentOffset.x, OffsetY)];
    }else{
        CGFloat OffsetX = self.myCollectionV.contentOffset.x + self.param.tfy_MarqueeRate;
        if (OffsetX >self.myCollectionV.contentSize.width) {
            OffsetX = self.myCollectionV.contentSize.width/2;
        }
        value = [NSValue valueWithCGPoint:CGPointMake(OffsetX, self.myCollectionV.contentOffset.y)];
    }
    [self.myCollectionV setContentOffset:value.CGPointValue];
}

//定时器销毁
- (void)cancelTimer {
    switch (self.param.tfy_Time) {
        case BannTimeTypeGCD:{
            [BannerTime bannerCancel:self.gcd_timer];
        }
            break;
        case BannTimeTypeTime:{
            if (self.timer!=nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
            break;
        default:
            break;
    }
}

//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beganDragging = YES;
    if (!self.param.tfy_Marquee) {
        if (self.param.tfy_AutoScroll) {
            [self cancelTimer];
        }
    }else{
        [self cancelTimer];
        [self performSelector:@selector(createTimer) withObject:nil afterDelay:self.param.tfy_AutoScrollSecond];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = 0;
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
                index =  self.param.tfy_Vertical?
                                   scrollView.contentOffset.y/scrollView.frame.size.height:
                                   scrollView.contentOffset.x/scrollView.frame.size.width;
                self.param.myCurrentPath = index;
            }else{
                index = self.param.myCurrentPath;
            }
            break;
        case CardtypeFallen:
            if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
                index = self.param.myCurrentPath;
            }
            break;
        case CardtypeMultifunction:
            
            break;
        default:
            break;
    }
    self.bannerControl.currentPage = self.param.tfy_Repeat?index %self.data.count:index;
    if (self.param.tfy_EventDidScroll) {
        self.param.tfy_EventDidScroll(scrollView.contentOffset);
    }
    [self setUpSpecialFrame];
}

//拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    beganDragging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!self.param.tfy_Marquee) {
        if (![self.myCollectionV isPagingEnabled]) {
            self.bannerControl.currentPage = self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath;
        }
        if (self.param.tfy_AutoScroll) {
            [self createTimer];
        }
        [self setUpSpecialFrame];
        [self scrollEnd:[NSIndexPath indexPathForRow:self.param.myCurrentPath inSection:0]];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            
            break;
        case CardtypeFallen:
            self.param.myCurrentPath = self.param.tfy_Vertical?
                  MAX(floor(scrollView.contentOffset.y / scrollView.bounds.size.height ), 0):
                  MAX(floor(scrollView.contentOffset.x / scrollView.bounds.size.width ), 0);
            break;
        case CardtypeMultifunction:
            
            break;
        default:
            
            break;
    }
    [self scrollEnd:[NSIndexPath indexPathForRow:self.param.myCurrentPath inSection:0]];
    [self setUpSpecialFrame];
}

//更新下划线位置
- (void)setUpSpecialFrame{
    if (!self.param.tfy_SpecialStyle) return;
    if (!self.data.count) return;

    if (self.param.tfy_SpecialStyle == SpecialStyleLine) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.line.frame;
            rect.origin.x = (self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath)*rect.size.width;
            self.line.frame = rect;
        }];
    }
}

- (void)scrollEnd:(NSIndexPath*)indexPath{
    if (!self.data.count) return;
    if (self.param.tfy_Marquee) return;
    NSInteger indexCountPath = 0;
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            indexCountPath = self.param.myCurrentPath;
            break;
        case CardtypeFallen:
            indexCountPath = self.param.overFactPath;
            break;
        case CardtypeMultifunction:
            
            break;
        default:
            break;
    }
    NSInteger current = MAX(indexCountPath, 0);
    NSInteger index =  self.param.tfy_Repeat?current%self.data.count:current;
    if (index>self.data.count-1) {
        index = 0;
    }
    //取上一张
    id dic = self.data[index];
    if (self.param.tfy_EventScrollEnd) {
        BOOL center = [self checkCellInCenterCollectionView:self.myCollectionV AtIndexPath:indexPath];
        UICollectionViewCell *currentCell = (UICollectionViewCell*)[self.myCollectionV cellForItemAtIndexPath:indexPath];
        self.param.tfy_EventScrollEnd(dic, index, center,currentCell);
    }
    if (self.param.tfy_Effect) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setIconData:self.bgImgView  withData:dic[self.param.tfy_DataParamIconName]];
        }else{
            [self setIconData:self.bgImgView  withData:dic];
        }
    }
    self.bannerControl.currentPage =  index;
    
    if (self.param.tfy_EventDidScroll) {
        self.param.tfy_EventDidScroll(self.myCollectionV.contentOffset);
    }
    self.lastIndex = current;
}

- (UICollectionView *)myCollectionV{
    if (!_myCollectionV) {
        _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_flowL];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        _myCollectionV.showsVerticalScrollIndicator = NO;
        _myCollectionV.showsHorizontalScrollIndicator = NO;
        _myCollectionV.backgroundColor = [UIColor clearColor];
        _myCollectionV.decelerationRate = _param.tfy_DecelerationRate;
    }
    return _myCollectionV;
}

- (void)dealloc{
    //单纯调用这里无法消除定时器
    [self cancelTimer];
}

//要配合这里调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        // 销毁定时器
        switch (self.param.tfy_Time) {
            case BannTimeTypeGCD:{
                [BannerTime bannerCancel:self.gcd_timer];
            }
                break;
            case BannTimeTypeTime:{
                if (self.timer!=nil) {
                    [self.timer invalidate];
                    self.timer = nil;
                }
            }
                break;
            default:
                break;
        }
    }
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
    }
    return _line;
}

@end

@implementation Collectioncell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.icon = [TFY_BannerImageView new];
        self.icon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.icon];
        self.icon.frame = self.contentView.bounds;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setParam:(TFY_BannerParam *)param{
    _param = param;
    self.icon.contentMode = param.tfy_ImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleToFill;
}
@end

@implementation CollectionTextCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [UILabel new];
        self.label.font = [UIFont systemFontOfSize:17.0];
        self.label.textColor = [UIColor redColor];
        [self.contentView addSubview:self.label];
        self.label.frame = CGRectMake(10, 0, CGRectGetWidth(frame)-20, CGRectGetHeight(frame));
    }
    return self;
}

- (void)setParam:(TFY_BannerParam *)param{
    _param = param;
    self.label.textColor = self.param.tfy_MarqueeTextColor;
}

@end

@implementation BannerTime

static int i = 0;
// 创建保存timer的容器
static NSMutableDictionary *timers;
dispatch_semaphore_t sem;

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        sem = dispatch_semaphore_create(1);
    });
}

+ (NSString *)bannerTimerWithTarget:(id)target selector:(SEL)selector StartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats mainQueue:(BOOL)async{
    if (!target || !selector) {
        return nil;
    }
    return [self bannerTimerWithStartTime:start interval:interval repeats:repeats mainQueue:async completion:^{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:nil afterDelay:start];
        }
    }];
}

+ (NSString *)bannerTimerWithStartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats mainQueue:(BOOL)async completion:(void (^)(void))completion {
    if (!completion || start < 0 ||  interval <= 0) {
        return nil;
    }
    // 创建定时器
    dispatch_queue_t queue = !async ? dispatch_queue_create("gcd.timer.queue", NULL) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue );
    // 设置时间,从什么时候开始，间隔多少，下面相当于2s后开始，每隔一秒一次
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    NSString *timerId = [NSString stringWithFormat:@"%d",i++];
    timers[timerId]=timer;
    dispatch_semaphore_signal(sem);
    // 回调
    dispatch_source_set_event_handler(timer, ^{
        if (completion) {
            completion();
        }
        // 不重复执行就取消timer
        if (!repeats) {
            [self bannerCancel:timerId];
        }
    });
    dispatch_resume(timer);
    return timerId;
}

+ (void)bannerCancel:(NSString *)timerID{
    if (!timerID || timerID.length <= 0) {
        return;
    }
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers[timerID];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers removeObjectForKey:timerID];
    }
    dispatch_semaphore_signal(sem);
}



@end
