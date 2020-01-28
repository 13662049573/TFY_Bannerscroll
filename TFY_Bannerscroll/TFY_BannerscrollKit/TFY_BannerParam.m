//
//  TFY_BannerParam.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BannerParam.h"

@implementation TFY_BannerParam
/**本类初始化*/
TFY_BannerParam *paramModel(void){
    return [[TFY_BannerParam alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tfy_Scale=NO;
        self.tfy_CardOverLap= NO;
        self.tfy_Effect = NO;
        self.tfy_HideBannerControl = NO;
        self.tfy_CanFingerSliding = YES;
        self.tfy_ImageFill = YES;
        self.tfy_Repeat = NO;
        self.tfy_AutoScroll = NO;
        self.tfy_Vertical = NO;
        self.tfy_Marquee = NO;
        self.tfy_SectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tfy_ScreenScale = 1;
        self.tfy_EffectHeight = 1;
        self.tfy_ScaleFactor = 0.5;
        self.tfy_Alpha = 1;
        self.tfy_ActiveDistance = 400;
        self.tfy_LineSpacing = 0;
        self.tfy_ContentOffsetX = 0.5;
        self.tfy_Position = BannerCellPositionCenter;
        self.tfy_AutoScrollSecond =3;
        self.tfy_SelectIndex = 0;
        self.tfy_BannerControlColor = [UIColor whiteColor];
        self.tfy_BannerControlSelectColor = [UIColor orangeColor];
        self.tfy_BannerControlImageSize = CGSizeMake(10, 10);
        self.tfy_BannerControlSelectImageSize = CGSizeMake(10, 10);
        self.tfy_BannerControlSelectMargin = 3;
        self.tfy_MarqueeTextColor = [UIColor redColor];
        self.tfy_MarqueeRate = 5;
        self.tfy_DecelerationRate = 0.1;
        self.tfy_DataParamIconName = @"icon";
    }
    return self;
}

/**布局方式 frame  必传*/
- (TFY_BannerParam * (^) (CGRect tfy_Frame))tfy_FrameSet{
    BannerWSelf(myself);
     return ^(CGRect tfy_Frame) {
                 myself.tfy_Frame = tfy_Frame;
          return myself;
     };
}
/**数据源 必传*/
-(TFY_BannerParam *(^)(NSArray *tfy_data))tfy_dataSet{
    BannerWSelf(myself);
    return ^(NSArray *tfy_data){
        myself.tfy_data= tfy_data;
        return myself;
    };
}
/**开启缩放 default NO*/
-(TFY_BannerParam *(^)(BOOL tfy_Scale))tfy_ScaleSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_Scale){
        myself.tfy_Scale = tfy_Scale;
        return myself;
    };
}
/**开启卡片重叠模式 default NO*/
-(TFY_BannerParam *(^)(BOOL tfy_CardOverLap))tfy_CardOverLapSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_CardOverLap){
        myself.tfy_CardOverLap = tfy_CardOverLap;
        return myself;
    };
}
/**背景毛玻璃效果 default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_Effect))tfy_EffectSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_Effect){
        myself.tfy_Effect = tfy_Effect;
        return myself;
    };
}
/**隐藏pageControl default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_HideBannerControl))tfy_HideBannerControlSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_HideBannerControl){
        myself.tfy_HideBannerControl = tfy_HideBannerControl;
        return myself;
    };
}

/**是否允许手势滑动 default YES*/
- (TFY_BannerParam * (^) (BOOL tfy_CanFingerSliding))tfy_CanFingerSlidingSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_CanFingerSliding){
        myself.tfy_CanFingerSliding = tfy_CanFingerSliding;
        return myself;
    };
}

/**图片不变形铺满 默认 YES*/
- (TFY_BannerParam * (^) (BOOL tfy_ImageFill))tfy_ImageFillSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_ImageFill){
        myself.tfy_ImageFill = tfy_ImageFill;
        return myself;
    };
}

/**开启无线滚动 default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_Repeat))tfy_RepeatSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_Repeat){
        myself.tfy_Repeat = tfy_Repeat;
        return myself;
    };
}

/**开启自动滚动 default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_AutoScroll))tfy_AutoScrollSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_AutoScroll){
        myself.tfy_AutoScroll = tfy_AutoScroll;
        return myself;
    };
}

/**纵向(cell全屏的时候有效) default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_Vertical))tfy_VerticalSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_Vertical){
        myself.tfy_Vertical = tfy_Vertical;
        return myself;
    };
}

/**跑马灯(文字效果) default NO*/
- (TFY_BannerParam * (^) (BOOL tfy_Marquee))tfy_MarqueeSet{
    BannerWSelf(myself);
    return ^(BOOL tfy_Marquee){
        myself.tfy_Marquee = tfy_Marquee;
        return myself;
    };
}

/**整体间距 默认UIEdgeInsetsMake(0,0, 0, 0)*/
- (TFY_BannerParam * (^) (UIEdgeInsets tfy_SectionInset))tfy_SectionInsetSet{
    BannerWSelf(myself);
    return ^(UIEdgeInsets tfy_SectionInset){
        myself.tfy_SectionInset = tfy_SectionInset;
        return myself;
    };
}

/**整体视图缩放系数 default 1*/
- (TFY_BannerParam * (^) (CGFloat tfy_ScreenScale))tfy_ScreenScaleSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_ScreenScale){
        myself.tfy_ScreenScale = tfy_ScreenScale;
        return myself;
    };
}

/**毛玻璃背景的高度 (视图的高度*倍数) default 1 范围0~1*/
- (TFY_BannerParam * (^) (CGFloat tfy_EffectHeight))tfy_EffectHeightSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_EffectHeight){
        myself.tfy_EffectHeight = tfy_EffectHeight;
        return myself;
    };
}

/**缩放系数 数值越大缩放越大 default 0.5 卡片叠加效果时默认为0.8*/
- (TFY_BannerParam * (^) (CGFloat tfy_ScaleFactor))tfy_ScaleFactorSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_ScaleFactor){
        myself.tfy_ScaleFactor = tfy_ScaleFactor;
        return myself;
    };
}

/**左右的透明度 default 1*/
- (TFY_BannerParam * (^) (CGFloat tfy_Alpha))tfy_AlphaSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_Alpha){
        myself.tfy_Alpha = tfy_Alpha;
        return myself;
    };
}

/**垂直缩放 数值越大缩放越小 default 400*/
- (TFY_BannerParam * (^) (CGFloat tfy_ActiveDistance))tfy_ActiveDistanceSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_ActiveDistance){
        myself.tfy_ActiveDistance = tfy_ActiveDistance;
        return myself;
    };
}

/**item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)*/
- (TFY_BannerParam * (^) (CGSize tfy_ItemSize))tfy_ItemSizeSet{
    BannerWSelf(myself);
    return ^(CGSize tfy_ItemSize){
        myself.tfy_ItemSize = tfy_ItemSize;
        return myself;
    };
}

/**item的之间的间距 default 0*/
- (TFY_BannerParam * (^) (CGFloat tfy_LineSpacing))tfy_LineSpacingSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_LineSpacing){
        myself.tfy_LineSpacing = tfy_LineSpacing;
        return myself;
    };
}

/**滑动的时候偏移的距离 以倍数计算 default 0.5 正中间*/
- (TFY_BannerParam * (^) (CGFloat tfy_ContentOffsetX))tfy_ContentOffsetXSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_ContentOffsetX){
        myself.tfy_ContentOffsetX = tfy_ContentOffsetX;
        return myself;
    };
}

/**左右相邻item的中心点 default BannerCellPositionCenter*/
- (TFY_BannerParam * (^) (BannerCellPosition tfy_Position))tfy_PositionSet{
    BannerWSelf(myself);
    return ^(BannerCellPosition tfy_Position){
        myself.tfy_Position = tfy_Position;
        return myself;
    };
}

/**占位图片*/
- (TFY_BannerParam * (^) (NSString *tfy_PlaceholderImage))tfy_PlaceholderImageSet{
    BannerWSelf(myself);
    return ^(NSString *tfy_PlaceholderImage){
        myself.tfy_PlaceholderImage = tfy_PlaceholderImage;
        return myself;
    };
}

/**数据源的图片字段 默认 icon*/
- (TFY_BannerParam * (^) (NSString *tfy_DataParamIconName))tfy_DataParamIconNameSet{
    BannerWSelf(myself);
    return ^(NSString *tfy_DataParamIconName){
        myself.tfy_DataParamIconName = tfy_DataParamIconName;
        return myself;
    };
}

/**滚动减速时间 default UIScrollViewDecelerationRateFast*/
- (TFY_BannerParam * (^) (UIScrollViewDecelerationRate tfy_DecelerationRate))tfy_DecelerationRateSet{
    BannerWSelf(myself);
    return ^(UIScrollViewDecelerationRate tfy_DecelerationRate){
        myself.tfy_DecelerationRate = tfy_DecelerationRate;
        return myself;
    };
}

/**自动滚动间隔时间 default 3.0f*/
- (TFY_BannerParam * (^) (CGFloat tfy_AutoScrollSecond))tfy_AutoScrollSecondSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_AutoScrollSecond){
        myself.tfy_AutoScrollSecond = tfy_AutoScrollSecond;
        return myself;
    };
}

/**默认移动到第几个 default 0*/
- (TFY_BannerParam * (^) (NSInteger tfy_SelectIndex))tfy_SelectIndexSet{
    BannerWSelf(myself);
    return ^(NSInteger tfy_SelectIndex){
        myself.tfy_SelectIndex = tfy_SelectIndex;
        return myself;
    };
}

/**自定义cell内容 默认是Collectioncell类*/
- (TFY_BannerParam * (^) (BannerCellCallBlock tfy_MyCell))tfy_MyCellSet{
    BannerWSelf(myself);
    return ^(BannerCellCallBlock tfy_MyCell){
        myself.tfy_MyCell = tfy_MyCell;
        return myself;
    };
}

/**自定义cell的类名 自定义视图必传 不然会crash*/
- (TFY_BannerParam * (^) (NSString *tfy_MyCellClassName))tfy_MyCellClassNameSet{
    BannerWSelf(myself);
       return ^(NSString *tfy_MyCellClassName){
           myself.tfy_MyCellClassName = tfy_MyCellClassName;
           return myself;
       };
}
/**系统的圆点颜色  default  ffffff*/
- (TFY_BannerParam * (^) (UIColor *tfy_BannerControlColor))tfy_BannerControlColorSet{
    BannerWSelf(myself);
    return ^(UIColor *tfy_BannerControlColor){
        myself.tfy_BannerControlColor = tfy_BannerControlColor;
        return myself;
    };
}

/**系统的圆点选中颜色  default  orange*/
- (TFY_BannerParam * (^) (UIColor *tfy_BannerControlSelectColor))tfy_BannerControlSelectColorSet{
    BannerWSelf(myself);
    return ^(UIColor *tfy_BannerControlSelectColor){
        myself.tfy_BannerControlSelectColor = tfy_BannerControlSelectColor;
        return myself;
    };
}

/**跑马灯文字颜色  default  red*/
- (TFY_BannerParam * (^) (UIColor *tfy_MarqueeTextColor))tfy_MarqueeTextColorSet{
    BannerWSelf(myself);
    return ^(UIColor *tfy_MarqueeTextColor){
        myself.tfy_MarqueeTextColor = tfy_MarqueeTextColor;
        return myself;
    };
}

/**自定义安全的圆点图标 */
- (TFY_BannerParam * (^) (NSString *tfy_BannerControlImage))tfy_BannerControlImageSet{
    BannerWSelf(myself);
    return ^(NSString *tfy_BannerControlImage){
        myself.tfy_BannerControlImage = tfy_BannerControlImage;
        return myself;
    };
}

/**自定义安全的选中圆点图标 */
- (TFY_BannerParam * (^) (NSString *tfy_BannerControlSelectImage))tfy_BannerControlSelectImageSet{
    BannerWSelf(myself);
    return ^(NSString *tfy_BannerControlSelectImage){
        myself.tfy_BannerControlSelectImage = tfy_BannerControlSelectImage;
        return myself;
    };
}

/**自定义安全的圆点图片圆角 default ImageSize/2*/
- (TFY_BannerParam * (^) (CGFloat tfy_BannerControlImageRadius))tfy_BannerControlImageRadiusSet{
    BannerWSelf(myself);
       return ^(CGFloat tfy_BannerControlImageRadius){
           myself.tfy_BannerControlImageRadius = tfy_BannerControlImageRadius;
           return myself;
       };
}

/**自定义安全的圆点图标的size  default (10,10)*/
- (TFY_BannerParam * (^) (CGSize tfy_BannerControlImageSize))tfy_BannerControlImageSizeSet{
    BannerWSelf(myself);
    return ^(CGSize tfy_BannerControlImageSize){
        myself.tfy_BannerControlImageSize = tfy_BannerControlImageSize;
        return myself;
    };
}

/**自定义安全的选中圆点图标的size (10,10)*/
- (TFY_BannerParam * (^) (CGSize tfy_BannerControlSelectImageSize))tfy_BannerControlSelectImageSizeSet{
    BannerWSelf(myself);
    return ^(CGSize tfy_BannerControlSelectImageSize){
        myself.tfy_BannerControlSelectImageSize = tfy_BannerControlSelectImageSize;
        return myself;
    };
}

/**自定义圆点的间距 default 3*/
- (TFY_BannerParam * (^) (CGFloat tfy_BannerControlSelectMargin))tfy_BannerControlSelectMarginSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_BannerControlSelectMargin){
        myself.tfy_BannerControlSelectMargin = tfy_BannerControlSelectMargin;
        return myself;
    };
}

/**自定义pageControl*/
- (TFY_BannerParam * (^) (BannerPageControl tfy_CustomControl))tfy_CustomControlSet{
    BannerWSelf(myself);
    return ^(BannerPageControl tfy_CustomControl){
        myself.tfy_CustomControl = tfy_CustomControl;
        return myself;
    };
}

/**pageControl的位置 default BannerControlCenter*/
- (TFY_BannerParam * (^) (BannerControlPosition tfy_BannerControlPosition))tfy_BannerControlPositionSet{
    BannerWSelf(myself);
    return ^(BannerControlPosition tfy_BannerControlPosition){
        myself.tfy_BannerControlPosition = tfy_BannerControlPosition;
        return myself;
    };
}

/**跑马灯速度  default  5*/
- (TFY_BannerParam * (^) (CGFloat tfy_MarqueeRate))tfy_MarqueeRateSet{
    BannerWSelf(myself);
    return ^(CGFloat tfy_MarqueeRate){
        myself.tfy_MarqueeRate = tfy_MarqueeRate;
        return myself;
    };
}

/**点击方法*/
- (TFY_BannerParam * (^) (BannerClickBlock tfy_EventClick))tfy_EventClickSet{
    BannerWSelf(myself);
    return ^(BannerClickBlock tfy_EventClick){
        myself.tfy_EventClick = tfy_EventClick;
        return myself;
    };
}

/**点击方法 可获取居中cell*/
- (TFY_BannerParam * (^) (BannerCenterClickBlock tfy_EventCenterClick))tfy_EventCenterClickSet{
    BannerWSelf(myself);
    return ^(BannerCenterClickBlock tfy_EventCenterClick){
        myself.tfy_EventCenterClick = tfy_EventCenterClick;
        return myself;
    };
}

/**每次滚动结束都会调用 最好是关闭自动滚动的场景使用*/
- (TFY_BannerParam * (^) (BannerScrollEndBlock tfy_EventScrollEnd))tfy_EventScrollEndSet{
    BannerWSelf(myself);
    return ^(BannerScrollEndBlock tfy_EventScrollEnd){
        myself.tfy_EventScrollEnd = tfy_EventScrollEnd;
        return myself;
    };
}
@end

