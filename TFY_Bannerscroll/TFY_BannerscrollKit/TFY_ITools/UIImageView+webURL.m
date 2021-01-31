//
//  UIImageView+webURL.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "UIImageView+webURL.h"
#import "TFY_FImageCache.h"

@implementation UIImageView (webURL)

- (void)tfy_setImageWithURL:(nullable NSString *)url NS_REFINED_FOR_SWIFT {
    [self tfy_setImageWithURL:url placeholderImage:nil];
}

- (void)tfy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT {
    __weak typeof(self)weakSelf = self;
    if (url==nil || [url isEqualToString:@""]) {
        self.image = placeholder;
    } else {
        [[TFY_FImageCache sharedInstance] imageForURL:url completion:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            } else {
                strongSelf.image = image;
            }
        }];
    }
}

@end
