//
//  TFY_BannerParam.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_BannerConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerParam : NSObject
/**本类初始化*/
TFY_BannerParam *paramModel(void);

/**布局方式 frame  必传*/
@property(nonatomic,assign)CGRect  tfy_Frame;
- (TFY_BannerParam * (^) (CGRect tfy_Frame))tfy_FrameSet;

/**数据源 必传*/
@property(nonatomic,strong)NSArray  *tfy_data;
- (TFY_BannerParam * (^) (NSArray *tfy_data))tfy_dataSet;

/**开启缩放 default NO*/
@property(nonatomic,assign)BOOL  tfy_Scale;
- (TFY_BannerParam * (^) (BOOL tfy_Scale))tfy_ScaleSet;

/**开启卡片重叠模式 default NO*/
@property(nonatomic,assign)BOOL  tfy_CardOverLap;
- (TFY_BannerParam * (^) (BOOL tfy_CardOverLap))tfy_CardOverLapSet;

/**背景毛玻璃效果 default NO*/
@property(nonatomic,assign)BOOL  tfy_Effect;
- (TFY_BannerParam * (^) (BOOL tfy_Effect))tfy_EffectSet;

/**隐藏pageControl default NO*/
@property(nonatomic,assign)BOOL  tfy_HideBannerControl;
- (TFY_BannerParam * (^) (BOOL tfy_HideBannerControl))tfy_HideBannerControlSet;

/**是否允许手势滑动 default YES*/
@property(nonatomic,assign)BOOL  tfy_CanFingerSliding;
- (TFY_BannerParam * (^) (BOOL tfy_CanFingerSliding))tfy_CanFingerSlidingSet;

/**图片不变形铺满 默认 YES*/
@property(nonatomic,assign)BOOL  tfy_ImageFill;
- (TFY_BannerParam * (^) (BOOL tfy_ImageFill))tfy_ImageFillSet;

/**开启无线滚动 default NO*/
@property(nonatomic,assign)BOOL  tfy_Repeat;
- (TFY_BannerParam * (^) (BOOL tfy_Repeat))tfy_RepeatSet;

/**开启自动滚动 default NO*/
@property(nonatomic,assign)BOOL  tfy_AutoScroll;
- (TFY_BannerParam * (^) (BOOL tfy_AutoScroll))tfy_AutoScrollSet;

/**纵向(cell全屏的时候有效) default NO*/
@property(nonatomic,assign)BOOL  tfy_Vertical;
- (TFY_BannerParam * (^) (BOOL tfy_Vertical))tfy_VerticalSet;

/**跑马灯(文字效果) default NO*/
@property(nonatomic,assign)BOOL  tfy_Marquee;
- (TFY_BannerParam * (^) (BOOL tfy_Marquee))tfy_MarqueeSet;

/**整体间距 默认UIEdgeInsetsMake(0,0, 0, 0)*/
@property(nonatomic,assign)UIEdgeInsets  tfy_SectionInset;
- (TFY_BannerParam * (^) (UIEdgeInsets tfy_SectionInset))tfy_SectionInsetSet;

/**整体视图缩放系数 default 1*/
@property(nonatomic,assign)CGFloat  tfy_ScreenScale;
- (TFY_BannerParam * (^) (CGFloat tfy_ScreenScale))tfy_ScreenScaleSet;

/**毛玻璃背景的高度 (视图的高度*倍数) default 1 范围0~1*/
@property(nonatomic,assign)CGFloat  tfy_EffectHeight;
- (TFY_BannerParam * (^) (CGFloat tfy_EffectHeight))tfy_EffectHeightSet;

/**缩放系数 数值越大缩放越大 default 0.5 卡片叠加效果时默认为0.8*/
@property(nonatomic,assign)CGFloat  tfy_ScaleFactor;
- (TFY_BannerParam * (^) (CGFloat tfy_ScaleFactor))tfy_ScaleFactorSet;

/**左右的透明度 default 1*/
@property(nonatomic,assign)CGFloat  tfy_Alpha;
- (TFY_BannerParam * (^) (CGFloat tfy_Alpha))tfy_AlphaSet;

/**垂直缩放 数值越大缩放越小 default 400*/
@property(nonatomic,assign)CGFloat  tfy_ActiveDistance;
- (TFY_BannerParam * (^) (CGFloat tfy_ActiveDistance))tfy_ActiveDistanceSet;

/**item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)*/
@property(nonatomic,assign)CGSize  tfy_ItemSize;
- (TFY_BannerParam * (^) (CGSize tfy_ItemSize))tfy_ItemSizeSet;

/**item的之间的间距 default 0*/
@property(nonatomic,assign)CGFloat  tfy_LineSpacing;
- (TFY_BannerParam * (^) (CGFloat tfy_LineSpacing))tfy_LineSpacingSet;

/**滑动的时候偏移的距离 以倍数计算 default 0.5 正中间*/
@property(nonatomic,assign)CGFloat  tfy_ContentOffsetX;
- (TFY_BannerParam * (^) (CGFloat tfy_ContentOffsetX))tfy_ContentOffsetXSet;

/**左右相邻item的中心点 default BannerCellPositionCenter*/
@property(nonatomic,assign)BannerCellPosition  tfy_Position;
- (TFY_BannerParam * (^) (BannerCellPosition tfy_Position))tfy_PositionSet;

/**占位图片*/
@property(nonatomic,copy)NSString  *tfy_PlaceholderImage;
- (TFY_BannerParam * (^) (NSString *tfy_PlaceholderImage))tfy_PlaceholderImageSet;

/**数据源的图片字段 默认 icon*/
@property(nonatomic,copy)NSString  *tfy_DataParamIconName;
- (TFY_BannerParam * (^) (NSString *tfy_DataParamIconName))tfy_DataParamIconNameSet;

/**滚动减速时间 default UIScrollViewDecelerationRateFast*/
@property(nonatomic,assign)UIScrollViewDecelerationRate  tfy_DecelerationRate;
- (TFY_BannerParam * (^) (UIScrollViewDecelerationRate tfy_DecelerationRate))tfy_DecelerationRateSet;

/**自动滚动间隔时间 default 3.0f*/
@property(nonatomic,assign)CGFloat  tfy_AutoScrollSecond;
- (TFY_BannerParam * (^) (CGFloat tfy_AutoScrollSecond))tfy_AutoScrollSecondSet;

/**默认移动到第几个 default 0*/
@property(nonatomic,assign)NSInteger  tfy_SelectIndex;
- (TFY_BannerParam * (^) (NSInteger tfy_SelectIndex))tfy_SelectIndexSet;

/**自定义cell内容 默认是Collectioncell类*/
@property(nonatomic,copy)BannerCellCallBlock  tfy_MyCell;
- (TFY_BannerParam * (^) (BannerCellCallBlock tfy_MyCell))tfy_MyCellSet;

/**自定义cell的类名 自定义视图必传 不然会crash*/
@property(nonatomic,copy)NSString  *tfy_MyCellClassName;
- (TFY_BannerParam * (^) (NSString *tfy_MyCellClassName))tfy_MyCellClassNameSet;

/**系统的圆点颜色  default  ffffff*/
@property(nonatomic,strong)UIColor  *tfy_BannerControlColor;
- (TFY_BannerParam * (^) (UIColor *tfy_BannerControlColor))tfy_BannerControlColorSet;

/**系统的圆点选中颜色  default  orange*/
@property(nonatomic,strong)UIColor  *tfy_BannerControlSelectColor;
- (TFY_BannerParam * (^) (UIColor *tfy_BannerControlSelectColor))tfy_BannerControlSelectColorSet;

/**跑马灯文字颜色  default  red*/
@property(nonatomic,strong)UIColor  *tfy_MarqueeTextColor;
- (TFY_BannerParam * (^) (UIColor *tfy_MarqueeTextColor))tfy_MarqueeTextColorSet;

/**自定义安全的圆点图标 */
@property(nonatomic,copy)NSString  *tfy_BannerControlImage;
- (TFY_BannerParam * (^) (NSString *tfy_BannerControlImage))tfy_BannerControlImageSet;

/**自定义安全的选中圆点图标 */
@property(nonatomic,copy)NSString  *tfy_BannerControlSelectImage;
- (TFY_BannerParam * (^) (NSString *tfy_BannerControlSelectImage))tfy_BannerControlSelectImageSet;

/**自定义安全的圆点图片圆角 default ImageSize/2*/
@property(nonatomic,assign)CGFloat  tfy_BannerControlImageRadius;
- (TFY_BannerParam * (^) (CGFloat tfy_BannerControlImageRadius))tfy_BannerControlImageRadiusSet;

/**自定义安全的圆点图标的size  default (10,10)*/
@property(nonatomic,assign)CGSize  tfy_BannerControlImageSize;
- (TFY_BannerParam * (^) (CGSize tfy_BannerControlImageSize))tfy_BannerControlImageSizeSet;

/**自定义安全的选中圆点图标的size (10,10)*/
@property(nonatomic,assign)CGSize  tfy_BannerControlSelectImageSize;
- (TFY_BannerParam * (^) (CGSize tfy_BannerControlSelectImageSize))tfy_BannerControlSelectImageSizeSet;

/**自定义圆点的间距 default 3*/
@property(nonatomic,assign)CGFloat  tfy_BannerControlSelectMargin;
- (TFY_BannerParam * (^) (CGFloat tfy_BannerControlSelectMargin))tfy_BannerControlSelectMarginSet;

/**自定义pageControl*/
@property(nonatomic,copy)BannerPageControl  tfy_CustomControl;
- (TFY_BannerParam * (^) (BannerPageControl tfy_CustomControl))tfy_CustomControlSet;

/**pageControl的位置 default BannerControlCenter*/
@property(nonatomic,assign)BannerControlPosition  tfy_BannerControlPosition;
- (TFY_BannerParam * (^) (BannerControlPosition tfy_BannerControlPosition))tfy_BannerControlPositionSet;

/**跑马灯速度  default  5*/
@property(nonatomic,assign)CGFloat  tfy_MarqueeRate;
- (TFY_BannerParam * (^) (CGFloat tfy_MarqueeRate))tfy_MarqueeRateSet;

/**点击方法*/
@property(nonatomic,copy)BannerClickBlock  tfy_EventClick;
- (TFY_BannerParam * (^) (BannerClickBlock tfy_EventClick))tfy_EventClickSet;

/**点击方法 可获取居中cell*/
@property(nonatomic,copy)BannerCenterClickBlock  tfy_EventCenterClick;
- (TFY_BannerParam * (^) (BannerCenterClickBlock tfy_EventCenterClick))tfy_EventCenterClickSet;

/**每次滚动结束都会调用 最好是关闭自动滚动的场景使用*/
@property(nonatomic,copy)BannerScrollEndBlock  tfy_EventScrollEnd;
- (TFY_BannerParam * (^) (BannerScrollEndBlock tfy_EventScrollEnd))tfy_EventScrollEndSet;

/**行数*/
@property(nonatomic,assign)NSInteger myCurrentPath;

/***/

/***/

/***/

/***/
@end

NS_ASSUME_NONNULL_END
