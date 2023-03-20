//
//  TFY_PortraitViewController.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_OrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PortraitViewController : UIViewController

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(BOOL isFullScreen);

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) BOOL statusBarHidden;

/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation statusBarAnimation;

/// default is DisablePortraitGestureTypesNone.
@property (nonatomic, assign) DisablePortraitGestureTypes disablePortraitGestureTypes;

@property (nonatomic, assign) CGSize presentationSize;

@property (nonatomic, assign) BOOL fullScreenAnimation;

@property (nonatomic, assign) NSTimeInterval duration;

@end

NS_ASSUME_NONNULL_END
