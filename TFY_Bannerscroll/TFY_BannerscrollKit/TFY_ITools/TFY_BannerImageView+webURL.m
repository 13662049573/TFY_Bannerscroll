//
//  TFY_BannerImageView+webURL.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerImageView+webURL.h"
#import "TFY_FImageCache.h"
#import "NSData+ImageType.h"

static inline TFY_BannerAnimatedImage * WebImageCreateAnimatedImage(TFY_BannerImageView *imageView, NSData *imageData) {
    if ([NSData tfy_imageFormatForImageData:imageData] != ImageFormatGIF) {
        return nil;
    }
    TFY_BannerAnimatedImage *animatedImage;
    if ([TFY_BannerAnimatedImage instancesRespondToSelector:@selector(initWithAnimatedGIFData:optimalFrameCacheSize:predrawingEnabled:)]) {
        animatedImage = [[TFY_BannerAnimatedImage alloc] initWithAnimatedGIFData:imageData optimalFrameCacheSize:imageView.tfy_optimalFrameCacheSize predrawingEnabled:imageView.tfy_predrawingEnabled];
    } else {
        animatedImage = [[TFY_BannerAnimatedImage alloc] initWithAnimatedGIFData:imageData];
    }
    return animatedImage;
}

@implementation UIImage (TFY_BannerAnimatedImage)

- (TFY_BannerAnimatedImage *)tfy_AnimatedImage {
    return objc_getAssociatedObject(self, @selector(tfy_AnimatedImage));
}

- (void)setTfy_AnimatedImage:(TFY_BannerAnimatedImage *)tfy_AnimatedImage {
    objc_setAssociatedObject(self, @selector(tfy_AnimatedImage), tfy_AnimatedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation TFY_BannerImageView (webURL)

- (NSUInteger)tfy_optimalFrameCacheSize {
    NSUInteger optimalFrameCacheSize = 0;
    NSNumber *value = objc_getAssociatedObject(self, @selector(tfy_optimalFrameCacheSize));
    if ([value isKindOfClass:[NSNumber class]]) {
        optimalFrameCacheSize = value.unsignedShortValue;
    }
    return optimalFrameCacheSize;
}

- (void)setTfy_optimalFrameCacheSize:(NSUInteger)tfy_optimalFrameCacheSize {
    objc_setAssociatedObject(self, @selector(tfy_optimalFrameCacheSize), @(tfy_optimalFrameCacheSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tfy_predrawingEnabled {
    BOOL predrawingEnabled = YES;
    NSNumber *value = objc_getAssociatedObject(self, @selector(tfy_predrawingEnabled));
    if ([value isKindOfClass:[NSNumber class]]) {
        predrawingEnabled = value.boolValue;
    }
    return predrawingEnabled;
}

- (void)setTfy_predrawingEnabled:(BOOL)tfy_predrawingEnabled {
    objc_setAssociatedObject(self, @selector(tfy_predrawingEnabled), @(tfy_predrawingEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tfy_cacheAnimatedImage {
    BOOL cacheAnimatedImage = YES;
    NSNumber *value = objc_getAssociatedObject(self, @selector(tfy_cacheAnimatedImage));
    if ([value isKindOfClass:[NSNumber class]]) {
        cacheAnimatedImage = value.boolValue;
    }
    return cacheAnimatedImage;
}

- (void)setTfy_cacheAnimatedImage:(BOOL)tfy_cacheAnimatedImage {
    objc_setAssociatedObject(self, @selector(tfy_cacheAnimatedImage), @(tfy_cacheAnimatedImage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)tfy_setImageWithURL:(nullable NSString *)url NS_REFINED_FOR_SWIFT {
    [self tfy_setImageWithURL:url placeholderImage:nil completed:nil];
}

- (void)tfy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT {
    [self tfy_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)tfy_setImageWithURL:(nullable NSString *)url
                  completed:(nullable ExternalCompletionBlock)completedBlock {
    [self tfy_setImageWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)tfy_setImageWithURL:(nullable NSString *)url
          placeholderImage:(nullable UIImage *)placeholder
                  completed:(nullable ExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT {
    __weak typeof(self)weakSelf = self;
    if (url==nil || [url isEqualToString:@""]) {
        self.image = placeholder;
    } else {
        [[TFY_FImageCache sharedInstance] imageForURL:url completion:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) {return;}
            TFY_BannerAnimatedImage *associatedAnimatedImage = image.tfy_AnimatedImage;
            if (associatedAnimatedImage) {
                strongSelf.image = associatedAnimatedImage.posterImage;
                strongSelf.animatedImage = associatedAnimatedImage;
                return;
            }
            BOOL isGIF = ([NSData tfy_imageFormatForImageData:imageData] == ImageFormatGIF);
            if (!isGIF) {
                strongSelf.image = image;
                strongSelf.animatedImage = nil;
                return;
            }
            __weak typeof(strongSelf) wweakSelf = strongSelf;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                __strong typeof(wweakSelf) sstrongSelf = wweakSelf;
                TFY_BannerAnimatedImage *animatedImage = WebImageCreateAnimatedImage(sstrongSelf, imageData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (animatedImage) {
                        if (sstrongSelf.tfy_cacheAnimatedImage) {
                            image.tfy_AnimatedImage = animatedImage;
                        }
                        sstrongSelf.image = animatedImage.posterImage;
                        sstrongSelf.animatedImage = animatedImage;
                    } else {
                        sstrongSelf.image = image;
                        sstrongSelf.animatedImage = nil;
                    }
                });
            });
            completedBlock(image,imageData,[NSURL URLWithString:url]);
        }];
    }
}


@end
