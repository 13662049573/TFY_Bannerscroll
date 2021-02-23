//
//  TFY_FImageCache.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_FImageCache : NSObject

#ifndef ImageCache_LOGGING_ENABLED
#define ImageCache_LOGGING_ENABLED 0
#endif

//当应用程序进入后台时，将请求额外的时间
//删除磁盘上大于这个数的文件，以秒为单位。
//默认为7天:-604800
#define ImageCache_DEFAULT_EXPIRATION_INTERVAL -604800
@property (assign, nonatomic) NSTimeInterval fileExpirationInterval;

//如果http响应状态码不在400-499范围内，可以尝试重试
//默认值:0
@property (assign, nonatomic) NSInteger maxNumberOfRetries;
//重试之间等待的秒数
//默认0.0
@property (assign, nonatomic) NSTimeInterval retryDelay;

+ (nonnull TFY_FImageCache *)sharedInstance;

- (void)imageForURL:(nonnull NSString *)url completion:(void (^ __nullable)(UIImage * __nullable image,NSData * _Nullable imageData))completion;

- (void)clearAllData;

@end

NS_ASSUME_NONNULL_END
