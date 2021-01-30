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
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGRect,tfy_Frame)
/**数据源 必传*/
TFY_BannerSetFuncStatement(TFY_BannerParam,strong,NSArray*,tfy_Data)
/**开启缩放 default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_Scale)
/**开启卡片重叠模式 default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_CardOverLap)
/**背景毛玻璃效果 default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_Effect)
/**隐藏pageControl default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_HideBannerControl)
/**是否允许手势滑动 default YES*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_CanFingerSliding)
/**图片不变形铺满 默认 YES*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_ImageFill)
/**开启无线滚动 default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_Repeat)
/**开启自动滚动 default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_AutoScroll)
/**纵向(cell全屏的时候有效) default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_Vertical)
/**跑马灯(文字效果) default NO*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BOOL,tfy_Marquee)
/**整体间距 默认UIEdgeInsetsMake(0,0, 0, 0)*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,UIEdgeInsets,tfy_SectionInset)
/**整体视图缩放系数 default 1*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_ScreenScale)
/**毛玻璃背景的高度 (视图的高度*倍数) default 1 范围0~1*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_EffectHeight)
/**缩放系数 数值越大缩放越大 default 0.5 卡片叠加效果时默认为0.8*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_ScaleFactor)
/**左右的透明度 default 1*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_Alpha)
/**垂直缩放 数值越大缩放越小 default 400*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_ActiveDistance)
/**item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGSize,tfy_ItemSize)
/**item的之间的间距 default 0*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_LineSpacing)
/**滑动的时候偏移的距离 以倍数计算 default 0.5 正中间*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_ContentOffsetX)
/**左右相邻item的中心点 default BannerCellPositionCenter*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,BannerCellPosition,tfy_Position)
/**占位图片*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,NSString*,tfy_PlaceholderImage)
/**数据源的图片字段 默认 icon*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,NSString*,tfy_DataParamIconName)
/**滚动减速时间 default UIScrollViewDecelerationRateFast*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,UIScrollViewDecelerationRate,tfy_DecelerationRate)
/**自动滚动间隔时间 default 3.0f*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_AutoScrollSecond)
/**默认移动到第几个 default 0*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,NSInteger,tfy_SelectIndex)
/**自定义cell内容 默认是Collectioncell类*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,BannerCellCallBlock,tfy_MyCell)
/**自定义cell的类名 自定义视图必传 不然会crash*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,NSString*,tfy_MyCellClassName)
/**跑马灯文字颜色  default  red*/
TFY_BannerSetFuncStatement(TFY_BannerParam,strong,UIColor*,tfy_MarqueeTextColor)
/**自定义pageControl设置*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,BannerPageControl,tfy_CustomControl)
/**跑马灯速度  default  5*/
TFY_BannerSetFuncStatement(TFY_BannerParam,assign,CGFloat,tfy_MarqueeRate)
/**点击方法*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,BannerClickBlock,tfy_EventClick)
/**点击方法 可获取居中cell*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,BannerCenterClickBlock,tfy_EventCenterClick)
/**每次滚动结束都会调用 最好是关闭自动滚动的场景使用*/
TFY_BannerSetFuncStatement(TFY_BannerParam,copy,BannerScrollEndBlock,tfy_EventScrollEnd)
/**行数*/
@property(nonatomic,assign)NSInteger myCurrentPath;

@end

NS_ASSUME_NONNULL_END
