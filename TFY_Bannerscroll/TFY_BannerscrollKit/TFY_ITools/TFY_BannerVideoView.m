//
//  TFY_BannerVideoView.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2022/3/22.
//  Copyright © 2022 田风有. All rights reserved.
//

#import "TFY_BannerVideoView.h"
#import "TFY_VideoMaskView.h"
#import <MediaPlayer/MediaPlayer.h>

@import AVFoundation;
@import AVKit;

@interface TFY_BannerVideoView ()<AVPlayerViewControllerDelegate>

@property (nonatomic, strong) AVPlayerViewController *videoPlayer;

@property (nonatomic, strong) TFY_VideoMaskView *videoMaskView;

@property (nonatomic, strong) id timeObserve;
/** 音量控制滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

@end

@implementation TFY_BannerVideoView

- (void)loadUI {
    
    [self addSubview:self.videoPlayer.view];
    [self addSubview:self.videoMaskView];
    
    [self systemVolumeView];

    __weak typeof(self) weakSelf = self;
    self.videoMaskView.buttonValue = ^(TFY_PlayerState state) {
        switch (state) {
            case TFY_PlayerStateStart: {
                weakSelf.videoMaskView.isStartButton = !weakSelf.videoMaskView.isStartButton;
                weakSelf.isPlay = weakSelf.videoMaskView.isStartButton;
                weakSelf.videoMaskView.isStartButton ? [weakSelf.videoPlayer.player play] : [weakSelf.videoPlayer.player pause];
            }
                break;
            case TFY_PlayerStateReplay: { //重新播放  归0、
                
                weakSelf.videoMaskView.isStartButton = YES;
                weakSelf.isPlay = weakSelf.videoMaskView.isStartButton;
                
                CMTime dragedCMTime = CMTimeMake(0, 1);
                [weakSelf.videoPlayer.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
                    [weakSelf.videoPlayer.player play];
                }];
                
            }
                break;
                
            default:
                break;
        }
    };
    self.videoMaskView.broadcasting_Block = ^(UIButton * _Nonnull btn) {
        btn.selected = !btn.selected;
        if (btn.selected) {//
            weakSelf.volumeViewSlider.value  = 1;
        } else {
            weakSelf.volumeViewSlider.value  = 0;
        }
    };
    
    // ******* 监听player *******
    [self.videoPlayer.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)systemVolumeView {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self createTimer];
    }
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    [self loadUI];
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.videoPlayer.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.videoPlayer.player.currentItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.videoMaskView playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];
}

- (void)start {
    [self.videoPlayer.player play];
}

- (void)stop {
    [self.videoPlayer.player pause];
}

- (AVPlayerViewController *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[AVPlayerViewController alloc]init];
        _videoPlayer.view.frame = self.frame;
        _videoPlayer.delegate = self;
        _videoPlayer.showsPlaybackControls = NO;
        _videoPlayer.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoUrl]];
    }
    return _videoPlayer;
}

- (TFY_VideoMaskView *)videoMaskView {
    if (!_videoMaskView) {
        _videoMaskView = [[TFY_VideoMaskView alloc]initWithFrame:self.frame];
    }
    return _videoMaskView;
}

- (void)dealloc {
    [self stop];
    [self.videoPlayer.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    // 移除time观察者
    if (self.timeObserve) {
        [self.videoPlayer.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}


@end
