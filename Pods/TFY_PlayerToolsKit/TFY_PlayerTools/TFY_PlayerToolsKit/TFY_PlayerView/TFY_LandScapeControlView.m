//
//  TFY_LandScapeControlView.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandScapeControlView.h"
#import "UIView+PlayerFrame.h"
#import "TFY_ITools.h"
#import "TFY_PlayerStatusBar.h"
#import "TFY_PlayerToolsHeader.h"

@interface TFY_LandScapeControlView ()<TFY_SliderViewDelegate>

@property (nonatomic, strong) TFY_PlayerStatusBar *statusBarView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) TFY_SliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation TFY_LandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.statusBarView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self addSubview:self.lockBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = Player_iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 20;
    self.statusBarView.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_x = (Player_iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    if (@available(iOS 13.0, *)) {
        if (self.showCustomStatusBar) {
            min_y = self.statusBarView.player_bottom;
        } else {
            min_y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 10 : (Player_iPhoneX ? 40 : 20);
        }
    } else {
        min_y = (Player_iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 10: (Player_iPhoneX ? 40 : 20);
    }
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.player_right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.player_centerY = self.backBtn.player_centerY;
    
    min_h = Player_iPhoneX ? 100 : 73;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (Player_iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    min_y = 32;
    min_w = 30;
    min_h = 30;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.player_right + 4;
    min_y = 0;
    min_w = 62;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.player_centerY = self.playOrPauseBtn.player_centerY;
    
    min_w = 62;
    min_x = self.bottomToolView.player_width - min_w - ((Player_iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: min_margin);
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.player_centerY = self.playOrPauseBtn.player_centerY;
    
    min_x = self.currentTimeLabel.player_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.player_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.player_centerY = self.playOrPauseBtn.player_centerY;
    
    min_x = (Player_iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.player_centerY = self.player_centerY;
    
    if (!self.isShow) {
        self.topToolView.player_y = -self.topToolView.player_height;
        self.bottomToolView.player_y = self.player_height;
        self.lockBtn.player_left = Player_iPhoneX ? -82: -47;
    } else {
        self.lockBtn.player_left = Player_iPhoneX ? 50: 18;
        if (self.player.isLockedScreen) {
            self.topToolView.player_y = -self.topToolView.player_height;
            self.bottomToolView.player_y = self.player_height;
        } else {
            self.topToolView.player_y = 0;
            self.bottomToolView.player_y = self.player_height - self.bottomToolView.player_height;
        }
    }
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)layoutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & InterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

#pragma mark - TFY_SliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @player_weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @player_strongify(self)
            self.slider.isdragging = NO;
            if (finished) {
                if (self.sliderValueChanged) self.sliderValueChanged(value);
                if (self.seekToPlay) {
                    [self.player.currentPlayerManager play];
                }
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [TFY_ITools convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    NSString *currentTimeString = [TFY_ITools convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

#pragma mark - public method

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
    self.lockBtn.selected            = self.player.isLockedScreen;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.player_y        = -self.topToolView.player_height;
        self.bottomToolView.player_y     = self.player_height;
    } else {
        self.topToolView.player_y        = 0;
        self.bottomToolView.player_y     = self.player_height - self.bottomToolView.player_height;
    }
    self.lockBtn.player_left             = Player_iPhoneX ? 50: 18;
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
    }
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.player_y            = -self.topToolView.player_height;
    self.bottomToolView.player_y         = self.player_height;
    self.lockBtn.player_left             = Player_iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(PlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != PlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == FullScreenModePortrait;
}

/// 视频view即将旋转
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer orientationWillChange:(TFY_OrientationObserver *)observer {
    if (self.showCustomStatusBar) {
        if (self.hidden) {
            [self.statusBarView destoryTimer];
        } else {
            [self.statusBarView startTimer];
        }
    }
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [TFY_ITools convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [TFY_ITools convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(FullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == FullScreenModePortrait;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - setter

- (void)setFullScreenMode:(FullScreenMode)fullScreenMode {
    _fullScreenMode = fullScreenMode;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == FullScreenModePortrait;
}

- (void)setShowCustomStatusBar:(BOOL)showCustomStatusBar {
    _showCustomStatusBar = showCustomStatusBar;
    self.statusBarView.hidden = !showCustomStatusBar;
}

#pragma mark - getter

- (TFY_PlayerStatusBar *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = [[TFY_PlayerStatusBar alloc] init];
        _statusBarView.hidden = YES;
    }
    return _statusBarView;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = Player_Image(@"Player_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:Player_Image(@"Player_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = Player_Image(@"Player_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:Player_Image(@"Player_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:Player_Image(@"Player_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (TFY_SliderView *)slider {
    if (!_slider) {
        _slider = [[TFY_SliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:Player_Image(@"Player_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:Player_Image(@"Player_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:Player_Image(@"Player_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

@end
