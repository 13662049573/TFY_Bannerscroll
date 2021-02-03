//
//  TFY_BannerLoadManager.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerLoadManager.h"

@interface TFY_BannerLoadManager ()
@property(nonatomic,strong,class)NSMutableDictionary *dict;
@end

@implementation TFY_BannerLoadManager
static TFY_BannerLoadManager *manager = nil;
/// 带缓存机制的下载图片
+ (void)loadImageWithURL:(NSString*)url complete:(void(^)(UIImage *image))complete{
    [self loadImageWithURL:url complete:complete progress:nil];
}
+ (void)loadImageWithURL:(NSString*)url complete:(void(^)(UIImage *image))complete progress:(LoadProgressBlock)progress{
    void (^kGetNetworkingImage)(void) = ^{
        if ([self failureNumsForKey:url] >= self.kMaxLoadNum) {
            if (complete) complete(nil);
            return;
        }
        void (^kAnalysis)(NSData *data, NSError *error) = ^(NSData *data, NSError *error){
            UIImage *image = nil;
            if (error) {
                [self cacheFailureForKey:url];
                [self loadImageWithURL:url complete:complete progress:progress];
                return;
            }else{
                image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) complete(image);
                    });
                    [TFY_CacheManager storeImage:image Key:url];
                    [self resetFailureDictForKey:url];
                    return;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) complete(image);
            });
        };
        TFY_BannerDownloader *downloader = [[TFY_BannerDownloader alloc] init];
        if (progress) {
            [downloader startDownloadImageWithURL:[NSURL URLWithString:url] Progress:^(TFY_BannerDownloadProgress * downloadProgress) {
                progress(downloadProgress);
            } Complete:^(NSData * _Nullable data, NSError * _Nullable error) {
                kAnalysis(data, error);
            }];
        }else{
            [downloader startDownloadImageWithURL:[NSURL URLWithString:url] Progress:nil Complete:^(NSData *data, NSError *error) {
                kAnalysis(data, error);
            }];
        }
    };
    if (self.useAsync) {
        [TFY_CacheManager getImageWithKey:url completion:^(UIImage * _Nonnull image) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) complete(image);
                });
            }else{
                kGetNetworkingImage();
            }
        }];
    }else{
        UIImage *image = [TFY_CacheManager getImageWithKey:url];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) complete(image);
            });
        }else{
            kGetNetworkingImage();
        }
    }
}
/// 下载数据，未使用缓存机制
+ (NSData*)downloadDataWithURL:(NSString*)url progress:(LoadProgressBlock)progress{
    @synchronized (self) {
        if (manager == nil) manager = [self new];
    }
    return [manager recursionDataWithURL:[NSURL URLWithString:url] progress:progress];
}
/// 递归拿到DATA
- (NSData*)recursionDataWithURL:(NSURL*)URL progress:(LoadProgressBlock)progress{
    NSInteger count = [TFY_BannerLoadManager failureNumsForKey:URL.absoluteString];
    if (count >= TFY_BannerLoadManager.kMaxLoadNum) {
        return nil;
    }
    NSData *resultData = ({
        if (URL == nil) return nil;
        __block NSData *__data = nil;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_group_async(dispatch_group_create(), queue, ^{
            [[TFY_BannerDownloader new] startDownloadImageWithURL:URL Progress:^(TFY_BannerDownloadProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress);
                }
            } Complete:^(NSData *data, NSError *error) {
                if (error) {
                    [TFY_BannerLoadManager cacheFailureForKey:URL.absoluteString];
                }
                __data = data;
                dispatch_semaphore_signal(semaphore);
            }];
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        __data;
    });
    if (resultData) {
        [TFY_BannerLoadManager resetFailureDictForKey:URL.absoluteString];
        return resultData;
    }else{
        return [self recursionDataWithURL:URL progress:progress];
    }
}
#pragma mark - private
/// 重置失败次数
+ (void)resetFailureDictForKey:(NSString*)key{
    key = [TFY_CacheManager bannerMD5WithString:key];
    [self.dict setObject:@(0) forKey:key];
}
/// 失败次数
+ (NSUInteger)failureNumsForKey:(NSString*)key{
    key = [TFY_CacheManager bannerMD5WithString:key];
    NSNumber *number = [self.dict objectForKey:key];
    return (number && [number respondsToSelector:@selector(integerValue)]) ? number.integerValue : 0;
}
/// 缓存失败
+ (void)cacheFailureForKey:(NSString*)key{
    key = [TFY_CacheManager bannerMD5WithString:key];
    NSNumber *number = [self.dict objectForKey:key];
    NSUInteger index = 0;
    if (number && [number respondsToSelector:@selector(integerValue)]) {
        index = [number integerValue];
    }
    index++;
    [self.dict setObject:@(index) forKey:key];
}

#pragma mark - lazy
static NSMutableDictionary *_dict = nil;
+ (NSMutableDictionary*)dict{
    if (_dict == nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
+ (void)setDict:(NSMutableDictionary*)dict{
    _dict = dict;
}
static NSInteger _kMaxLoadNum = 2;
+ (NSInteger)kMaxLoadNum{
    return _kMaxLoadNum;
}
+ (void)setKMaxLoadNum:(NSInteger)kMaxLoadNum{
    _kMaxLoadNum = kMaxLoadNum;
}
static BOOL _useAsync = NO;
+ (BOOL)useAsync{
    return _useAsync;
}
+ (void)setUseAsync:(BOOL)useAsync{
    _useAsync = useAsync;
}
@end
