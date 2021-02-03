//
//  TFY_BannerDownloader.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TFY_BannerDownloadProgress;

/// 网络请求回调
typedef void (^LoadDataBlock)(NSData *_Nullable data, NSError *_Nullable error);
/// 下载进度回调
typedef void (^_Nullable LoadProgressBlock)(TFY_BannerDownloadProgress * _Nonnull downloadProgress);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerDownloader : NSObject

/// 超时时长，默认10秒
@property(nonatomic,assign)NSTimeInterval timeoutInterval;
/// 设置最大并发队列数，默认为一条
@property(nonatomic,assign)NSUInteger maxConcurrentOperationCount;
/// 下载数据
- (void)startDownloadImageWithURL:(NSURL*_Nullable)URL Progress:(LoadProgressBlock)progress Complete:(LoadDataBlock)complete;
/// 取消下载
- (void)cancelRequest;

@end

@interface TFY_BannerDownloadProgress : NSObject

@property(nonatomic,assign)int64_t bytesWritten;// 当前下载包大小
@property(nonatomic,assign)int64_t downloadBytes;// 已下载大小
@property(nonatomic,assign)int64_t totalBytes;// 总大小
@property(nonatomic,assign)float progress;// 下载进度
@property(nonatomic,assign)float speed;// 当前下载速度 kb/s

@end

NS_ASSUME_NONNULL_END
