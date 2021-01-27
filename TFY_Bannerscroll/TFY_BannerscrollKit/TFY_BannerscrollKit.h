//
//  TFY_BannerscrollKit.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2020/9/10.
//  Copyright © 2020 田风有. All rights reserved.
//  最新版本号：2.1.8

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double TFY_BannerscrollKitVersionNumber;

FOUNDATION_EXPORT const unsigned char TFY_BannerscrollKitVersionString[];

#define TFY_BannerscrollKitRelease 0

#if TFY_BannerscrollKitRelease

#import <TFY_BannerscrollKit/TFY_BannerParam.h>
#import <TFY_BannerscrollKit/TFY_BannerView.h>

#else

/**数据参数模型*/
#import "TFY_BannerParam.h"
/**视图容器*/
#import "TFY_BannerView.h"

#endif
