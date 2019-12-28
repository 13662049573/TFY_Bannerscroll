//
//  UIImageView+Bannerscroll.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^DownLoadDataCallBack)(NSData * _Nonnull  data, NSError * _Nonnull error);
typedef void (^DownloadProgressBlock)(unsigned long long total, unsigned long long current);

@interface ImageDownloader : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic, strong) NSURLSessionDownloadTask * _Nonnull task;

@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;

@property (nonatomic, copy) DownloadProgressBlock _Nonnull progressBlock;
@property (nonatomic, copy) DownLoadDataCallBack _Nonnull callbackOnFinished;

- (void)tfy_startDownloadImageWithUrl:(NSString *_Nonnull)url progress:(DownloadProgressBlock _Nonnull )progress finished:(DownLoadDataCallBack _Nonnull )finished;

@end

typedef void (^ImageBlock)(UIImage * _Nonnull image);

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Bannerscroll)
/**
 *  下载完图像后获取/设置回调块。来自网络或磁盘的图像对象。
 */
@property(nonatomic,copy)ImageBlock tfy_completion;
/**
 *  图片下载器
 */
@property(nonatomic,strong)ImageDownloader *tfy_imageDownloader;
/**
 *  指定下载图像的URL失败，重试次数，默认为2
 */
@property(nonatomic,assign)NSUInteger tfy_attemptToReloadTimesForFailedURL;
/**
 * 将自动下载到UIImageView图像大小的剪切。默认值为NO。如果设置为YES，则仅在切割图像后成功存储后才下载
 */
@property(nonatomic,assign)BOOL tfy_shouldAutoClipImageToViewSize;
/**
 *  使用`url`和占位符设置imageView`image`。下载是异步和缓存的。
 */
- (void)tfy_setImageWithURLString:(NSString *)url placeholderImageName:(NSString *)placeholderImageName;
/**
 *  使用`url`和占位符设置imageView`image`。下载是异步和缓存的。
 */
- (void)tfy_setImageWithURLString:(NSString *)url placeholder:(UIImage *)placeholderImage;
/**
 * placeholderImage最初要设置的图像，直到图像请求完成。
 * completion操作完成时调用的块。该块没有返回值
 * UIImage作为第一个参数。如果出现错误，图像参数
 * 为nil，第二个参数可能包含NSError。第三个参数是布尔值
 * 指示图像是从本地缓存还是从网络检索的。
 * 第四个参数是原始图像网址。
 */
- (void)tfy_setImageWithURLString:(NSString *)url placeholder:(UIImage *)placeholderImage completion:(void (^)(UIImage *image))completion;
/**
 * placeholderImageName最初要设置的图像名称，直到图像请求完成。
 * completion操作完成时调用的块。该块没有返回值
 * 并将请求的UIImage作为第一个参数。如果出现错误，图像参数
 * 为nil，第二个参数可能包含NSError。第三个参数是布尔值
 * 指示图像是从本地缓存还是从网络检索的。
 * 第四个参数是原始图像网址。
 */
- (void)tfy_setImageWithURLString:(NSString *)url placeholderImageName:(NSString *)placeholderImageName completion:(void (^)(UIImage *image))completion;
/**
 *  为UIImageView加入一个设置gif图内容的方法：
 */
-(void)tfy_setImage:(NSURL *)imageUrl;
@end

NS_ASSUME_NONNULL_END
