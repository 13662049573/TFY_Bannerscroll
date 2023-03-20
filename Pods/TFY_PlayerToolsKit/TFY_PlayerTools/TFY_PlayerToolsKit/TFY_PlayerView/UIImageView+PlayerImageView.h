//
//  UIImageView+PlayerImageView.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^ _Nullable DownLoadDataCallBack)(NSData *_Nullable data, NSError *_Nullable error);
typedef void (^ _Nullable DownloadProgressBlock)(unsigned long long total, unsigned long long current);

@interface PlayerImageDownloader : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession * _Nullable session;
@property (nonatomic, strong) NSURLSessionDownloadTask *_Nullable task;

@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;

@property (nonatomic, copy) DownloadProgressBlock progressBlock;
@property (nonatomic, copy) DownLoadDataCallBack callbackOnFinished;

- (void)startDownloadImageWithUrl:(NSString *_Nullable)url
                         progress:(DownloadProgressBlock)progress
                         finished:(DownLoadDataCallBack)finished;

@end

typedef void (^ _Nullable PlayerImageBlock)(UIImage *_Nullable image);

@interface UIImageView (PlayerImageView)

@property (nonatomic, copy) PlayerImageBlock completion;

@property (nonatomic, strong) PlayerImageDownloader * _Nullable imageDownloader;

@property (nonatomic, assign) NSUInteger attemptToReloadTimesForFailedURL;

@property (nonatomic, assign) BOOL shouldAutoClipImageToViewSize;

- (void)setImageWithURLString:(NSString *_Nullable)url placeholderImageName:(NSString *_Nullable)placeholderImageName;

- (void)setImageWithURLString:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholderImage;

- (void)setImageWithURLString:(NSString *_Nullable)url
                  placeholder:(UIImage *_Nullable)placeholderImage
                   completion:(void (^ _Nullable)(UIImage *_Nullable image))completion;

- (void)setImageWithURLString:(NSString *_Nullable)url
         placeholderImageName:(NSString *_Nullable)placeholderImageName
                   completion:(void (^ _Nullable)(UIImage *_Nullable image))completion;
@end

NS_ASSUME_NONNULL_END
