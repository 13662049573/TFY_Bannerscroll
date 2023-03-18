//
//  UIView+PlayerFrame.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PlayerFrame)

@property (nonatomic) CGFloat player_x;
@property (nonatomic) CGFloat player_y;
@property (nonatomic) CGFloat player_width;
@property (nonatomic) CGFloat player_height;

@property (nonatomic) CGFloat player_top;
@property (nonatomic) CGFloat player_bottom;
@property (nonatomic) CGFloat player_left;
@property (nonatomic) CGFloat player_right;

@property (nonatomic) CGFloat player_centerX;
@property (nonatomic) CGFloat player_centerY;

@property (nonatomic) CGPoint player_origin;
@property (nonatomic) CGSize  player_size;


@end

NS_ASSUME_NONNULL_END
