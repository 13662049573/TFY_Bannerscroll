//
//  TFY_BannerImageViewCell.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BannerImageViewCell.h"

#define HasPlayerToolsKit (__has_include(<TFY_PlayerToolsKit.h>) || __has_include("TFY_PlayerToolsKit.h"))

@interface TFY_BannerImageViewCell ()
@property(nonatomic , strong)UIButton *paybtn;
@end

@implementation TFY_BannerImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseBannerViewLayout];
    }
    return self;
}

- (void)baseBannerViewLayout {
    [self.contentView addSubview:self.bannerImageView];
    [self.bannerImageView addSubview:self.paybtn];
    _paybtn.center = self.bannerImageView.center;
}

- (void)setParam:(TFY_BannerParam *)param {
    _param = param;
   self.bannerImageView.contentMode = param.tfy_ImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleAspectFit;
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

- (void)setBannerUrl:(NSString *)bannerUrl {
    _bannerUrl = bannerUrl;
#if HasPlayerToolsKit
    if ([self isVideoUrlString:bannerUrl]) {
        self.paybtn.hidden = NO;
    } else {
        self.paybtn.hidden = YES;
    }
#else
    self.paybtn.hidden = YES;
#endif
}

/* 判断url是否是视频 */
- (BOOL)isVideoUrlString:(NSString *)urlString
{
    // 判断是否含有视频轨道（是否是视频）
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:urlString] options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    return [tracks count] > 0;
}

- (UIImageView*)bannerImageView{
    if(!_bannerImageView){
        _bannerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.userInteractionEnabled = YES;
    }
    return _bannerImageView;
}

- (UIButton *)paybtn {
    if (!_paybtn) {
        _paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _paybtn.frame = CGRectMake(0, 0, 40, 40);
        [_paybtn setImage:[self tfy_fileImage:@"banner_play"] forState:UIControlStateNormal];
        [_paybtn addTarget:self action:@selector(privatePlayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paybtn;
}

-(UIImage *)tfy_fileImage:(NSString *)fileImage {
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"TFY_banner" ofType:@"bundle"] stringByAppendingPathComponent:fileImage]];
}

- (void)privatePlayButton:(UIButton *)sender {
    if (self.banner_Block) {
        self.banner_Block(self.bannerImageView, self.bannerUrl);
    }
}

@end
