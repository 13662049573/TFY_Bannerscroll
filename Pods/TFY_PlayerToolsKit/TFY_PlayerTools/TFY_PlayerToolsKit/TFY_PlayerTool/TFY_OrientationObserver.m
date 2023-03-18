//
//  TFY_OrientationObserver.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_OrientationObserver.h"
#import "TFY_PlayerToolsHeader.h"
#import "TFY_LandscapeWindow.h"
#import "TFY_PortraitViewController.h"
#import <objc/runtime.h>
#import "TFY_LandscapeRotationManager_iOS15.h"
#import "TFY_LandscapeRotationManager_iOS16.h"
#import "TFY_PlayerBaseView.h"

@interface UIWindow (CurrentViewController)

+ (UIViewController*)tfy_currentViewController;

@end

@implementation UIWindow (CurrentViewController)

+ (UIViewController*)tfy_currentViewController {
    __block UIWindow *window;
    if (@available(iOS 13, *)) {
        [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull scene, BOOL * _Nonnull scenesStop) {
            if ([scene isKindOfClass: [UIWindowScene class]]) {
                UIWindowScene * windowScene = (UIWindowScene *)scene;
                [windowScene.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull windowTemp, NSUInteger idx, BOOL * _Nonnull windowStop) {
                    if (windowTemp.isKeyWindow) {
                        window = windowTemp;
                        *windowStop = YES;
                        *scenesStop = YES;
                    }
                }];
            }
        }];
    } else {
        window = [[UIApplication sharedApplication].delegate window];
    }
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}


@end

@interface TFY_OrientationObserver ()
@property (nonatomic, weak) TFY_PlayerBaseView *view;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, strong) TFY_PortraitViewController *portraitViewController;

@property (nonatomic, strong) TFY_LandscapeRotationManager *landscapeRotationManager;

/// current device orientation observer is activie.
@property (nonatomic, assign) BOOL activeDeviceObserver;

@end

@implementation TFY_OrientationObserver
@synthesize presentationSize = _presentationSize;

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = 0.30;
        _fullScreenMode = FullScreenModeLandscape;
        _portraitFullScreenMode = PortraitFullScreenModeScaleToFill;
        _disablePortraitGestureTypes = DisablePortraitGestureTypesAll;
        self.supportInterfaceOrientation = InterfaceOrientationMaskAllButUpsideDown;
        self.allowOrientationRotation = YES;
        self.activeDeviceObserver = YES;
    }
    return self;
}

- (void)updateRotateView:(TFY_PlayerBaseView *)rotateView
           containerView:(UIView *)containerView {
    self.view = rotateView;
    self.containerView = containerView;
    [self.landscapeRotationManager updateRotateView:rotateView containerView:containerView];
}


- (void)dealloc {
    [self removeDeviceOrientationObserver];
}

- (void)addDeviceOrientationObserver {
    if (self.allowOrientationRotation) {
        self.activeDeviceObserver = YES;
        if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)removeDeviceOrientationObserver {
    self.activeDeviceObserver = NO;
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange {
    if (self.fullScreenMode == FullScreenModePortrait || !self.allowOrientationRotation) return;
    [self.landscapeRotationManager handleDeviceOrientationChange];
}

#pragma mark - public

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    [self rotateToOrientation:orientation animated:animated completion:nil];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion {
    if (self.fullScreenMode == FullScreenModePortrait) return;
    [self.landscapeRotationManager rotateToOrientation:orientation animated:animated completion:completion];
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    [self enterPortraitFullScreen:fullScreen animated:animated completion:nil];
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion {
    self.fullScreen = fullScreen;
    if (fullScreen) {
        self.portraitViewController.contentView = self.view;
        self.portraitViewController.containerView = self.containerView;
        self.portraitViewController.duration = self.duration;
        if (self.portraitFullScreenMode == PortraitFullScreenModeScaleAspectFit) {
            self.portraitViewController.presentationSize = self.presentationSize;
        } else if (self.portraitFullScreenMode == PortraitFullScreenModeScaleToFill) {
            self.portraitViewController.presentationSize = CGSizeMake(TFY_PLAYER_ScreenW, TFY_PLAYER_ScreenH);
        }
        self.portraitViewController.fullScreenAnimation = animated;
        [[UIWindow tfy_currentViewController] presentViewController:self.portraitViewController animated:animated completion:^{
            if (completion) completion();
        }];
    } else {
        self.portraitViewController.fullScreenAnimation = animated;
        [self.portraitViewController dismissViewControllerAnimated:animated completion:^{
            if (completion) completion();
        }];
    }
}

- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    [self enterFullScreen:fullScreen animated:animated completion:nil];
}

- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    if (self.fullScreenMode == FullScreenModePortrait) {
        [self enterPortraitFullScreen:fullScreen animated:animated completion:completion];
    } else {
        UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
        orientation = fullScreen? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
        [self rotateToOrientation:orientation animated:animated completion:completion];
    }
}

#pragma mark - getter

- (TFY_PortraitViewController *)portraitViewController {
    if (!_portraitViewController) {
        @player_weakify(self)
        _portraitViewController = [[TFY_PortraitViewController alloc] init];
        if (@available(iOS 9.0, *)) {
            [_portraitViewController loadViewIfNeeded];
        } else {
            [_portraitViewController view];
        }
        _portraitViewController.orientationWillChange = ^(BOOL isFullScreen) {
            @player_strongify(self)
            self.fullScreen = isFullScreen;
            if (self.orientationWillChange) self.orientationWillChange(self, isFullScreen);
        };
        _portraitViewController.orientationDidChanged = ^(BOOL isFullScreen) {
            @player_strongify(self)
            self.fullScreen = isFullScreen;
            if (self.orientationDidChanged) self.orientationDidChanged(self, isFullScreen);
        };
    }
    return _portraitViewController;
}

- (TFY_LandscapeRotationManager *)landscapeRotationManager {
    if (!_landscapeRotationManager) {
        if (@available(iOS 16.0, *)) {
            _landscapeRotationManager = [[TFY_LandscapeRotationManager_iOS16 alloc] init];
        } else {
            _landscapeRotationManager = [[TFY_LandscapeRotationManager_iOS15 alloc] init];
        }
        @player_weakify(self)
        _landscapeRotationManager.orientationWillChange = ^(UIInterfaceOrientation orientation) {
            @player_strongify(self)
            self.fullScreen = UIInterfaceOrientationIsLandscape(orientation);
            if (self.orientationWillChange) self.orientationWillChange(self, self.fullScreen);
        };
        
        _landscapeRotationManager.orientationDidChanged = ^(UIInterfaceOrientation orientation) {
            @player_strongify(self)
            self.fullScreen = UIInterfaceOrientationIsLandscape(orientation);
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.fullScreen);
        };
    }
    return _landscapeRotationManager;
}

- (UIView *)fullScreenContainerView {
    if (self.fullScreenMode == FullScreenModeLandscape) {
        return self.landscapeRotationManager.fullScreenContainerView;
    } else if (self.fullScreenMode == FullScreenModePortrait) {
        return self.portraitViewController.view;
    }
    return nil;
}

- (UIInterfaceOrientation)currentOrientation {
    if (self.fullScreenMode == FullScreenModeLandscape) {
        return self.landscapeRotationManager.currentOrientation;
    }
    return [self.landscapeRotationManager getCurrentOrientation];
}

#pragma mark - setter

- (void)setLockedScreen:(BOOL)lockedScreen {
    _lockedScreen = lockedScreen;
    self.landscapeRotationManager.lockedScreen = lockedScreen;
    if (lockedScreen) {
        [self removeDeviceOrientationObserver];
    } else {
        [self addDeviceOrientationObserver];
    }
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    [self.landscapeRotationManager.landscapeViewController setNeedsStatusBarAppearanceUpdate];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)setFullScreenStatusBarHidden:(BOOL)fullScreenStatusBarHidden {
    _fullScreenStatusBarHidden = fullScreenStatusBarHidden;
    if (self.fullScreenMode == FullScreenModePortrait) {
        self.portraitViewController.statusBarHidden = fullScreenStatusBarHidden;
        [self.portraitViewController setNeedsStatusBarAppearanceUpdate];
    } else if (self.fullScreenMode == FullScreenModeLandscape) {
        self.landscapeRotationManager.landscapeViewController.statusBarHidden = fullScreenStatusBarHidden;
        [self.landscapeRotationManager.landscapeViewController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setFullScreenStatusBarStyle:(UIStatusBarStyle)fullScreenStatusBarStyle {
    _fullScreenStatusBarStyle = fullScreenStatusBarStyle;
    if (self.fullScreenMode == FullScreenModePortrait) {
        self.portraitViewController.statusBarStyle = fullScreenStatusBarStyle;
        [self.portraitViewController setNeedsStatusBarAppearanceUpdate];
    } else if (self.fullScreenMode == FullScreenModeLandscape) {
        self.landscapeRotationManager.landscapeViewController.statusBarStyle = fullScreenStatusBarStyle;
        [self.landscapeRotationManager.landscapeViewController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setFullScreenStatusBarAnimation:(UIStatusBarAnimation)fullScreenStatusBarAnimation {
    _fullScreenStatusBarAnimation = fullScreenStatusBarAnimation;
    if (self.fullScreenMode == FullScreenModePortrait) {
        self.portraitViewController.statusBarAnimation = fullScreenStatusBarAnimation;
        [self.portraitViewController setNeedsStatusBarAppearanceUpdate];
    } else if (self.fullScreenMode == FullScreenModeLandscape) {
        self.landscapeRotationManager.landscapeViewController.statusBarAnimation = fullScreenStatusBarAnimation;
        [self.landscapeRotationManager.landscapeViewController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setDisablePortraitGestureTypes:(DisablePortraitGestureTypes)disablePortraitGestureTypes {
    _disablePortraitGestureTypes = disablePortraitGestureTypes;
    self.portraitViewController.disablePortraitGestureTypes = disablePortraitGestureTypes;
}

- (void)setPresentationSize:(CGSize)presentationSize {
    _presentationSize = presentationSize;
    if (self.fullScreenMode == FullScreenModePortrait && self.portraitFullScreenMode == PortraitFullScreenModeScaleAspectFit) {
        self.portraitViewController.presentationSize = presentationSize;
    }
}

- (void)setView:(TFY_PlayerBaseView *)view {
    if (view == _view) { return; }
    _view = view;
    if (self.fullScreenMode == FullScreenModeLandscape) {
        self.landscapeRotationManager.contentView = view;
    } else if (self.fullScreenMode == FullScreenModePortrait) {
        self.portraitViewController.contentView = view;
    }
}

- (void)setContainerView:(UIView *)containerView {
    if (containerView == _containerView) { return; }
    _containerView = containerView;
    if (self.fullScreenMode == FullScreenModeLandscape) {
        self.landscapeRotationManager.containerView = containerView;
    } else if (self.fullScreenMode == FullScreenModePortrait) {
        self.portraitViewController.containerView = containerView;
    }
}

- (void)setAllowOrientationRotation:(BOOL)allowOrientationRotation {
    _allowOrientationRotation = allowOrientationRotation;
    self.landscapeRotationManager.allowOrientationRotation = allowOrientationRotation;
}

- (void)setSupportInterfaceOrientation:(InterfaceOrientationMask)supportInterfaceOrientation {
    _supportInterfaceOrientation = supportInterfaceOrientation;
    self.landscapeRotationManager.supportInterfaceOrientation = supportInterfaceOrientation;
}

- (void)setActiveDeviceObserver:(BOOL)activeDeviceObserver {
    _activeDeviceObserver = activeDeviceObserver;
    self.landscapeRotationManager.activeDeviceObserver = activeDeviceObserver;
}


@end
