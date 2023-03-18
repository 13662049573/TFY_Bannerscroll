//
//  TFY_LandscapeRotationManager.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_OrientationObserver.h"
#import "TFY_LandscapeWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_LandscapeRotationManager : NSObject

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(UIInterfaceOrientation orientation);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(UIInterfaceOrientation orientation);

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, strong, nullable) TFY_LandscapeWindow *window;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic, assign) BOOL allowOrientationRotation;

/// Lock screen orientation
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

@property (nonatomic, assign) BOOL disableAnimations;

/// The support Interface Orientation,default is InterfaceOrientationMaskAllButUpsideDown
@property (nonatomic, assign) InterfaceOrientationMask supportInterfaceOrientation;

/// The current orientation of the player.
/// Default is UIInterfaceOrientationPortrait.
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;

@property (nonatomic, strong, readonly, nullable) TFY_LandscapeViewController *landscapeViewController;

/// current device orientation observer is activie.
@property (nonatomic, assign) BOOL activeDeviceObserver;

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation completion:(void(^ __nullable)(void))completion;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

- (UIInterfaceOrientation)getCurrentOrientation;

- (void)handleDeviceOrientationChange;

/// update the rotateView and containerView.
- (void)updateRotateView:(TFY_PlayerBaseView *)rotateView
           containerView:(UIView *)containerView;

- (UIView *)fullScreenContainerView;

- (BOOL)isSuppprtInterfaceOrientation:(UIInterfaceOrientation)orientation;

+ (InterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
