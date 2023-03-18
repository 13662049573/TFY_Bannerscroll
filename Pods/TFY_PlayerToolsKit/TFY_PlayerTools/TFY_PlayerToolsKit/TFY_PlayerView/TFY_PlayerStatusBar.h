//
//  TFY_PlayerStatusBar.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerStatusBar : UIView

/// 刷新时间间隔，默认3秒
@property (nonatomic, assign) NSTimeInterval refreshTime;

- (void)startTimer;

- (void)destoryTimer;

@end

NS_ASSUME_NONNULL_END
