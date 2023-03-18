//
//  UIViewController+PlayerRotation.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TFY_LandscapeWindow.h"
#import "TFY_LandscapeRotationManager.h"

API_AVAILABLE(ios(13.0)) @implementation UIViewController (PlayerRotation)

/// Hook
- (void)tfy_setContentOverlayInsets:(UIEdgeInsets)insets andLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    UIWindow *otherWindow = self.view.window;
    if ([keyWindow isKindOfClass:TFY_LandscapeWindow.class] && otherWindow != nil) {
        TFY_LandscapeRotationManager *manager = ((TFY_LandscapeWindow *)keyWindow).rotationManager;
        UIWindow *superviewWindow = manager.containerView.window;
        if (superviewWindow != otherWindow) {
            [self tfy_setContentOverlayInsets:insets andLeftMargin:leftMargin rightMargin:rightMargin];
        }
    } else {
        [self tfy_setContentOverlayInsets:insets andLeftMargin:leftMargin rightMargin:rightMargin];
    }
}

@end

@implementation UITabBarController (PlayerRotation)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(selectedIndex)
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"tfy_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            [self hookClass:self.class originalSelector:originalSelector swizzledSelector:swizzledSelector];
        }
        
        double systemVersion = [UIDevice currentDevice].systemVersion.doubleValue;
        if (systemVersion >= 13.0 && systemVersion < 16.0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            /// _setContentOverlayInsets:andLeftMargin:rightMargin:
            NSData *data = [NSData.alloc initWithBase64EncodedString:@"X3NldENvbnRlbnRPdmVybGF5SW5zZXRzOmFuZExlZnRNYXJnaW46cmlnaHRNYXJnaW46" options:kNilOptions];
            NSString *method = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SEL originalSelector = NSSelectorFromString(method);
#pragma clang diagnostic pop
            SEL swizzledSelector = @selector(tfy_setContentOverlayInsets:andLeftMargin:rightMargin:);
            
            [self hookClass:UIViewController.class originalSelector:originalSelector swizzledSelector:swizzledSelector];
        }
    });
}

+ (void)hookClass:(Class)cls originalSelector:(SEL)orlSelector swizzledSelector:(SEL)swzdSelector {
    Method originalMethod = class_getInstanceMethod(cls, orlSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swzdSelector);
    if (class_addMethod(self, orlSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swzdSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSInteger)tfy_selectedIndex {
    NSInteger index = [self tfy_selectedIndex];
    if (index > self.viewControllers.count) return 0;
    return index;
}

/**
 * If the root view of the window is a UINavigationController, you call this Category first, and then UIViewController called.
 * All you need to do is revisit the following three methods on a page that supports directions other than portrait.
 */

// Whether automatic screen rotation is supported.
- (BOOL)shouldAutorotate {
    return [[self viewControllerRotation] shouldAutorotate];
}

// Which screen directions are supported.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self viewControllerRotation] supportedInterfaceOrientations];
}

// The default screen direction (the current ViewController must be represented by a modal UIViewController (which is not valid with modal navigation) to call this method).
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self viewControllerRotation] preferredInterfaceOrientationForPresentation];
}

//  Return ViewController which decide rotation，if selected in UITabBarController is UINavigationController,return topViewController
- (UIViewController *)viewControllerRotation {
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return nav.topViewController;
    } else {
        return vc;
    }
}


@end

@implementation UINavigationController (PlayerRotation)

/**
 * If the root view of the window is a UINavigationController, you call this Category first, and then UIViewController called.
 * All you need to do is revisit the following three methods on a page that supports directions other than portrait.
 */

// Whether automatic screen rotation is supported
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

// Which screen directions are supported
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

// The default screen direction (the current ViewController must be represented by a modal UIViewController (which is not valid with modal navigation) to call this method).
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end
