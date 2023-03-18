//
//  TFY_AVPlayerManager.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_AVPlayerManager.h"
#import <UIKit/UIKit.h>

#import "TFY_PlayerToolsHeader.h"
#import "TFY_ReachabilityManager.h"
#import "TFY_PlayerBaseView.h"
#import "TFY_KVOController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

/*!
 *  刷新AVPlayer定时观察的间隔
 */
static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

@interface TFY_PlayerPresentView : UIView

@property (nonatomic, strong) AVPlayer *player;
/// 默认为AVLayerVideoGravityResizeAspect。
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;

@end

@implementation TFY_PlayerPresentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player == _player) return;
    self.avLayer.player = player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (videoGravity == self.videoGravity) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}

@end


@interface TFY_AVPlayerManager ()
{
    id _timeObserver;
    id _itemEndObserver;
    TFY_KVOController *_playerItemKVO;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation TFY_AVPlayerManager
@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize shouldAutoPlay                 = _shouldAutoPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;


- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = PlayerScalingModeAspectFit;
        _shouldAutoPlay = YES;
    }
    return self;
}

- (void)prepareToPlay {
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    if (self.shouldAutoPlay) {
        [self play];
    }
    self.loadState = PlayerLoadStatePrepare;
    if (self.playerPrepareToPlay) self.playerPrepareToPlay(self, self.assetURL);
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = PlayerPlayStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = PlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
}

- (void)stop {
    [_playerItemKVO safelyRemoveAllObservers];
    self.loadState = PlayerLoadStateUnknown;
    self.playState = PlayerPlayStatePlayStopped;
    if (self.player.rate != 0) [self.player pause];
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.presentationSize = CGSizeZero;
    _timeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    _isPlaying = NO;
    _player = nil;
    _assetURL = nil;
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
}

- (void)replay {
    @player_weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @player_strongify(self)
        if (finished) {
            [self play];
        }
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        [_player.currentItem cancelPendingSeeks];
        int32_t timeScale = _player.currentItem.asset.duration.timescale;
        CMTime seekTime = CMTimeMakeWithSeconds(time, timeScale);
        [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
}

- (UIImage *)thumbnailImageAtCurrentTime {
    CMTime expectedTime = self.playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [self.imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];

    if (!cgImage) {
        self.imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        self.imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [self.imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

- (void)thumbnailImageAtCurrentTime:(void(^)(UIImage *))handler {
    CMTime expectedTime = self.playerItem.currentTime;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:expectedTime]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (handler) {
            UIImage *finalImage = [UIImage imageWithCGImage:image];
            handler(finalImage);
        }
    }];
}

#pragma mark - private method

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}

- (void)initializePlayer {
    _asset = [AVURLAsset URLAssetWithURL:self.assetURL options:self.requestHeader];
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];

    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    
    TFY_PlayerPresentView *presentView = [[TFY_PlayerPresentView alloc] init];
    presentView.player = _player;
    self.view.playerView = presentView;

    self.scalingMode = _scalingMode;
    if (@available(iOS 9.0, *)) {
        _playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    if (@available(iOS 10.0, *)) {
        _playerItem.preferredForwardBufferDuration = 5;
        /// 关闭AVPlayer默认的缓冲延迟播放策略，提高首屏播放速度
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
    [self itemObserving];
}

/// Playback speed switching method
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering || self.playState == PlayerPlayStatePlayStopped) return;
    /// 没有网络
    if ([TFY_ReachabilityManager sharedManager].networkReachabilityStatus == ReachabilityStatusNotReachable) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying && self.loadState == PlayerLoadStateStalled) {
            self.isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) [self bufferingSomeSecond];
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[TFY_KVOController alloc] initWithTarget:_playerItem];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kStatus
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackBufferEmpty
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackLikelyToKeepUp
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kLoadedTimeRanges
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPresentationSize
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    CMTime interval = CMTimeMakeWithSeconds(self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1, NSEC_PER_SEC);
    @player_weakify(self)
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @player_strongify(self)
        if (!self) return;
        NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
        if (self.isPlaying && self.loadState == PlayerLoadStateStalled) self.player.rate = self.rate;
        if (loadedRanges.count > 0) {
            if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
        }
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @player_strongify(self)
        if (!self) return;
        self.playState = PlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                if (!self.isReadyToPlay) {
                    self.isReadyToPlay = YES;
                    self.loadState = PlayerLoadStatePlaythroughOK;
                    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    if (self.shouldAutoPlay) [self pause];
                    @player_weakify(self)
                    [self seekToTime:self.seekTime completionHandler:^(BOOL finished) {
                        @player_strongify(self)
                        if (finished) {
                            if (self.shouldAutoPlay) [self play];
                        }
                    }];
                    self.seekTime = 0;
                } else {
                    if (self.shouldAutoPlay && self.isPlaying) [self play];
                }
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = PlayerPlayStatePlayFailed;
                self->_isPlaying = NO;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            // When the buffer is empty
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = PlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // When the buffer is good
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = PlayerLoadStatePlayable;
                if (self.isPlaying) [self.player play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self.presentationSize = self.playerItem.presentationSize;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (TFY_PlayerBaseView *)view {
    if (!_view) {
        TFY_PlayerBaseView *view = [[TFY_PlayerBaseView alloc] init];
        _view = view;
    }
    return _view;
}

- (AVPlayerLayer *)avPlayerLayer {
    TFY_PlayerPresentView *view = (TFY_PlayerPresentView *)self.view.playerView;
    return [view avLayer];
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}

#pragma mark - setter

- (void)setPlayState:(PlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(PlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setScalingMode:(PlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    TFY_PlayerPresentView *presentView = (TFY_PlayerPresentView *)self.view.playerView;
    self.view.scalingMode = scalingMode;
    switch (scalingMode) {
        case PlayerScalingModeNone:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case PlayerScalingModeAspectFit:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case PlayerScalingModeAspectFill:
            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case PlayerScalingModeFill:
            presentView.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            break;
    }
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = _volume;
}

- (void)setPresentationSize:(CGSize)presentationSize {
    _presentationSize = presentationSize;
    self.view.presentationSize = presentationSize;
    if (self.presentationSizeChanged) {
        self.presentationSizeChanged(self, self.presentationSize);
    }
}


@end

#pragma clang diagnostic pop
