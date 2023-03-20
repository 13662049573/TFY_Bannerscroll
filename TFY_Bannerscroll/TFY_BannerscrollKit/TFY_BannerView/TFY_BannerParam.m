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
        self.tfy_Scale = NO;
        self.tfy_CardOverLap = CardtypeCommon;
        self.tfy_CardOverLapCount = 4;
        self.tfy_CardOverMinAlpha = 0.1;
        self.tfy_CardOverAlphaOpen = NO;
        
        self.tfy_Effect = NO;
        self.tfy_HideBannerControl = NO;
        self.tfy_CanFingerSliding = YES;
        self.tfy_ImageFill = NO;
        self.tfy_Repeat = NO;
        self.tfy_AutoScroll = NO;
        self.tfy_Vertical = NO;
        self.tfy_Marquee = NO;
        self.tfy_ClickCenter = NO;
        self.tfy_Zindex = NO;
        self.tfy_SectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tfy_ScreenScale = 1;
        self.tfy_EffectHeight = 1;
        self.tfy_ScaleFactor = 0.5;
        self.tfy_Alpha = 1;
        self.tfy_ActiveDistance = 400;
        self.tfy_LineSpacing = 0;
        self.tfy_ContentOffsetX = 0.5;
        self.tfy_Position = BannerCellPositionCenter;
        self.tfy_AutoScrollSecond = 3;
        self.tfy_SelectIndex = 0;
        self.tfy_MarqueeTextColor = [UIColor redColor];
        self.tfy_MarqueeRate = 0.5;
        self.tfy_DecelerationRate = 0.1;
        self.tfy_DataParamIconName = @"icon";
        self.tfy_EffectStyle = UIBlurEffectStyleLight;
        self.tfy_EffectAlpha = 1;
        self.tfy_DecelerationRate = UIScrollViewDecelerationRateFast;
        self.tfy_BannerScale = NO;
        self.tfy_Separate = YES;
        self.tfy_ControlH = 30;
    }
    return self;
}

TFY_BannerSetFuncImplementation(TFY_BannerParam,CGRect,tfy_Frame)
/**图片添加圆角*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_bannerRadius)
/**数据源 必传*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,NSArray<id>*,tfy_Data)
/**开启缩放 default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Scale)
/**开启卡片重叠模式 default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,Cardtype,tfy_CardOverLap)
//卡片重叠模式开启偏移透明度变化 default NO
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_CardOverAlphaOpen)
//叠加模式透明度最小值 defalt 0.1
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_CardOverMinAlpha)
//卡片重叠显示个数 default 4
TFY_BannerSetFuncImplementation(TFY_BannerParam,NSInteger,tfy_CardOverLapCount)
/**背景毛玻璃效果 default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Effect)
/**隐藏pageControl default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_HideBannerControl)
/**是否允许手势滑动 default YES*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_CanFingerSliding)
/**图片不变形铺满 默认 YES*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_ImageFill)
/**开启无线滚动 default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Repeat)
/**开启自动滚动 default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_AutoScroll)
/**纵向(cell全屏的时候有效) default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Vertical)
/**点击视图居中*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_ClickCenter)
/**跑马灯(文字效果) default NO*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Marquee)
//中间视图放最上面 default NO
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Zindex)
/**是否裁剪*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_BannerScale)
/**是否开启剩一张图片 停止滑动，圆点隐藏 默认 YES*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BOOL,tfy_Separate)
/**整体间距 默认UIEdgeInsetsMake(0,0, 0, 0)*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,UIEdgeInsets,tfy_SectionInset)
/**整体视图缩放系数 default 1*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_ScreenScale)
/**毛玻璃背景的高度 (视图的高度*倍数) default 1 范围0~1*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_EffectHeight)
/**缩放系数 数值越大缩放越大 default 0.5 卡片叠加效果时默认为0.8*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_ScaleFactor)
/**左右的透明度 default 1*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_Alpha)
/**垂直缩放 数值越大缩放越小 default 400*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_ActiveDistance)
/**item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGSize,tfy_ItemSize)
/**item的之间的间距 default 0*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_LineSpacing)
/**滑动的时候偏移的距离 以倍数计算 default 0.5 正中间*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_ContentOffsetX)
/**左右相邻item的中心点 default BannerCellPositionCenter*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerCellPosition,tfy_Position)
/**占位图片*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,NSString*,tfy_PlaceholderImage)
/**数据源的图片字段 默认 icon*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,NSString*,tfy_DataParamIconName)
/**滚动减速时间 default UIScrollViewDecelerationRateFast*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,UIScrollViewDecelerationRate,tfy_DecelerationRate)
/**自动滚动间隔时间 default 3.0f*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_AutoScrollSecond)
/**默认移动到第几个 default 0*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,NSInteger,tfy_SelectIndex)
/**自定义cell内容 默认是Collectioncell类*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerCellCallBlock,tfy_MyCell)
/**自定义cell的类名 自定义视图必传 不然会crash*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,id,tfy_MyCellClassNames)
/**跑马灯文字颜色  default  red*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,UIColor*,tfy_MarqueeTextColor)
/**自定义pageControl*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerPageControl,tfy_CustomControl)
/**自定义pageControl 的高度，默认里 底部的距离 self.frame.size.hieght -tfy_ControlH 默认 30 */
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_ControlH)
/**跑马灯速度  default  5*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_MarqueeRate)
/**点击方法*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerClickBlock,tfy_EventClick)
/**点击方法 可获取居中cell*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerCenterClickBlock,tfy_EventCenterClick)
/**每次滚动结束都会调用 最好是关闭自动滚动的场景使用*/
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerScrollEndBlock,tfy_EventScrollEnd)
//正在滚动
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerScrollBlock,tfy_EventDidScroll)
// 开始滚动
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerscrollViewWillBeginDraggingBlock,tfy_WillBeginDraggingScroll)
//特殊样式 default 无
TFY_BannerSetFuncImplementation(TFY_BannerParam,SpecialStyle,tfy_SpecialStyle)

//特殊样式SpecialLine 自定义下划线
TFY_BannerSetFuncImplementation(TFY_BannerParam,BannerSpecialLine,tfy_SpecialCustumLine)

/**毛玻璃类型  默认 UIBlurEffectStyleLight */
TFY_BannerSetFuncImplementation(TFY_BannerParam,UIBlurEffectStyle,tfy_EffectStyle)
/**毛玻璃透明度 默认 apal */
TFY_BannerSetFuncImplementation(TFY_BannerParam,CGFloat,tfy_EffectAlpha)

@end

