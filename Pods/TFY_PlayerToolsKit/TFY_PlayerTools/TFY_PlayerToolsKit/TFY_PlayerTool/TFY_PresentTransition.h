//
//  TFY_PresentTransition.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_OrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PresentTransitionType) {
    PresentTransitionTypePresent,
    PresentTransitionTypeDismiss,
};

@interface TFY_PresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<PortraitOrientationDelegate> delagate;

@property (nonatomic, assign) CGRect contentFullScreenRect;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, assign) BOOL interation;

@property (nonatomic, assign) NSTimeInterval duration;

- (void)transitionWithTransitionType:(PresentTransitionType)type
                         contentView:(UIView *)contentView
                       containerView:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END
