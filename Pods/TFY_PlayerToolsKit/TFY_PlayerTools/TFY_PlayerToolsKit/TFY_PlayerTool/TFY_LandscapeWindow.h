//
//  TFY_LandscapeWindow.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_LandscapeViewController.h"

@class TFY_LandscapeRotationManager;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_LandscapeWindow : UIWindow

@property (nonatomic, weak) TFY_LandscapeRotationManager *rotationManager;

@end

NS_ASSUME_NONNULL_END
