//
//  TFY_ImageViewCell.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/23.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_ImageViewCell.h"

@implementation TFY_ImageViewCell

- (void)baseBannerViewLayout {
    [self.contentView addSubview:self.bannerImageView];
}

- (void)setParam:(TFY_BannerParam *)param{
    [super setParam:param];
   self.bannerImageView.contentMode = param.tfy_ImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleToFill;
    if (param.tfy_bannerRadius > 0) {
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = ({
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bannerImageView.bounds cornerRadius:param.tfy_bannerRadius];
            path.CGPath;
        });
        self.bannerImageView.layer.mask = maskLayer;
    }
}

- (UIImageView*)bannerImageView{
    if(!_bannerImageView){
        _bannerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bannerImageView.clipsToBounds = YES;
    }
    return _bannerImageView;
}

@end
