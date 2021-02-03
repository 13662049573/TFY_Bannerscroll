//
//  TFY_BannerDownloader.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerDownloader.h"

@interface TFY_BannerDownloader ()<NSURLSessionDownloadDelegate>
@property(nonatomic,strong)NSURLSessionTask *task;
@property(nonatomic,strong)NSOperationQueue *queue;
@property(nonatomic,strong)NSURLSessionConfiguration *configuration;
@property(nonatomic,strong)TFY_BannerDownloadProgress *downloadProgress;
@property(nonatomic,copy,readwrite)LoadProgressBlock progressBlock;
@property(nonatomic,copy,readwrite)LoadDataBlock dataBlock;

@end

@implementation TFY_BannerDownloader

- (void)cancelRequest{
    [self.task cancel];
}
- (void)startDownloadImageWithURL:(NSURL*)URL Progress:(LoadProgressBlock)progress Complete:(LoadDataBlock)complete{
    if (URL == nil) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:@"Domain" code:400 userInfo:@{@"message":@"URL不正确"}];
            complete(nil, error);
        }
        return;
    }
    self.maxConcurrentOperationCount = 1;
    if (progress) {
        self.dataBlock = complete;
        self.progressBlock = progress;
        [self downloadImageWithURL:URL];
    }else{
        [self dataImageWithURL:URL Complete:complete];
    }
}
/// 不需要下载进度的网络请求
- (void)dataImageWithURL:(NSURL*)URL Complete:(LoadDataBlock)complete{
    NSMutableURLRequest *request = kGetRequest(URL, self.timeoutInterval?:10.0);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:self.queue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (complete) {
            complete(data,error);
        }
    }];
    [dataTask resume];
    self.task = dataTask;
}
/// 下载进度的请求方式
- (void)downloadImageWithURL:(NSURL*)URL{
    NSMutableURLRequest *request = kGetRequest(URL, self.timeoutInterval?:10.0);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:self.queue];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
    self.task = downloadTask;
}
/// 创建请求对象
NS_INLINE NSMutableURLRequest * kGetRequest(NSURL * URL, NSTimeInterval timeoutInterval){
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = timeoutInterval;
    request.HTTPShouldUsePipelining = YES;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.allHTTPHeaderFields = @{@"Accept":@"image/webp,image/*;q=0.8"};
    return request;
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveResponse:(NSURLResponse*)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}
/// 下载中
- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    @synchronized (self.downloadProgress) {
        self.downloadProgress.bytesWritten = bytesWritten;
        self.downloadProgress.downloadBytes = totalBytesWritten;
        self.downloadProgress.totalBytes = totalBytesExpectedToWrite;
        self.downloadProgress.speed = bytesWritten / 1024.;
        self.downloadProgress.progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
        
        self.progressBlock(self.downloadProgress);
    }
}
/// 下载完成调用
- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didFinishDownloadingToURL:(NSURL*)location{
    if (self.dataBlock) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        self.dataBlock(data, nil);
        _dataBlock = nil;
    }
}
/// 下载失败
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error{
    if ([error code] != NSURLErrorCancelled) {
        if (self.dataBlock) {
            self.dataBlock(nil, error);
            _dataBlock = nil;
        }
    }
}
/// 后台下载
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession*)session{
    
}
#pragma mark - getter/setter
- (void)setMaxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount{
    _maxConcurrentOperationCount = maxConcurrentOperationCount;
    self.queue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}
#pragma mark - lazy
- (TFY_BannerDownloadProgress*)downloadProgress{
    if (!_downloadProgress) {
        _downloadProgress = [[TFY_BannerDownloadProgress alloc]init];
    }
    return _downloadProgress;
}
- (NSOperationQueue*)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}
- (NSURLSessionConfiguration*)configuration{
    if (!_configuration) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
    }
    return _configuration;
}

@end


@implementation TFY_BannerDownloadProgress
@end
