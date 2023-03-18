//
//  TFY_SpeedLoadingView.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_LoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SpeedLoadingView : UIView

@property (nonatomic, strong) TFY_LoadingView *loadingView;

@property (nonatomic, strong) UILabel *speedTextLabel;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
