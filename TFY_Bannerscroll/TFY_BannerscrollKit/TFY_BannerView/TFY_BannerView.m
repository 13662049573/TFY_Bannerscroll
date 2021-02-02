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
}
@property(strong,nonatomic)UICollectionView *myCollectionV;
@property(strong,nonatomic)UICollectionViewFlowLayout *flowL ;
@property(strong,nonatomic)TFY_BannerPageControl *bannerControl ;
@property(strong,nonatomic)NSArray *data;
@property(strong,nonatomic)TFY_BannerParam *param;
@property(copy,nonatomic)NSString *gcd_timer;
@property(strong,nonatomic)NSTimer *timer;
@property(weak,nonatomic)UIVisualEffectView *effectView;
@end

@implementation TFY_BannerView

- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param withView:(UIView*)parentView{
    if (self = [super init]) {
        self.param = param;
        if (parentView) {
            [parentView addSubview:self];
        }
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
    [UIView animateWithDuration:0.0 animations:^{
        [self.myCollectionV reloadData];
        if (self.param.tfy_SelectIndex|| self.param.tfy_Repeat) {
            NSIndexPath *path = [NSIndexPath indexPathForRow: self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex inSection:0];
            [self scrolToPath:path animated:NO];
            self.bannerControl.currentPage = self.param.tfy_SelectIndex;
            self.param.myCurrentPath = self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex;
            if (self.param.tfy_AutoScroll) {
                [self createTimer];
            }else{
                [self cancelTimer];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollEnd:[NSIndexPath indexPathForRow: self.param.tfy_Repeat?((COUNT/2)*self.data.count+self.param.tfy_SelectIndex):self.param.tfy_SelectIndex inSection:0]];
        });
    } completion:^(BOOL finished) {}];
    
    
}

- (void)setUp{
    if (self.param.tfy_Marquee) {
        self.param.tfy_AutoScroll = YES;
        self.param.tfy_HideBannerControl = YES;
        self.param.tfy_AutoScrollSecond = 0.05f;
        self.param.tfy_Repeat = YES;
    }
    
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
    if (self.param.tfy_MyCellClassName) {
        [self.myCollectionV registerClass:NSClassFromString(self.param.tfy_MyCellClassName) forCellWithReuseIdentifier:self.param.tfy_MyCellClassName];
    }
    self.myCollectionV.frame = self.bounds;
    self.myCollectionV.pagingEnabled = (self.param.tfy_ItemSize.width == CGRectGetWidth(self.myCollectionV.frame) && self.param.tfy_LineSpacing == 0)||self.param.tfy_Vertical;
    if ([self.myCollectionV isPagingEnabled]) {
        self.myCollectionV.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    
   
    self.bannerControl = [[TFY_BannerPageControl alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame)-20, 30)];
    self.bannerControl.pageControlType = PageControlTypeCircle;
    if (self.param.tfy_CustomControl) {
        self.param.tfy_CustomControl(self.bannerControl);
    }
    if (!self.param.tfy_HideBannerControl) {
        [self addSubview:self.bannerControl];
    }
    
    self.bgImgView = [[TFY_BannerImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*self.param.tfy_EffectHeight)];
    [self addSubview:self.bgImgView];
    [self sendSubviewToBack:self.bgImgView];
    self.bgImgView.hidden = !self.param.tfy_Effect;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.param.tfy_EffectStyle];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bgImgView.bounds;
    effectView.alpha = self.param.tfy_EffectAlpha;
    [self.bgImgView addSubview:effectView];
    self.effectView = effectView;
    
    [self resetCollection];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = self.param.tfy_Repeat?indexPath.row%self.data.count:indexPath.row;
    id dic = self.data[index];
    if (self.param.tfy_MyCell) {
        return self.param.tfy_MyCell([NSIndexPath indexPathForRow:index inSection:indexPath.section], collectionView, dic,self.bgImgView,self.data);
    }else{
        //默认视图
        Collectioncell *cell = (Collectioncell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Collectioncell class]) forIndexPath:indexPath];
        cell.param = self.param;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setIconData:cell.icon withData:dic[self.param.tfy_DataParamIconName]];

        }else{
            [self setIconData:cell.icon withData:dic];
        }
        return cell;
    }
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
- (dispatch_queue_t )getImageOperatorQueue{
    static dispatch_queue_t  _imageOperatorQueue;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        //第二个参数 传入 DISPATCH_QUEUE_SERIAL 或 NULL 表示创建串行队列。传入 DISPATCH_QUEUE_CONCURRENT 表示创建并行队列
        _imageOperatorQueue = dispatch_queue_create([@"imageOperatorQueue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    });
    return _imageOperatorQueue;
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
                [self.myCollectionV scrollToItemAtIndexPath:path atScrollPosition:
                 self.param.tfy_Vertical?UICollectionViewScrollPositionCenteredVertically:
                                      UICollectionViewScrollPositionCenteredHorizontally animated:animated];
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
    if ([self.myCollectionV isPagingEnabled]||self.param.tfy_CardOverLap) return;
    
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
    switch (self.param.tfy_Time) {
        case BannTimeTypeGCD:{
            NSString *time = [BannerTime bannerTimerWithTarget:self selector:sel StartTime:1 interval:self.param.tfy_AutoScrollSecond repeats:YES mainQueue:YES];
            self.gcd_timer = time;
        }
            break;
        case BannTimeTypeTime:{
            if (self.timer == nil) {
                NSTimer *timer = [NSTimer timerWithTimeInterval:self.param.tfy_AutoScrollSecond target:self selector:sel userInfo:nil repeats:YES];
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
    self.param.myCurrentPath+=1;
    if (self.param.tfy_Repeat&&  self.param.myCurrentPath == (self.data.count*COUNT)) {
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
    if (self.param.tfy_Vertical) {
        CGFloat OffsetY = self.myCollectionV.contentOffset.y + self.param.tfy_MarqueeRate;
        if (OffsetY >self.myCollectionV.contentSize.height) {
            OffsetY = self.myCollectionV.contentSize.height/2;
        }
        [self.myCollectionV setContentOffset:CGPointMake(self.myCollectionV.contentOffset.x, OffsetY) animated:NO];
    }else{
        CGFloat OffsetX = self.myCollectionV.contentOffset.x + self.param.tfy_MarqueeRate;
        if (OffsetX >self.myCollectionV.contentSize.width) {
            OffsetX = self.myCollectionV.contentSize.width/2;
        }
        [self.myCollectionV setContentOffset:CGPointMake(OffsetX, self.myCollectionV.contentOffset.y) animated:NO];
    }
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
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
                NSInteger index =  self.param.tfy_Vertical?
                                   scrollView.contentOffset.y/scrollView.frame.size.height:
                                   scrollView.contentOffset.x/scrollView.frame.size.width;
                self.param.myCurrentPath = index;
                self.bannerControl.currentPage = self.param.tfy_Repeat?index %self.data.count:index;
            }
            break;
        case CardtypeFallen:
            if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
                NSInteger index = self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath;
                self.bannerControl.currentPage = self.param.tfy_Repeat?index %self.data.count:index;
            }
            break;
        case CardtypeMultifunction:
            
            break;
        default:
            break;
    }
}

//拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    beganDragging = NO;
    if (!self.param.tfy_Marquee) {
        if (![self.myCollectionV isPagingEnabled]) {
            self.bannerControl.currentPage = self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath;
        }
        if (self.param.tfy_AutoScroll) {
            [self createTimer];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollEnd:[NSIndexPath indexPathForRow:self.param.myCurrentPath inSection:0]];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   [self scrollEnd:[NSIndexPath indexPathForRow:self.param.myCurrentPath inSection:0]];
}

- (void)scrollEnd:(NSIndexPath*)indexPath{
    if (!self.data.count) return;
    if (self.param.tfy_Marquee) return;
    NSInteger index = self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath;
    if (index>self.data.count-1) {
        index = 0;
    }
    id dic = self.data[index];
    if (self.param.tfy_EventScrollEnd) {
        NSLog(@"%ld",self.param.myCurrentPath);
        NSLog(@"%ld",indexPath.item);
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
