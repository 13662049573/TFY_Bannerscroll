//
//  TFY_BannerImageView+webURL.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerImageView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ExternalCompletionBlock)(UIImage * _Nullable image,NSData * _Nullable imageData,NSURL * _Nullable imageURL);

@interface UIImage (TFY_BannerAnimatedImage)

@property (nonatomic, strong, nullable) TFY_BannerAnimatedImage *tfy_AnimatedImage;

@end

@interface TFY_BannerImageView (webURL)

@property (nonatomic, assign) NSUInteger tfy_optimalFrameCacheSize;

@property (nonatomic, assign) BOOL tfy_predrawingEnabled;

@property (nonatomic, assign) BOOL tfy_cacheAnimatedImage;

- (void)tfy_setImageWithURL:(nullable NSString *)url NS_REFINED_FOR_SWIFT;

- (void)tfy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT;

- (void)tfy_setImageWithURL:(nullable NSString *)url
                 completed:(nullable ExternalCompletionBlock)completedBlock;

- (void)tfy_setImageWithURL:(nullable NSString *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable ExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
