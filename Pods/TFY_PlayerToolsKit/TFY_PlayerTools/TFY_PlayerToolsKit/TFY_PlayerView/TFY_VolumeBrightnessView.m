//
//  TFY_VolumeBrightnessView.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_VolumeBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TFY_ITools.h"

@interface TFY_VolumeBrightnessView ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) VolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation TFY_VolumeBrightnessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.progressView];
        [self hideTipView];
    }
    return self;
}

- (void)dealloc {
    [self addSystemVolumeView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.frame.size.width;
    CGFloat min_view_h = self.frame.size.height;
    CGFloat margin = 10;
    
    min_x = margin;
    min_w = 20;
    min_h = min_w;
    min_y = (min_view_h-min_h)/2;
    self.iconImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = CGRectGetMaxX(self.iconImageView.frame) + margin;
    min_h = 2;
    min_y = (min_view_h-min_h)/2;
    min_w = min_view_w - min_x - margin;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.layer.cornerRadius = min_view_h/2;
    self.layer.masksToBounds = YES;
}

- (void)hideTipView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/// 添加系统音量view
- (void)addSystemVolumeView {
    [self.volumeView removeFromSuperview];
}

/// 移除系统音量view
- (void)removeSystemVolumeView {
    [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
}

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType {
    if (progress >= 1) {
        progress = 1;
    } else if (progress <= 0) {
        progress = 0;
    }
    self.progressView.progress = progress;
    self.volumeBrightnessType = volumeBrightnessType;
    UIImage *playerImage = nil;
    if (volumeBrightnessType == VolumeBrightnessTypeVolume) {
        if (progress == 0) {
            playerImage = Player_Image(@"muted");
        } else if (progress > 0 && progress < 0.5) {
            playerImage = Player_Image(@"volume_low");
        } else {
            playerImage = Player_Image(@"volume_high");
        }
    } else if (volumeBrightnessType == VolumeBrightnessTypeumeBrightness) {
        if (progress >= 0 && progress < 0.5) {
            playerImage = Player_Image(@"brightness_low");
        } else {
            playerImage = Player_Image(@"brightness_high");
        }
    }
    self.iconImageView.image = playerImage;
    self.hidden = NO;
    self.alpha = 1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipView) object:nil];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:1.5];
}

- (void)setVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType {
    _volumeBrightnessType = volumeBrightnessType;
    if (volumeBrightnessType == VolumeBrightnessTypeVolume) {
        self.iconImageView.image = Player_Image(@"volume_low");
    } else {
        self.iconImageView.image = Player_Image(@"brightness_low");
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];;
    }
    return _progressView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    }
    return _volumeView;
}


@end
