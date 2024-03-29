//
//  TFY_PlayerController.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TFY_PlayerMediaPlayback.h"
#import "TFY_OrientationObserver.h"
#import "TFY_PlayerMediaControl.h"
#import "TFY_PlayerGestureControl.h"
#import "TFY_PlayerNotification.h"
#import "TFY_FloatView.h"
#import "UIScrollView+TFY_Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerController : NSObject

/**
 *  你需要适合的控制器，或者默认图片View
 */
@property (nonatomic, strong) UIView *containerView;
/**
 *  currentPlayerManager必须符合`TFY_PlayerMediaPlayback`协议。
 */
@property (nonatomic, strong) id<TFY_PlayerMediaPlayback> currentPlayerManager;

/**
 * 自定义controlView必须符合`TFY_PlayerMediaControl`协议。
 */
@property (nonatomic, strong) UIView<TFY_PlayerMediaControl> *controlView;

/**
 *  通知管理器类
 */
@property (nonatomic, strong, readonly) TFY_PlayerNotification *notification;

/**
 * 容器视图类型。
 */
@property (nonatomic, assign, readonly) PlayerContainerType containerType;

/**
 *  播放的小容器视图。
 */
@property (nonatomic, strong, readonly) TFY_FloatView *smallFloatView;

/**
 *  是否显示小窗口。
 */
@property (nonatomic, assign, readonly) BOOL isSmallFloatViewShow;

/// 滚动视图是tableView或collectionView。
@property (nonatomic, weak, nullable) UIScrollView *scrollView;

/*!
 @method            playerWithPlayerManager:containerView:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of tfyPlayerController.
 */
+ (instancetype)playerWithPlayerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            initWithPlayerManager:containerView:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of tfyPlayerController.
 */
- (instancetype)initWithPlayerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            playerWithScrollView:playerManager:containerViewTag:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item. Use in `UITableView` or `UICollectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of tfyPlayerController.
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView playerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

/*!
 @method            initWithScrollView:playerManager:containerViewTag:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item. Use in `UITableView` or `UICollectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of tfyPlayerController.
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView playerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

/*!
 @method            playerWithScrollView:playerManager:containerView:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item. Use in `UIScrollView`.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerView to see the video at the scrollView.
 @result            An instance of tfyPlayerController.
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView playerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            initWithScrollView:playerManager:containerView:
 @abstract          Create an tfyPlayerController that plays a single audiovisual item. Use in `UIScrollView`.
 @param             playerManager must conform `tfyPlayerMediaPlayback` protocol.
 @param             containerView to see the video at the scrollView.
 @result            An instance of tfyPlayerController.
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView playerManager:(id<TFY_PlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

@end

@interface TFY_PlayerController (PlayerTimeControl)

/// The player current play time.
@property (nonatomic, readonly) NSTimeInterval currentTime;

/// The player total time.
@property (nonatomic, readonly) NSTimeInterval totalTime;

/// The player buffer time.
@property (nonatomic, readonly) NSTimeInterval bufferTime;

/// The player progress, 0...1
@property (nonatomic, readonly) float progress;

/// The player bufferProgress, 0...1
@property (nonatomic, readonly) float bufferProgress;

/**
 Use this method to seek to a specified time for the current player and to be notified when the seek operation is complete.

 @param time seek time.
 @param completionHandler completion handler.
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

@end

@interface TFY_PlayerController (PlayerPlaybackControl)

/// Resume playback record.default is NO.
/// Memory storage playback records.
@property (nonatomic, assign) BOOL resumePlayRecord;

/// 0...1.0
/// Only affects audio volume for the device instance and not for the player.
/// You can change device volume or player volume as needed,change the player volume you can conform the `tfyPlayerMediaPlayback` protocol.
@property (nonatomic) float volume;

/// The device muted.
/// Only affects audio muting for the device instance and not for the player.
/// You can change device mute or player mute as needed,change the player mute you can conform the `tfyPlayerMediaPlayback` protocol.
@property (nonatomic, getter=isMuted) BOOL muted;

// 0...1.0, where 1.0 is maximum brightness. Only supported by main screen.
@property (nonatomic) float brightness;

/// The play asset URL.
@property (nonatomic, nullable) NSURL *assetURL;

/// If tableView or collectionView has only one section , use `assetURLs`.
/// If tableView or collectionView has more sections , use `sectionAssetURLs`.
/// Set this you can use `playTheNext` `playThePrevious` `playTheIndex:` method.
@property (nonatomic, copy, nullable) NSArray <NSURL *>*assetURLs;

/// The currently playing index,limited to one-dimensional arrays.
@property (nonatomic) NSInteger currentPlayIndex;

/// is the last asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isLastAssetURL;

/// is the first asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isFirstAssetURL;

/// If Yes, player will be called pause method When Received `UIApplicationWillResignActiveNotification` notification.
/// default is YES.
@property (nonatomic) BOOL pauseWhenAppResignActive;

/// When the player is playing, it is paused by some event,not by user click to pause.
/// For example, when the player is playing, application goes into the background or pushed to another viewController
@property (nonatomic, getter=isPauseByEvent) BOOL pauseByEvent;

/// The current player controller is disappear, not dealloc
@property (nonatomic, getter=isViewControllerDisappear) BOOL viewControllerDisappear;

/// You can custom the AVAudioSession,
/// default is NO.
@property (nonatomic, assign) BOOL customAudioSession;

/// The block invoked when the player is Prepare to play.
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<TFY_PlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player is Ready to play.
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<TFY_PlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player play progress changed.
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<TFY_PlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration);

/// The block invoked when the player play buffer changed.
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<TFY_PlayerMediaPlayback> asset, NSTimeInterval bufferTime);

/// The block invoked when the player playback state changed.
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<TFY_PlayerMediaPlayback> asset, PlayerPlaybackState playState);

/// The block invoked when the player load state changed.
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<TFY_PlayerMediaPlayback> asset, PlayerLoadState loadState);

/// The block invoked when the player play failed.
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<TFY_PlayerMediaPlayback> asset, id error);

/// The block invoked when the player play end.
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<TFY_PlayerMediaPlayback> asset);

// The block invoked when video size changed.
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<TFY_PlayerMediaPlayback> asset, CGSize size);

/**
 Play the next url ,while the `assetURLs` is not NULL.
 */
- (void)playTheNext;

/**
  Play the previous url ,while the `assetURLs` is not NULL.
 */
- (void)playThePrevious;

/**
 Play the index of url ,while the `assetURLs` is not NULL.

 @param index play the index.
 */
- (void)playTheIndex:(NSInteger)index;

/**
 Player stop and playerView remove from super view,remove other notification.
 */
- (void)stop;

/*!
 @method           replaceCurrentPlayerManager:
 @abstract         Replaces the player's current playeranager with the specified player item.
 @param            manager must conform `tfyPlayerMediaPlayback` protocol
 @discussion       The playerManager that will become the player's current playeranager.
 */
- (void)replaceCurrentPlayerManager:(id<TFY_PlayerMediaPlayback>)manager;

/**
 Add video to cell.
 */
- (void)addPlayerViewToCell;

/**
 Add video to container view.
 */
- (void)addPlayerViewToContainerView:(UIView *)containerView;

/**
 Add to small float view.
 */
- (void)addPlayerViewToSmallFloatView;

/**
 Stop the current playing video and remove the playerView.
 */
- (void)stopCurrentPlayingView;

/**
 stop the current playing video on cell.
 */
- (void)stopCurrentPlayingCell;

@end

@interface TFY_PlayerController (PlayerOrientationRotation)

@property (nonatomic, readonly) TFY_OrientationObserver *orientationObserver;

/// Whether automatic screen rotation is supported.
/// The value is NO.
/// This property is used for the return value of UIViewController `shouldAutorotate` method.
@property (nonatomic, readonly) BOOL shouldAutorotate;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic) BOOL allowOrentitaionRotation;

/// When tfyFullScreenMode is tfyFullScreenModeLandscape the orientation is LandscapeLeft or LandscapeRight, this value is YES.
/// When tfyFullScreenMode is tfyFullScreenModePortrait, while the player fullSceen this value is YES.
@property (nonatomic, readonly) BOOL isFullScreen;

/// when call the `stop` method, exit the fullScreen model, default is YES.
@property (nonatomic, assign) BOOL exitFullScreenWhenStop;

/// Lock the screen orientation.
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(TFY_PlayerController *player, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(TFY_PlayerController *player, BOOL isFullScreen);

/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle fullScreenStatusBarStyle;

/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation fullScreenStatusBarAnimation;

/// The fullscreen statusbar hidden.
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

/**
 Add the device orientation observer.
 */
- (void)addDeviceOrientationObserver;

/**
 Remove the device orientation observer.
 */
- (void)removeDeviceOrientationObserver;

/**
 Enter the fullScreen while the tfyFullScreenMode is tfyFullScreenModeLandscape.

 @param orientation is UIInterfaceOrientation.
 @param animated is animated.
*/
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/**
 Enter the fullScreen while the tfyFullScreenMode is tfyFullScreenModeLandscape.

 @param orientation is UIInterfaceOrientation.
 @param animated is animated.
 @param completion rotating completed callback.
*/
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/**
 Enter the fullScreen while the tfyFullScreenMode is tfyFullScreenModePortrait.

 @param fullScreen is fullscreen.
 @param animated is animated.
 @param completion rotating completed callback.
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/**
 Enter the fullScreen while the tfyFullScreenMode is tfyFullScreenModePortrait.

 @param fullScreen is fullscreen.
 @param animated is animated.
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/**
 FullScreen mode is determined by tfyFullScreenMode.

 @param fullScreen is fullscreen.
 @param animated is animated.
 @param completion rotating completed callback.
 */
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/**
 FullScreen mode is determined by tfyFullScreenMode.

 @param fullScreen is fullscreen.
 @param animated is animated.
 */
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end

@interface TFY_PlayerController (PlayerViewGesture)

/// An instance of tfyPlayerGestureControl.
@property (nonatomic, readonly) TFY_PlayerGestureControl *gestureControl;

/// The gesture types that the player not support.
@property (nonatomic, assign) PlayerDisableGestureTypes disableGestureTypes;

/// The pan gesture moving direction that the player not support.
@property (nonatomic) PlayerDisablePanMovingDirection disablePanMovingDirection;

@end

@interface TFY_PlayerController (PlayerScrollView)

/// The scrollView player should auto player, default is YES.
@property (nonatomic) BOOL shouldAutoPlay;

/// WWAN network auto play, only support in scrollView mode when the `shouldAutoPlay` is YES, default is NO.
@property (nonatomic, getter=isWWANAutoPlay) BOOL WWANAutoPlay;

/// The indexPath is playing.
@property (nonatomic, readonly, nullable) NSIndexPath *playingIndexPath;

/// The indexPath should be play while scrolling.
@property (nonatomic, readonly, nullable) NSIndexPath *shouldPlayIndexPath;

/// The view tag that the player display in scrollView.
@property (nonatomic, readonly) NSInteger containerViewTag;

/// The current playing cell stop playing when the cell has out off the screen，defalut is YES.
@property (nonatomic) BOOL stopWhileNotVisible;

/**
 The current player scroll slides off the screen percent.
 the property used when the `stopWhileNotVisible` is YES, stop the current playing player.
 the property used when the `stopWhileNotVisible` is NO, the current playing player add to small container view.
 The range is 0.0~1.0, defalut is 0.5.
 0.0 is the player will disappear.
 1.0 is the player did disappear.
 */
@property (nonatomic) CGFloat playerDisapperaPercent;

/**
 The current player scroll to the screen percent to play the video.
 The range is 0.0~1.0, defalut is 0.0.
 0.0 is the player will appear.
 1.0 is the player did appear.
 */
@property (nonatomic) CGFloat playerApperaPercent;

/// If tableView or collectionView has more sections, use `sectionAssetURLs`.
@property (nonatomic, copy, nullable) NSArray <NSArray <NSURL *>*>*sectionAssetURLs;

/// The block invoked When the player appearing.
@property (nonatomic, copy, nullable) void(^tfy_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/// The block invoked When the player disappearing.
@property (nonatomic, copy, nullable) void(^tfy_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/// The block invoked When the player will appeared.
@property (nonatomic, copy, nullable) void(^tfy_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did appeared.
@property (nonatomic, copy, nullable) void(^tfy_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player will disappear.
@property (nonatomic, copy, nullable) void(^tfy_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did disappeared.
@property (nonatomic, copy, nullable) void(^tfy_playerDidDisappearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player should play.
@property (nonatomic, copy, nullable) void(^tfy_playerShouldPlayInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did stop scroll.
@property (nonatomic, copy, nullable) void(^tfy_scrollViewDidEndScrollingCallback)(NSIndexPath *indexPath);

/// Filter the cell that should be played when the scroll is stopped (to play when the scroll is stopped).
- (void)tfy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/// Filter the cell that should be played while scrolling (you can use this to filter the highlighted cell).
- (void)tfy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/**
 Play the indexPath of url without scroll postion,  while the `assetURLs` or `sectionAssetURLs` is not NULL.
 
 @param indexPath Play the indexPath of url.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath;

/**
 Play the indexPath of url, while the `assetURLs` or `sectionAssetURLs` is not NULL.

 @param indexPath Play the indexPath of url.
 @param scrollPosition scroll position.
 @param animated scroll animation.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath
          scrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                animated:(BOOL)animated;

/**
 Play the indexPath of url with scroll postion, while the `assetURLs` or `sectionAssetURLs` is not NULL.
 
 @param indexPath Play the indexPath of url.
 @param scrollPosition scroll position.
 @param animated scroll animation.
 @param completionHandler Scroll completion callback.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath
          scrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                animated:(BOOL)animated
       completionHandler:(void (^ __nullable)(void))completionHandler;


/**
 Play the indexPath of url with scroll postion.
 
 @param indexPath Play the indexPath of url
 @param assetURL The player URL.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath assetURL:(NSURL *)assetURL;


/**
 Play the indexPath of url with scroll postion.
 
 @param indexPath Play the indexPath of url
 @param assetURL The player URL.
 @param scrollPosition  scroll position.
 @param animated scroll animation.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath
                assetURL:(NSURL *)assetURL
          scrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                animated:(BOOL)animated;

/**
 Play the indexPath of url with scroll postion.
 
 @param indexPath Play the indexPath of url
 @param assetURL The player URL.
 @param scrollPosition  scroll position.
 @param animated scroll animation.
 @param completionHandler Scroll completion callback.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath
                assetURL:(NSURL *)assetURL
          scrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                animated:(BOOL)animated
       completionHandler:(void (^ __nullable)(void))completionHandler;


@end

NS_ASSUME_NONNULL_END
