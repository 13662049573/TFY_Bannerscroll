//
//  UIButton+webURL.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "UIButton+webURL.h"

@implementation UIButton (webURL)

- (void)tfy_config{
    self.URLType = BannerImageURLTypeMixture;
    self.cacheDatas = true;
    self.buttonState = UIControlStateNormal;
}

- (void)tfy_setImageWithURL:(NSURL*)url handle:(void(^__nullable)(id<TFY_BannerWebImageHandle>handle))handle{
    if (url == nil) return;
    [self tfy_config];
    if (handle) handle(self);
    __block id<TFY_BannerWebImageHandle> han = (id<TFY_BannerWebImageHandle>)self;
    __block CGSize size = self.imageView.frame.size;
    if (han.placeholder) [self setImage:han.placeholder forState:han.buttonState];
    BannerWSelf(myself);
    kGCD_banner_async(^{
        NSData *data = [TFY_CacheManager tfy_getGIFImageWithKey:url.absoluteString];
        if (data) {
            kGCD_banner_main(^{
                [myself setImage:kBannerWebImageSetImage(data, size, han) forState:han.buttonState];
            });
        }else{
            kBannerWebImageDownloader(url, size, han, ^(UIImage * _Nonnull image) {
                kGCD_banner_main(^{
                    [myself setImage:image forState:han.buttonState];
                });
            });
        }
    });
}

#pragma maek - KJBannerWebImageHandle
- (UIControlState)buttonState{
    return (UIControlState)[objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setButtonState:(UIControlState)buttonState{
    objc_setAssociatedObject(self, @selector(buttonState), @(buttonState), OBJC_ASSOCIATION_ASSIGN);
}

- (UIImage *)placeholder{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceholder:(UIImage *)placeholder{
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (WebImageCompleted)completed{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCompleted:(WebImageCompleted)completed{
    objc_setAssociatedObject(self, @selector(completed), completed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LoadProgressBlock)progress{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setProgress:(LoadProgressBlock)progress{
    objc_setAssociatedObject(self, @selector(progress), progress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BannerImageURLType)URLType{
    return (BannerImageURLType)[objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setURLType:(BannerImageURLType)URLType{
    objc_setAssociatedObject(self, @selector(URLType), @(URLType), OBJC_ASSOCIATION_ASSIGN);
}
- (bool)cacheDatas{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setCacheDatas:(bool)cacheDatas{
    objc_setAssociatedObject(self, @selector(cacheDatas), @(cacheDatas), OBJC_ASSOCIATION_ASSIGN);
}
- (bool)cropScale{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setCropScale:(bool)cropScale{
    objc_setAssociatedObject(self, @selector(cropScale), @(cropScale), OBJC_ASSOCIATION_ASSIGN);
}
- (void (^)(UIImage *, UIImage *))kCropScaleImage{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKCropScaleImage:(void (^)(UIImage *, UIImage *))kCropScaleImage{
    objc_setAssociatedObject(self, @selector(kCropScaleImage), kCropScaleImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
