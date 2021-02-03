//
//  UIView+webURL.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/2/3.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "UIView+webURL.h"

@implementation UIView (webURL)

- (void)tfy_config{
    self.URLType = BannerImageURLTypeCommon;
    self.cacheDatas = true;
    self.viewContentsGravity = kCAGravityResize;
}
- (void)tfy_setViewImageContentsWithURL:(NSURL*)url handle:(void(^__nullable)(id<TFY_BannerWebImageHandle>handle))handle{
    if (url == nil) return;
    [self tfy_config];
    if (handle) handle(self);
    __block id<TFY_BannerWebImageHandle> han = (id<TFY_BannerWebImageHandle>)self;
    __block CGSize size = self.frame.size;
    BannerWSelf(myself);
    kGCD_banner_async(^{
        NSData *data = [TFY_CacheManager tfy_getGIFImageWithKey:url.absoluteString];
        if (data) {
            kGCD_banner_main(^{
                UIImage *image = kBannerWebImageSetImage(data, size, han);
                CALayer *layer = [myself tfy_setLayerImageContents:image?:han.placeholder];
                layer.contentsGravity = han.viewContentsGravity;
            });
        }else{
            kBannerWebImageDownloader(url, size, han, ^(UIImage * _Nonnull image) {
                kGCD_banner_main(^{
                    CALayer *layer = [myself tfy_setLayerImageContents:image?:han.placeholder];
                    layer.contentsGravity = han.viewContentsGravity;
                });
            });
        }
    });
}
/// 设置Layer上面的内容，默认充满的填充方式
- (CALayer*)tfy_setLayerImageContents:(UIImage*)image{
    CALayer * imageLayer = [CALayer layer];
    imageLayer.bounds = self.bounds;
    imageLayer.position = CGPointMake(self.bounds.size.width*.5, self.bounds.size.height*.5);
    imageLayer.contents = (id)image.CGImage;
    [self.layer addSublayer:imageLayer];
    return imageLayer;
}
#pragma maek - KJBannerWebImageHandle
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
- (CALayerContentsGravity)viewContentsGravity{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewContentsGravity:(CALayerContentsGravity)viewContentsGravity{
    objc_setAssociatedObject(self, @selector(viewContentsGravity), viewContentsGravity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
