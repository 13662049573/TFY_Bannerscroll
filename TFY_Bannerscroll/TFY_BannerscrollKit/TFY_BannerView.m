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
#import "TFY_BannerControl.h"
#define COUNT 500

@interface TFY_BannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL beganDragging;
}
@property(strong,nonatomic)UICollectionView *myCollectionV;
@property(strong,nonatomic)UICollectionViewFlowLayout *flowL ;
@property(strong,nonatomic)TFY_BannerControl *bannerControl ;
@property(strong,nonatomic)NSArray *data;
@property(strong,nonatomic)TFY_BannerParam *param;
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
        self.data = [NSArray arrayWithArray:self.param.tfy_data];
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
        self.data = [NSArray arrayWithArray:self.param.tfy_data];
        [self setUp];
    }
    return self;
}

//横竖屏更新布局。
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.myCollectionV.frame = self.bounds;
    self.bgImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*self.param.tfy_EffectHeight);
    self.effectView.frame = self.bgImgView.frame;
    
    [self layoutIfNeeded];
}

- (void)updateUI{
    self.data = [NSArray arrayWithArray:self.param.tfy_data];
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
    
    if (self.param.tfy_ItemSize.height == 0 || self.param.tfy_ItemSize.width == 0 ) {
        self.param.tfy_ItemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    }

    else if(self.param.tfy_ItemSize.height>self.frame.size.height){
        self.param.tfy_ItemSize = CGSizeMake(self.param.tfy_ItemSize.width, self.frame.size.height);
    }else if(self.param.tfy_ItemSize.width>self.frame.size.width){
        self.param.tfy_ItemSize = CGSizeMake(self.frame.size.width, self.param.tfy_ItemSize.height);
    }
    
    
    if (!self.param.tfy_CardOverLap) {
        self.flowL = [[TFY_BannerFlowLayout alloc] initConfigureWithModel:self.param];;
    }else{
        self.param.tfy_Repeat = YES;
        if (self.param.tfy_ScaleFactor == 0.5) {
            self.param.tfy_ScaleFactor = 0.8f;
        }
        self.flowL = [[TFY_BannerOverLayout alloc] initConfigureWithModel:self.param];;
    }

    [self addSubview:self.myCollectionV];
    self.myCollectionV.scrollEnabled = self.param.tfy_CanFingerSliding;
    [self.myCollectionV registerClass:[Collectioncell class] forCellWithReuseIdentifier:NSStringFromClass([Collectioncell class])];
    [self.myCollectionV registerClass:[CollectionTextCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionTextCell class])];
    if (self.param.tfy_MyCellClassName) {
        [self.myCollectionV registerClass:NSClassFromString(self.param.tfy_MyCellClassName) forCellWithReuseIdentifier:self.param.tfy_MyCellClassName];
    }
    self.myCollectionV.frame = self.bounds;
    self.myCollectionV.pagingEnabled = (self.param.tfy_ItemSize.width == self.myCollectionV.frame.size.width && self.param.tfy_LineSpacing == 0)||self.param.tfy_Vertical;
    if ([self.myCollectionV isPagingEnabled]) {
        self.myCollectionV.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    
    self.bannerControl = [[TFY_BannerControl alloc]initWithFrame:CGRectMake((self.bounds.size.width - 80)/2 , self.bounds.size.height - 30,80, 30) WithModel:self.param];
    if (self.param.tfy_CustomControl) {
        self.param.tfy_CustomControl(self.bannerControl);
    }
    if (!self.param.tfy_HideBannerControl) {
        [self addSubview:self.bannerControl];
    }
    
    
    self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*self.param.tfy_EffectHeight)];
    [self addSubview:self.bgImgView];
    [self sendSubviewToBack:self.bgImgView];
    self.bgImgView.hidden = !self.param.tfy_Effect;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bgImgView.bounds;
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

- (void)setIconData:(UIImageView*)icon withData:(id)data{
    if (!data) return;
    if ([data isKindOfClass:[NSString class]]) {
        if ([(NSString*)data hasPrefix:@"http"]) {
            [icon tfy_BannerImageWithURLString:(NSString*)data placeholder:self.param.tfy_PlaceholderImage?[UIImage imageNamed:self.param.tfy_PlaceholderImage]:nil];
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
    if (self.param.tfy_CardOverLap) {
         [self.myCollectionV setContentOffset: self.param.tfy_Vertical?
          CGPointMake(0, path.row *self.myCollectionV.bounds.size.height):
          CGPointMake(path.row *self.myCollectionV.bounds.size.width, 0)
                                     animated:animated];

    }else{
        if ([self.myCollectionV isPagingEnabled]) {
            [self.myCollectionV scrollToItemAtIndexPath:path atScrollPosition:
             self.param.tfy_Vertical?UICollectionViewScrollPositionCenteredVertically:
                                  UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        }else{
            [self.myCollectionV scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        }
    }
    
    if ([self.myCollectionV isPagingEnabled]||self.param.tfy_CardOverLap) return;
    if(self.param.tfy_ContentOffsetX>0.5){
        self.myCollectionV.contentOffset = CGPointMake(self.myCollectionV.contentOffset.x-(self.param.tfy_ContentOffsetX-0.5)*self.myCollectionV.frame.size.width, self.myCollectionV.contentOffset.y);
    }else if(self.param.tfy_ContentOffsetX<0.5){
        self.myCollectionV.contentOffset = CGPointMake(self.myCollectionV.contentOffset.x+self.myCollectionV.frame.size.width *(0.5-self.param.tfy_ContentOffsetX), self.myCollectionV.contentOffset.y);
    }
}


//定时器
- (void)createTimer{
    if (!self.timer) {
        SEL sel = NSSelectorFromString(self.param.tfy_Marquee?@"autoMarqueenScrollAction":@"autoScrollAction");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.param.tfy_AutoScrollSecond  target:self selector:sel userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
- (void)cancelTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.param.tfy_CardOverLap) {
        if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
            NSInteger index = self.param.tfy_Repeat?self.param.myCurrentPath%self.data.count:self.param.myCurrentPath;
            self.bannerControl.currentPage = self.param.tfy_Repeat?index %self.data.count:index;
        }
    }else{
        if ([self.myCollectionV isPagingEnabled]&&!self.param.tfy_Marquee) {
            NSInteger index =  self.param.tfy_Vertical?
                               scrollView.contentOffset.y/scrollView.frame.size.height:
                               scrollView.contentOffset.x/scrollView.frame.size.width;
            self.param.myCurrentPath = index;
            self.bannerControl.currentPage = self.param.tfy_Repeat?index %self.data.count:index;
        }
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

- (TFY_BannerControl *)bannerControl{
    if (!_bannerControl) {
        _bannerControl = [[TFY_BannerControl alloc]initWithFrame:CGRectZero WithModel:_param];
    }
    return _bannerControl;
}

- (void)dealloc{
    //单纯调用这里无法消除定时器
    [self cancelTimer];
}

//要配合这里调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview &&self.timer) {
        // 销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

@implementation Collectioncell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.icon = [UIImageView new];
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
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [UILabel new];
        self.label.font = [UIFont systemFontOfSize:17.0];
        self.label.textColor = [UIColor redColor];
        [self.contentView addSubview:self.label];
        self.label.frame = CGRectMake(10, 0, frame.size.width-20, frame.size.height);
    }
    return self;
}

- (void)setParam:(TFY_BannerParam *)param{
    _param = param;
    self.label.textColor = self.param.tfy_MarqueeTextColor;
}

@end
