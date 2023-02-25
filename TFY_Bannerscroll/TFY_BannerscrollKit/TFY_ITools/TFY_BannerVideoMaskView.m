//
//  TFY_BannerVideoMaskView.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BannerVideoMaskView.h"

@interface TFY_BannerVideoMaskView ()// ******* 底部进度条 *******
@property (nonatomic, strong) UIProgressView *progressView;
// ******* 开始播放按钮 *******
@property (nonatomic, strong) UIButton *stratButton;
@property (nonatomic, strong) UIButton *broadcastingButton;
// ******* 单击手势 *******
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
// ******* 重新播放按钮 *******
@property (nonatomic, strong) UIButton *replayButton;

@end

@implementation TFY_BannerVideoMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    [self addSubview:self.stratButton];
    [self addSubview:self.replayButton];
    [self addSubview:self.broadcastingButton];
    [self addSubview:self.progressView];
    
    [self createGesture];
    
}

/*
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.singleTap];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (self.progressValue == 1) {
        return;
    }
    if (self.buttonValue) {
        self.buttonValue(TFY_PlayerStateStart);
    }
}

- (void)setIsStartButton:(BOOL)isStartButton {
    _isStartButton = isStartButton;
    isStartButton ? [self.stratButton setHidden:YES] : [self.stratButton setHidden:NO];
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    self.progressView.progress = progressValue;
    progressValue == 1 ? [self.replayButton setHidden:NO] : [self.replayButton setHidden:YES];
}

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue {
    self.progressValue = sliderValue;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 2, CGRectGetWidth(self.frame), 5)];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.progressTintColor = [UIColor orangeColor];
        _progressView.progress = 0;
    }
    return _progressView;
}

// 播放
- (UIButton *)stratButton {
    if (!_stratButton) {
        _stratButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stratButton.bounds = CGRectMake(0, 0, 64, 64);
        _stratButton.center = self.center;
        [_stratButton setImage:[self tfy_fileImage:@"banner_play"] forState:UIControlStateNormal];
        [_stratButton addTarget:self action:@selector(startButtonTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stratButton;
}

// 重播
- (UIButton *)replayButton {
    if (!_replayButton) {
        _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replayButton.bounds = CGRectMake(0, 0, 64, 64);
        _replayButton.center = self.center;
        [_replayButton setImage:[self tfy_fileImage:@"banner_replay"] forState:UIControlStateNormal];
        _replayButton.hidden = YES;
        [_replayButton addTarget:self action:@selector(replayButtonTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replayButton;
}

- (UIButton *)broadcastingButton {
    if (!_broadcastingButton) {
        _broadcastingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _broadcastingButton.frame = CGRectMake(CGRectGetWidth(self.frame)-42, CGRectGetHeight(self.frame)-42, 32, 32);
        [_broadcastingButton setImage:[self tfy_fileImage:@"banner_broadcasting"] forState:UIControlStateNormal];
        [_broadcastingButton setImage:[self tfy_fileImage:@"banner_notes"] forState:UIControlStateSelected];
        [_broadcastingButton addTarget:self action:@selector(broadcastingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _broadcastingButton;
}

-(UIImage *)tfy_fileImage:(NSString *)fileImage {
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"TFY_banner" ofType:@"bundle"] stringByAppendingPathComponent:fileImage]];
}


- (void)startButtonTaped {
    if (self.buttonValue) {
        self.buttonValue(TFY_PlayerStateStart);
    }
}

- (void)replayButtonTaped {
    if (self.buttonValue) {
        self.buttonValue(TFY_PlayerStateReplay);
    }
}

- (void)broadcastingButtonClick:(UIButton *)btn {
    if (self.broadcasting_Block) {
        self.broadcasting_Block(btn);
    }
}


@end
