//
//  TFY_LandscapeWindow.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandscapeWindow.h"
#import "TFY_LandscapeRotationManager_iOS15.h"

@implementation TFY_LandscapeWindow
@dynamic rootViewController;

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor {}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar - 1;
        if (@available(iOS 13.0, *)) {
            if (self.windowScene == nil) {
                self.windowScene = UIApplication.sharedApplication.keyWindow.windowScene;
            }
            if (@available(iOS 9.0, *)) {
                [self.rootViewController loadViewIfNeeded];
            } else {
                [self.rootViewController view];
            }
        }
        self.hidden = YES;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *_Nullable)event {
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGRect bounds;
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        UIView *superview = self;
        if (@available(iOS 13.0, *)) {
            superview = self.subviews.firstObject;
        }
        [UIView performWithoutAnimation:^{
            for (UIView *view in superview.subviews) {
                if (view != self.rootViewController.view && [view isMemberOfClass:UIView.class]) {
                    view.backgroundColor = UIColor.clearColor;
                    for (UIView *subview in view.subviews) {
                        subview.backgroundColor = UIColor.clearColor;
                    }
                }
            }
        }];
    }
    bounds = self.bounds;
    self.rootViewController.view.frame = bounds;
}


@end
