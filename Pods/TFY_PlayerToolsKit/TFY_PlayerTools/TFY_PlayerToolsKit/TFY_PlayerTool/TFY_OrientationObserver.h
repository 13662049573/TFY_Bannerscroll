//
//  TFY_OrientationObserver.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFY_PlayerBaseView.h"

/// 全屏模式
typedef NS_ENUM(NSUInteger, FullScreenMode) {
    FullScreenModeAutomatic,  // 自动确定全屏模式
    FullScreenModeLandscape,  // 横向全屏模式
    FullScreenModePortrait    // 人像全屏模特
};

/// Portrait full screen mode.
typedef NS_ENUM(NSUInteger, PortraitFullScreenMode) {
    PortraitFullScreenModeScaleToFill,    // Full fill
    PortraitFullScreenModeScaleAspectFit  // contents scaled to fit with fixed aspect. remainder is transparent
};

/// Player view mode
typedef NS_ENUM(NSUInteger, RotateType) {
    RotateTypeNormal,         // Normal
    RotateTypeCell            // Cell
};

/**
 Rotation of support direction
 */
typedef NS_OPTIONS(NSUInteger, InterfaceOrientationMask) {
    InterfaceOrientationMaskUnknow = 0,
    InterfaceOrientationMaskPortrait = (1 << 0),
    InterfaceOrientationMaskLandscapeLeft = (1 << 1),
    InterfaceOrientationMaskLandscapeRight = (1 << 2),
    InterfaceOrientationMaskPortraitUpsideDown = (1 << 3),
    InterfaceOrientationMaskLandscape = (InterfaceOrientationMaskLandscapeLeft | InterfaceOrientationMaskLandscapeRight),
    InterfaceOrientationMaskAll = (InterfaceOrientationMaskPortrait | InterfaceOrientationMaskLandscape | InterfaceOrientationMaskPortraitUpsideDown),
    InterfaceOrientationMaskAllButUpsideDown = (InterfaceOrientationMaskPortrait | InterfaceOrientationMaskLandscape),
};

/// This enumeration lists some of the gesture types that the player has by default.
typedef NS_OPTIONS(NSUInteger, DisablePortraitGestureTypes) {
    DisablePortraitGestureTypesNone         = 0,
    DisablePortraitGestureTypesTap          = 1 << 0,
    DisablePortraitGestureTypesPan          = 1 << 1,
    DisablePortraitGestureTypesAll          = (DisablePortraitGestureTypesTap | DisablePortraitGestureTypesPan)
};

@protocol PortraitOrientationDelegate <NSObject>

- (void)tfy_orientationWillChange:(BOOL)isFullScreen;

- (void)tfy_orientationDidChanged:(BOOL)isFullScreen;

- (void)tfy_interationState:(BOOL)isDragging;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_OrientationObserver : NSObject
/**
 *  添加对应的容器
 */
- (void)updateRotateView:(TFY_PlayerBaseView *)rotateView containerView:(UIView *)containerView;
/// Container view of a full screen state player.
@property (nonatomic, strong, readonly, nullable) UIView *fullScreenContainerView;

/// Container view of a small screen state player.
@property (nonatomic, weak) UIView *containerView;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(TFY_OrientationObserver *observer, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(TFY_OrientationObserver *observer, BOOL isFullScreen);

/// Full screen mode, the default landscape into full screen
@property (nonatomic) FullScreenMode fullScreenMode;

@property (nonatomic, assign) PortraitFullScreenMode portraitFullScreenMode;

/// rotate duration, default is 0.30
@property (nonatomic) NSTimeInterval duration;

/// If the full screen.
@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen;

/// Lock screen orientation
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The fullscreen statusbar hidden.
@property (nonatomic, assign) BOOL fullScreenStatusBarHidden;

/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle fullScreenStatusBarStyle;

/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation fullScreenStatusBarAnimation;

@property (nonatomic, assign) CGSize presentationSize;

/// default is TFYDisablePortraitGestureTypesAll.
@property (nonatomic, assign) DisablePortraitGestureTypes disablePortraitGestureTypes;

/// The current orientation of the player.
/// Default is UIInterfaceOrientationPortrait.
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic, assign) BOOL allowOrientationRotation;

/// The support Interface Orientation,default is InterfaceOrientationMaskAllButUpsideDown
@property (nonatomic, assign) InterfaceOrientationMask supportInterfaceOrientation;

/// Add the device orientation observer.
- (void)addDeviceOrientationObserver;

/// Remove the device orientation observer.
- (void)removeDeviceOrientationObserver;

/// Enter the fullScreen while the TFYFullScreenMode is TFYFullScreenModeLandscape.
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/// Enter the fullScreen while the TFYFullScreenMode is TFYFullScreenModeLandscape.
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/// Enter the fullScreen while the TFYFullScreenMode is TFYFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/// Enter the fullScreen while the TFYFullScreenMode is TFYFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/// FullScreen mode is determined by TFYFullScreenMode.
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/// FullScreen mode is determined by TFYFullScreenMode.
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
