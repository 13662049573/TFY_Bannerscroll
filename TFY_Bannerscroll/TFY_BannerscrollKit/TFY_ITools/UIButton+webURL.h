//
//  UIButton+webURL.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerWebImageHandle.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (webURL)<TFY_BannerWebImageHandle>
/// 显示网络图片
- (void)tfy_setImageWithURL:(NSURL*)url handle:(void(^__nullable)(id<TFY_BannerWebImageHandle>handle))handle;

@end

NS_ASSUME_NONNULL_END
