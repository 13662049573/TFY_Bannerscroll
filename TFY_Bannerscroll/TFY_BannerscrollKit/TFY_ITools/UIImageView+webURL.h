//
//  UIImageView+webURL.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionBlock)(UIImage * _Nullable image, NSData * _Nullable imageData,NSURL * _Nullable imageURL);

@interface UIImageView (webURL)

- (void)tfy_setImageWithURL:(nullable NSString *)url NS_REFINED_FOR_SWIFT;

- (void)tfy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT;

- (void)tfy_setImageWithURL:(nullable NSString *)url
                 completed:(nullable CompletionBlock)completedBlock;

- (void)tfy_setImageWithURL:(nullable NSString *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable CompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END