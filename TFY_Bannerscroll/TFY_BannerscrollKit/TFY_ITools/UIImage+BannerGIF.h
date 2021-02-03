//
//  UIImage+BannerGIF.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BannerGIF)
/// 本地动图
+ (UIImage*)tfy_bannerGIFImageWithData:(NSData*)data;
/// 网络动图
+ (UIImage*)tfy_bannerGIFImageWithURL:(NSURL*)URL;

@end

NS_ASSUME_NONNULL_END
