//
//  TFY_BannerImageViewCell.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BannerImageViewCell.h"

@interface TFY_BannerImageViewCell ()
@property(nonatomic , strong)UIButton *paybtn;
@property(nonatomic , strong)NSMutableDictionary *musicPlayers;
@end

@implementation TFY_BannerImageViewCell

-(NSMutableDictionary *)musicPlayers {
    if(!_musicPlayers){
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}

- (void)baseBannerViewLayout {
    [self.contentView addSubview:self.bannerImageView];
    [self.bannerImageView addSubview:self.paybtn];
    _paybtn.center = self.bannerImageView.center;
}

- (void)setParam:(TFY_BannerParam *)param {
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

- (void)setBannerUrl:(NSString *)bannerUrl {
    [super setBannerUrl:bannerUrl];
    if ([self isVideoUrlString:bannerUrl]) {
        self.paybtn.hidden = NO;
        UIImage *videoImage = [self musicPlayers][bannerUrl];
        if (videoImage == nil) {
            videoImage =  [self privateGetVideoPreViewImage:[NSURL URLWithString:bannerUrl]];
            [self musicPlayers][bannerUrl] = videoImage;
        }
        self.bannerImageView.image = videoImage;
    } else {
        self.paybtn.hidden = YES;
        UIImage *defaultimage = [UIImage imageNamed:self.param.tfy_PlaceholderImage?self.param.tfy_PlaceholderImage:@""];
        if (kBannerLocality(bannerUrl)) {
            self.bannerImageView.image = [UIImage imageNamed:bannerUrl];
        } else {
            [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:defaultimage];
        }
    }
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
        self.banner_Block(sender, self.bannerUrl);
    }
}

- (UIImage *)privateGetVideoPreViewImage:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

@end
