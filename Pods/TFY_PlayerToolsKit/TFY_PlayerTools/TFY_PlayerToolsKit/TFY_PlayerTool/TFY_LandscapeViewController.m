//
//  TFY_LandscapeViewController.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandscapeViewController.h"

@interface TFY_LandscapeViewController ()

@end

@implementation TFY_LandscapeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusBarStyle = UIStatusBarStyleLightContent;
        _statusBarAnimation = UIStatusBarAnimationSlide;
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if ([self.delegate respondsToSelector:@selector(rotationFullscreenViewController:viewWillTransitionToSize:withTransitionCoordinator:)]) {
        [self.delegate rotationFullscreenViewController:self viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.statusBarAnimation;
}

@end
