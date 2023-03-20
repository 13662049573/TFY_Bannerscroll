//
//  TFY_PortraitViewController.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_PortraitViewController.h"
#import "TFY_PersentInteractiveTransition.h"
#import "TFY_PresentTransition.h"

@interface TFY_PortraitViewController ()<UIViewControllerTransitioningDelegate,PortraitOrientationDelegate>
@property (nonatomic, strong) TFY_PresentTransition *transition;
@property (nonatomic, strong) TFY_PersentInteractiveTransition *interactiveTransition;
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
@end

@implementation TFY_PortraitViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        _statusBarStyle = UIStatusBarStyleLightContent;
        _statusBarAnimation = UIStatusBarAnimationSlide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.fullScreenAnimation) {
        if (self.orientationWillChange) {
            self.orientationWillChange(YES);
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.fullScreenAnimation) {
        self.view.alpha = 1;
        [self.view addSubview:self.contentView];
        self.contentView.frame = [self contentFullScreenRect];
        if (self.orientationDidChanged) {
            self.orientationDidChanged(YES);
        }
    }
    self.fullScreen = YES;
    [self.interactiveTransition updateContentView:self.contentView
                                    containerView:self.containerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.fullScreenAnimation) {
        if (self.orientationWillChange) {
            self.orientationWillChange(NO);
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fullScreen = NO;
    if (!self.fullScreenAnimation) {
        [self.containerView addSubview:self.contentView];
        self.contentView.frame = self.containerView.bounds;
        if (self.orientationDidChanged) {
            self.orientationDidChanged(NO);
        }
    }
}

#pragma mark - transition delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    [self.transition transitionWithTransitionType:PresentTransitionTypePresent contentView:self.contentView containerView:self.containerView];
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self.transition transitionWithTransitionType:PresentTransitionTypeDismiss contentView:self.contentView containerView:self.containerView];
    return self.transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}


- (BOOL)shouldAutorotate {
    return NO;
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - PortraitOrientationDelegate

- (void)tfy_orientationWillChange:(BOOL)isFullScreen {
    if (self.orientationWillChange) {
        self.orientationWillChange(isFullScreen);
    }
}

- (void)tfy_orientationDidChanged:(BOOL)isFullScreen {
    if (self.orientationDidChanged) {
        self.orientationDidChanged(isFullScreen);
    }
}

- (void)tfy_interationState:(BOOL)isDragging {
    self.transition.interation = isDragging;
}

#pragma mark - getter

- (TFY_PresentTransition *)transition {
    if (!_transition) {
        _transition = [[TFY_PresentTransition alloc] init];
        _transition.contentFullScreenRect = [self contentFullScreenRect];
        _transition.delagate = self;
    }
    return _transition;
}

- (TFY_PersentInteractiveTransition *)interactiveTransition {
    if (!_interactiveTransition) {
        _interactiveTransition = [[TFY_PersentInteractiveTransition alloc] init];
        _interactiveTransition.contentFullScreenRect = [self contentFullScreenRect];
        _interactiveTransition.viewController = self;
        _interactiveTransition.delagate = self;
    }
    return _interactiveTransition;;
}

- (void)setDisablePortraitGestureTypes:(DisablePortraitGestureTypes)disablePortraitGestureTypes {
    _disablePortraitGestureTypes = disablePortraitGestureTypes;
    self.interactiveTransition.disablePortraitGestureTypes = disablePortraitGestureTypes;
}

- (void)setPresentationSize:(CGSize)presentationSize {
    _presentationSize = presentationSize;
    self.transition.contentFullScreenRect = [self contentFullScreenRect];
    self.interactiveTransition.contentFullScreenRect = [self contentFullScreenRect];
    if (!self.fullScreenAnimation && self.isFullScreen) {
        self.contentView.frame = [self contentFullScreenRect];
    }
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    self.transition.fullScreen = fullScreen;
}

- (void)setFullScreenAnimation:(BOOL)fullScreenAnimation {
    _fullScreenAnimation = fullScreenAnimation;
    self.interactiveTransition.fullScreenAnimation = fullScreenAnimation;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.transition.duration = duration;
}

- (CGRect)contentFullScreenRect {
    CGFloat videoWidth = self.presentationSize.width;
    CGFloat videoHeight = self.presentationSize.height;
    if (videoHeight == 0) {
        return CGRectZero;
    }
    CGSize fullScreenScaleSize = CGSizeZero;
    CGFloat screenScale = TFY_PLAYER_ScreenW/TFY_PLAYER_ScreenH;
    CGFloat videoScale = videoWidth/videoHeight;
    if (screenScale > videoScale) {
        CGFloat height = TFY_PLAYER_ScreenH;
        CGFloat width = height * videoScale;
        fullScreenScaleSize = CGSizeMake(width, height);
    } else {
        CGFloat width = TFY_PLAYER_ScreenW;
        CGFloat height = (CGFloat)(width / videoScale);
        fullScreenScaleSize = CGSizeMake(width, height);
    }
    
    videoWidth = fullScreenScaleSize.width;
    videoHeight = fullScreenScaleSize.height;
    CGRect rect = CGRectMake((TFY_PLAYER_ScreenW - videoWidth) / 2.0, (TFY_PLAYER_ScreenH - videoHeight) / 2.0, videoWidth, videoHeight);
    return rect;
}


@end
