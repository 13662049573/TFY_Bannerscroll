//
//  TFY_PersentInteractiveTransition.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_OrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PersentInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) id<PortraitOrientationDelegate> delagate;

@property (nonatomic, assign) BOOL interation;

/// default is DisablePortraitGestureTypesNone.
@property (nonatomic, assign) DisablePortraitGestureTypes disablePortraitGestureTypes;

@property (nonatomic, assign) BOOL fullScreenAnimation;

@property (nonatomic, assign) CGRect contentFullScreenRect;

@property (nonatomic, weak) UIViewController *viewController;

- (void)updateContentView:(UIView *)contenView
            containerView:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END
