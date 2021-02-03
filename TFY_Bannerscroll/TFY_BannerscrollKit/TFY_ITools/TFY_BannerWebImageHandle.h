//
//  TFY_BannerWebImageHandle.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "TFY_BannerConfig.h"
#import "TFY_BannerLoadManager.h"
#import "UIImage+BannerGIF.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TFY_BannerWebImageHandle <NSObject>
@optional;
#pragma mark - common
/// 占位图
@property(nonatomic,strong)UIImage *placeholder;
/// 图片下载完成回调
@property(nonatomic,copy,readwrite)WebImageCompleted completed;
/// 下载进度回调
@property(nonatomic,copy,readwrite)LoadProgressBlock progress;
/// 图片地址链接类型，默认 KJBannerImageURLTypeCommon
@property(nonatomic,assign)BannerImageURLType URLType;
/// 是否缓存数据至本地，默认开启
@property(nonatomic,assign)bool cacheDatas;
/// 是否等比裁剪图片，默认关闭
@property(nonatomic,assign)bool cropScale;
/// 获取原始图回调，裁剪开启才有效果
@property(nonatomic,copy,readwrite)void(^kCropScaleImage)(UIImage * originalImgae, UIImage * scaleImage);

#pragma mark - button
/// 按钮状态
@property(nonatomic,assign)UIControlState buttonState;

#pragma mark - view
/// 图片填充方式
@property(nonatomic,copy)CALayerContentsGravity viewContentsGravity;

@end

//************ 公共方法 *************
/// 裁剪图片操作
NS_INLINE UIImage * kBannerWebImageCropImage(UIImage * image, CGSize size, id<TFY_BannerWebImageHandle> han){
    if (han.cropScale) {
        UIImage * newImage = kCropImage(image, size);
        if (han.kCropScaleImage) {
            han.kCropScaleImage(image, newImage);
        }
        return newImage;
    }
    return image;
}
/// 获取图片
NS_INLINE UIImage * kBannerWebImageSetImage(NSData * data, CGSize size, id<TFY_BannerWebImageHandle> han){
    __block BannerImageType imageType;UIImage *image;
    if (han.URLType == BannerImageURLTypeMixture) {
        imageType = kBannerContentType(data);
        if (imageType == BannerImageTypeGif) {
            image = [UIImage tfy_bannerGIFImageWithData:data];
        }else{
            image = kBannerWebImageCropImage([UIImage imageWithData:data], size, han);
        }
    }else if (han.URLType == BannerImageURLTypeCommon) {
        image = kBannerWebImageCropImage([UIImage imageWithData:data], size, han);
        imageType = kBannerContentType(data);
    }else if (han.URLType == BannerImageURLTypeGif) {
        image = [UIImage tfy_bannerGIFImageWithData:data];
        imageType = BannerImageTypeGif;
    }else{
        imageType = BannerImageTypeUnknown;
    }
    kGCD_banner_main(^{
        if (han.completed) {
            han.completed(imageType, image, data);
        }
    });
    return image;
}
/// 下载图片
NS_INLINE void kBannerWebImageDownloader(NSURL * url, CGSize size, id<TFY_BannerWebImageHandle> han, void(^imageblock)(UIImage *image)){
    void (^kDownloaderAnalysis)(NSData *__data) = ^(NSData *__data){
        if (__data == nil) return;
        if (imageblock) {
            imageblock(kBannerWebImageSetImage(__data, size, han));
        }
        if (han.cacheDatas) {
            [TFY_CacheManager tfy_storeGIFData:__data Key:url.absoluteString];
        }
    };
    TFY_BannerDownloader *downloader = [TFY_BannerDownloader new];
    if (han.progress) {
        [downloader startDownloadImageWithURL:url Progress:^(TFY_BannerDownloadProgress * downloadProgress) {
            han.progress(downloadProgress);
        } Complete:^(NSData * data, NSError * error) {
            if ((error || !data) && han.completed) {
                han.completed(BannerImageTypeUnknown,nil,nil);
            }else{
                kDownloaderAnalysis(data);
            }
        }];
    }else{
        [downloader startDownloadImageWithURL:url Progress:nil Complete:^(NSData * data, NSError * error) {
            if ((error || !data) && han.completed) {
                han.completed(BannerImageTypeUnknown,nil,nil);
            }else{
                kDownloaderAnalysis(data);
            }
        }];
    }
}
NS_ASSUME_NONNULL_END
