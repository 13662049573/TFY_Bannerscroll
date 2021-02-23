//
//  TFY_BannerImageView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFY_BannerAnimatedImage;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerImageView : UIImageView

@property (nonatomic, strong) TFY_BannerAnimatedImage *__nullable animatedImage;
@property (nonatomic, copy) void(^loopCompletionBlock)(NSUInteger loopCountRemaining);

@property (nonatomic, strong, readonly) UIImage *__nullable currentFrame;
@property (nonatomic, assign, readonly) NSUInteger currentFrameIndex;

@property (nonatomic, copy) NSString *__nullable runLoopMode;

@end

extern const NSTimeInterval kAnimatedImageDelayTimeIntervalMinimum;

@interface TFY_BannerAnimatedImage : NSObject
/**
 保证加载;通常相当于
 */
@property (nonatomic, strong, readonly) UIImage *__nullable posterImage;
/**
 The `.posterImage`'s `.size`
 */
@property (nonatomic, assign, readonly) CGSize size;
/**
 0表示无限期地重复动画
 */
@property (nonatomic, assign) NSUInteger loopCount;
/**
 类型NSTimeInterval框在NSNumber ' s中
 */
@property (nonatomic, strong, readonly) NSDictionary *delayTimesForIndexes;
/**
 有效帧数;等于' [.delayTimes count] '
 */
@property (nonatomic, assign, readonly) NSUInteger frameCount;
/**
 智能选择缓冲窗口的当前大小;可以在interval [1..frameCount]中取值。
 */
@property (nonatomic, assign, readonly) NSUInteger frameCacheSizeCurrent;
/**
 允许设置缓存大小的上限;0表示没有特定的限制(默认值)
 */
@property (nonatomic, assign) NSUInteger frameCacheSizeMax;
/**
 //从主线程同步调用;将立即返回。
 //如果结果没有被缓存，将返回' nil ';然后调用者应该暂停回放，而不是增加帧计数器并保持轮询。
 //在初始加载时间之后，根据`frameCacheSize`，帧应该立即从缓存中可用。
 */
- (UIImage *__nullable )imageLazilyCachedAtIndex:(NSUInteger)index;
/**
 传递一个' UIImage '或' TFY_ImageView '并获取它的大小
 */
+ (CGSize)sizeForImage:(id)image;
/**
 如果成功，初始化器返回一个' FLAnimatedImage '并初始化所有字段，如果失败则返回' nil '并记录一个错误。
 */
- (instancetype)initWithAnimatedGIFData:(NSData *__nullable)data;
/**
 为optimalFrameCacheSize传递0以获得默认值，预绘制是默认启用的。
 */
- (instancetype)initWithAnimatedGIFData:(NSData *__nullable)data optimalFrameCacheSize:(NSUInteger)optimalFrameCacheSize predrawingEnabled:(BOOL)isPredrawingEnabled NS_DESIGNATED_INITIALIZER;
+ (instancetype)animatedImageWithGIFData:(NSData *__nullable)data;
/**
 接收端初始化的数据;只读
 */
@property (nonatomic, strong, readonly) NSData *__nullable data;

@end

@interface TFY_BannerWeakProxy : NSProxy

+ (instancetype)weakProxyForObject:(id)targetObject;

@end

NS_ASSUME_NONNULL_END
