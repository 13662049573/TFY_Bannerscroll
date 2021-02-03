//
//  TFY_CacheManager.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BannerLoadImages [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/LoadImages"]

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheManager : NSObject
/// 最大缓存，默认50mb
@property(nonatomic,assign,class)NSUInteger maxCache;
/// 是否允许写入Cache，默认为YES
@property(nonatomic,assign,class)BOOL allowCache;
/// MD5加密
+ (NSString*)bannerMD5WithString:(NSString*)string;
/// 先从缓存读取，若没有则读取本地文件
+ (UIImage*)getImageWithKey:(NSString*)key;
/// 先从缓存读取，若没有则读取本地文件并写入缓存
+ (void)getImageWithKey:(NSString*)key completion:(void(^)(UIImage*image))completion;
/// 将图片写入缓存和存储到本地
+ (void)storeImage:(UIImage*)image Key:(NSString*)key;

@end

@interface TFY_CacheManager (BannerGIF)
/// 动态图本地获取
+ (NSData*)tfy_getGIFImageWithKey:(NSString*)key;
/// 将动态图写入本地
+ (void)tfy_storeGIFData:(NSData*)data Key:(NSString*)key;

@end


@interface TFY_CacheManager (BannerCache)
/// 清理掉缓存和本地文件
+ (BOOL)tfy_clearLocalityImageAndCache;
/// 获取图片本地文件总大小
+ (int64_t)tfy_getLocalityImageCacheSize;

@end

NS_ASSUME_NONNULL_END
