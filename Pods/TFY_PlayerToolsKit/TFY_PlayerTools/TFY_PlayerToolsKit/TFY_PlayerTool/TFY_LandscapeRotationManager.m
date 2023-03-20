//
//  TFY_LandscapeRotationManager.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandscapeRotationManager.h"

@interface TFY_LandscapeRotationManager ()<LandscapeViewControllerDelegate>

@end

@implementation TFY_LandscapeRotationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)updateRotateView:(TFY_PlayerBaseView *)rotateView
           containerView:(UIView *)containerView {
    self.contentView = rotateView;
    self.containerView = containerView;
}

- (UIInterfaceOrientation)getCurrentOrientation {
    if (@available(iOS 16.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *scene = [array firstObject];
        return scene.interfaceOrientation;
    } else {
        return (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    }
}

- (void)handleDeviceOrientationChange {
    if (!self.allowOrientationRotation || self.isLockedScreen) return;
    if (!UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        return;
    }
    UIInterfaceOrientation currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;

    // Determine that if the current direction is the same as the direction you want to rotate, do nothing
    if (currentOrientation == _currentOrientation) return;
    _currentOrientation = currentOrientation;
    if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown) return;
    
    switch (currentOrientation) {
        case UIInterfaceOrientationPortrait: {
            if ([self _isSupportedPortrait]) {
                [self rotateToOrientation:UIInterfaceOrientationPortrait animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            if ([self _isSupportedLandscapeLeft]) {
                [self rotateToOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            if ([self _isSupportedLandscapeRight]) {
                [self rotateToOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            }
        }
            break;
        default: break;
    }
}

- (BOOL)isSuppprtInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return [self _isSupportedPortrait];
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return [self _isSupportedLandscapeLeft];
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return [self _isSupportedLandscapeRight];
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return [self _isSupportedPortraitUpsideDown];
    }
    return NO;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation completion:(void(^ __nullable)(void))completion {}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    [self rotateToOrientation:orientation animated:animated completion:nil];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion {
    _currentOrientation = orientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (!self.window) {
            self.window = [TFY_LandscapeWindow new];
            self.landscapeViewController.delegate = self;
            self.window.rootViewController = self.landscapeViewController;
            self.window.rotationManager = self;
        }
    }
    self.disableAnimations = !animated;
    
    if ([UIDevice currentDevice].systemVersion.doubleValue < 16.0) {
        [self interfaceOrientation:UIInterfaceOrientationUnknown completion:nil];
    }
    [self interfaceOrientation:orientation completion:completion];
}

/// is support portrait
- (BOOL)_isSupportedPortrait {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskPortrait;
}

/// is support portraitUpsideDown
- (BOOL)_isSupportedPortraitUpsideDown {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskPortraitUpsideDown;
}

/// is support landscapeLeft
- (BOOL)_isSupportedLandscapeLeft {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskLandscapeLeft;
}

/// is support landscapeRight
- (BOOL)_isSupportedLandscapeRight {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskLandscapeRight;
}

+ (InterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    if ([window isKindOfClass:TFY_LandscapeWindow.class]) {
        TFY_LandscapeRotationManager *manager = ((TFY_LandscapeWindow *)window).rotationManager;
        if (manager != nil) {
            return (InterfaceOrientationMask)[manager supportedInterfaceOrientationsForWindow:window];
        }
    }
    return InterfaceOrientationMaskUnknow;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIView *)fullScreenContainerView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


@end
