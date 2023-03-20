//
//  TFY_LandscapeRotationManager_iOS15.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandscapeRotationManager_iOS15.h"
#import "TFY_LandscapeViewController_iOS15.h"

@interface TFY_LandscapeRotationManager_iOS15 (){
    void(^_rotateCompleted)(void);
}
@property (nonatomic, strong, readonly) TFY_LandscapeViewController_iOS15 *landscapeViewController;
/// Force Rotaion, default NO.
@property (nonatomic, assign) BOOL forceRotaion;

@end

@implementation TFY_LandscapeRotationManager_iOS15
@synthesize landscapeViewController = _landscapeViewController;

- (TFY_LandscapeViewController_iOS15 *)landscapeViewController {
    if (!_landscapeViewController) {
        _landscapeViewController = [[TFY_LandscapeViewController_iOS15 alloc] init];
    }
    return _landscapeViewController;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation completion:(void(^ __nullable)(void))completion {
    [super interfaceOrientation:orientation completion:completion];
    _rotateCompleted = completion;
    self.forceRotaion = YES;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [UIViewController attemptRotationToDeviceOrientation];
}

- (UIView *)fullScreenContainerView {
    return self.landscapeViewController.playerSuperview;
}

- (void)rotationBegin {
    if (self.window.isHidden) {
        self.window.hidden = NO;
        [self.window makeKeyAndVisible];
    }
    [self.window.rootViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)rotationEnd {
    if (!self.window.isHidden && !UIInterfaceOrientationIsLandscape(self.currentOrientation)) {
        self.window.hidden = YES;
        [self.containerView.window makeKeyAndVisible];
    }
    self.disableAnimations = NO;
    if (_rotateCompleted) {
        _rotateCompleted();
        _rotateCompleted = nil;
    }
}

- (BOOL)allowsRotation {
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        UIInterfaceOrientation toOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
        if (![self isSuppprtInterfaceOrientation:toOrientation]) {
            return NO;
        }
    }
    if (self.forceRotaion) { return YES; }
    if (!self.activeDeviceObserver) { return NO; }
    if (self.allowOrientationRotation && !self.isLockedScreen) { return YES; }
    return NO;
}

#pragma mark - TFYLandscapeViewControllerDelegate

- (BOOL)ls_shouldAutorotate {
    if ([self allowsRotation]) {
        [self rotationBegin];
        return YES;
    }
    return NO;
}

- (void)rotationFullscreenViewController:(TFY_LandscapeViewController *)viewController viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UIInterfaceOrientation toOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    if (![self isSuppprtInterfaceOrientation:toOrientation]) { return; }
    self.currentOrientation = toOrientation;
    UIView *playerSuperview = self.landscapeViewController.playerSuperview;
    if (UIInterfaceOrientationIsLandscape(toOrientation) && self.contentView.superview != playerSuperview) {
        CGRect targetRect = [self.containerView convertRect:self.containerView.bounds toView:self.containerView.window];
        playerSuperview.frame = targetRect;
        self.contentView.frame = playerSuperview.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [playerSuperview addSubview:self.contentView];
        [self.contentView layoutIfNeeded];
    }
    
    if (self.orientationWillChange) self.orientationWillChange(toOrientation);
    if (self.disableAnimations) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (UIInterfaceOrientationIsLandscape(toOrientation)) {
            playerSuperview.frame = CGRectMake(0, 0, size.width, size.height);
        } else {
            playerSuperview.frame = [self.containerView convertRect:self.containerView.bounds toView:self.containerView.window];
        }
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.disableAnimations) {
            [CATransaction commit];
        }
        self.forceRotaion = NO;
        if (toOrientation == UIInterfaceOrientationPortrait) {
            UIView *snapshot = [self.contentView snapshotViewAfterScreenUpdates:NO];
            snapshot.frame = self.containerView.bounds;
            snapshot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.containerView addSubview:snapshot];
            [UIView animateWithDuration:0.0 animations:^{} completion:^(BOOL finished) {
                self.contentView.frame = self.containerView.bounds;
                self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [self.containerView addSubview:self.contentView];
                [self.contentView layoutIfNeeded];
                [snapshot removeFromSuperview];
                [self rotationEnd];
                if (self.orientationDidChanged) self.orientationDidChanged(toOrientation);
            }];
        } else {
            self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.contentView.frame = self.window.bounds;
            [self.contentView layoutIfNeeded];
            [self rotationEnd];
            if (self.orientationDidChanged) self.orientationDidChanged(toOrientation);
        }
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
