//
//  TFY_PlayerBaseView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerBaseView.h"

@implementation TFY_PlayerBaseView
@synthesize presentationSize = _presentationSize;
@synthesize coverImageView = _coverImageView;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.coverImageView];
    }
    return self;
}

- (void)setPlayerView:(UIView *)playerView {
    if (_playerView) {
        [_playerView removeFromSuperview];
        self.presentationSize = CGSizeZero;
    }
    _playerView = playerView;
    if (playerView != nil) {
        [self addSubview:playerView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGSize playerViewSize = CGSizeZero;
    CGFloat videoWidth = self.presentationSize.width;
    CGFloat videoHeight = self.presentationSize.height;
    if (videoHeight == 0) return;
    CGFloat screenScale = min_view_w/min_view_h;
    CGFloat videoScale = videoWidth/videoHeight;
    if (screenScale > videoScale) {
        CGFloat height = min_view_h;
        CGFloat width = height * videoScale;
        playerViewSize = CGSizeMake(width, height);
    } else {
        CGFloat width = min_view_w;
        CGFloat height = width / videoScale;
        playerViewSize = CGSizeMake(width, height);
    }
    
    if (self.scalingMode == PlayerScalingModeNone || self.scalingMode == PlayerScalingModeAspectFit) {
        min_w = playerViewSize.width;
        min_h = playerViewSize.height;
        min_x = (min_view_w - min_w) / 2.0;
        min_y = (min_view_h - min_h) / 2.0;
        self.playerView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    } else if (self.scalingMode == PlayerScalingModeAspectFill || self.scalingMode == PlayerScalingModeFill) {
        self.playerView.frame = self.bounds;
    }
    self.coverImageView.frame = self.playerView.frame;
}

- (CGSize)presentationSize {
    if (CGSizeEqualToSize(_presentationSize, CGSizeZero)) {
        _presentationSize = self.frame.size;
    }
    return _presentationSize;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (void)setScalingMode:(PlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
     if (scalingMode == PlayerScalingModeNone || scalingMode == PlayerScalingModeAspectFit) {
         self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    } else if (scalingMode == PlayerScalingModeAspectFill) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else if (scalingMode == PlayerScalingModeFill) {
        self.coverImageView.contentMode = UIViewContentModeScaleToFill;
    }
    [self layoutIfNeeded];
}

- (void)setPresentationSize:(CGSize)presentationSize {
    _presentationSize = presentationSize;
    if (CGSizeEqualToSize(CGSizeZero, presentationSize)) return;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
