//
//  TFY_BannerControl.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BannerControl.h"

@implementation TFY_BannerControl

- (instancetype)initWithFrame:(CGRect)frame WithModel:(TFY_BannerParam *)param{
    if (self=[super initWithFrame:frame]) {
        self.param = param;
        self.userInteractionEnabled = NO;
        self.hidesForSinglePage = YES;
        self.currentPageIndicatorTintColor = param.tfy_BannerControlSelectColor;
        self.pageIndicatorTintColor = param.tfy_BannerControlColor;
        if (param.tfy_BannerControlImage) {
            self.inactiveImage = [UIImage imageNamed:param.tfy_BannerControlImage];
            self.inactiveImageSize = param.tfy_BannerControlImageSize;
            self.pageIndicatorTintColor = [UIColor clearColor];
        }
        if (param.tfy_BannerControlSelectImage) {
            self.currentImage = [UIImage imageNamed:param.tfy_BannerControlSelectImage];
            self.currentImageSize = param.tfy_BannerControlSelectImageSize;
            self.currentPageIndicatorTintColor = [UIColor clearColor];
        }
        
        [self resetFrame];
    }
    return self;
}

- (void)resetFrame{
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == [self.subviews count]-1) {
            CGRect rect = self.frame;
            rect.size.width = CGRectGetMaxX(dot.frame);
            rect.origin.x = (self.param.tfy_Frame.size.width - rect.size.width)/2;
            self.frame = rect;
        }
    }
    if (self.param.tfy_BannerControlPosition == BannerControlLeft) {
          CGRect rect = self.frame;
          rect.origin.x = 30;
          self.frame = rect;
      }
      if (self.param.tfy_BannerControlPosition == BannerControlRight) {
          CGRect rect = self.frame;
          rect.origin.x = self.superview.frame.size.width - rect.size.width  - 30;
          self.frame = rect;
      }
      if (self.param.tfy_CustomControl) {
          self.param.tfy_CustomControl(self);
      }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)updateDots{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        if (i == self.currentPage){
            dot.image = self.currentImage;
            CGRect rect = dot.frame;
            rect.size = self.currentImageSize;
            dot.frame = rect;
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius =  self.param.tfy_BannerControlImageRadius?:self. self.currentImageSize.height/2;
        }else{
            dot.image = self.inactiveImage;
            CGRect rect = dot.frame;
            rect.size = self.inactiveImageSize;
            dot.frame = rect;
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius = self.param.tfy_BannerControlImageRadius?:self. self.inactiveImageSize.height/2;
        }
    }
}


- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{
    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *)view;
    }
    
    return dot;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.param.tfy_BannerControlImage&&self.param.tfy_BannerControlSelectImage){
        UIImageView *tmp = nil;
        for (int i=0; i<[self.subviews count]; i++) {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            CGFloat x = (tmp?CGRectGetMaxX(tmp.frame):0)+self.param.tfy_BannerControlSelectMargin;
            CGFloat y = 0;
            if (i == self.currentPage) {
                y = (self.bounds.size.height - self.currentImageSize.height)/2;
                [dot setFrame:CGRectMake(x, y, self.currentImageSize.width, self.currentImageSize.height)];
            }else {
                y = (self.bounds.size.height - self.inactiveImageSize.height)/2;
                [dot setFrame:CGRectMake(x, y, self.inactiveImageSize.width, self.inactiveImageSize.height)];
            }
            tmp = dot;
            if (i == [self.subviews count]-1) {
                CGRect rect = self.frame;
                rect.size.width = CGRectGetMaxX(dot.frame);
                rect.origin.x = (self.param.tfy_Frame.size.width - rect.size.width)/2;
                self.frame = rect;
            }
        }
        [self resetFrame];
    }
}
@end
