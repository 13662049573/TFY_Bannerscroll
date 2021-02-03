//
//  TFY_BannerLoadManager.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_BannerDownloader.h" //下载器
#import "TFY_CacheManager.h" //缓存器

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerLoadManager : NSObject

/// 失败次数，默认2次
@property(nonatomic,assign,class)NSInteger kMaxLoadNum;
/// 是否使用异步，默认NO
@property(nonatomic,assign,class)BOOL useAsync;

/// 带缓存机制的下载图片
+ (void)loadImageWithURL:(NSString*)url complete:(void(^)(UIImage *_Nullable image))complete;
+ (void)loadImageWithURL:(NSString*)url complete:(void(^)(UIImage *_Nullable image))complete progress:(LoadProgressBlock)progress;

/// 下载数据，未使用缓存机制
+ (NSData*)downloadDataWithURL:(NSString*)url progress:(LoadProgressBlock)progress;

@end

NS_ASSUME_NONNULL_END
