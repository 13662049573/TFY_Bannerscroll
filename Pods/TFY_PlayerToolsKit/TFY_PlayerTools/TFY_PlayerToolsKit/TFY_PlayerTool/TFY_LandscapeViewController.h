//
//  TFY_LandscapeViewController.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFY_LandscapeViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol LandscapeViewControllerDelegate <NSObject>
@optional
- (BOOL)ls_shouldAutorotate;
- (void)rotationFullscreenViewController:(TFY_LandscapeViewController *)viewController viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

@end

@interface TFY_LandscapeViewController : UIViewController

@property (nonatomic, weak, nullable) id<LandscapeViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL disableAnimations;

@property (nonatomic, assign) BOOL statusBarHidden;
/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation statusBarAnimation;

@end

NS_ASSUME_NONNULL_END
