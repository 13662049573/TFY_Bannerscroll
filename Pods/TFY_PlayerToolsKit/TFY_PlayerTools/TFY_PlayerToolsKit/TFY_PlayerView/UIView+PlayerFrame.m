//
//  UIView+PlayerFrame.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "UIView+PlayerFrame.h"

@implementation UIView (PlayerFrame)

- (CGFloat)player_x {
    return self.frame.origin.x;
}

-(void)setPlayer_x:(CGFloat)player_x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = player_x;
    self.frame = newFrame;
}

-(CGFloat)player_y{
    return self.frame.origin.y;
}

- (void)setPlayer_y:(CGFloat)player_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = player_y;
    self.frame        = newFrame;
}

- (CGFloat)player_width{
    return CGRectGetWidth(self.bounds);
}

-(void)setPlayer_width:(CGFloat)player_width{
    CGRect newFrame     = self.frame;
    newFrame.size.width = player_width;
    self.frame          = newFrame;
}

-(CGFloat)player_height{
    return CGRectGetHeight(self.bounds);
}

-(void)setPlayer_height:(CGFloat)player_height{
    CGRect newFrame      = self.frame;
    newFrame.size.height = player_height;
    self.frame           = newFrame;
}

-(CGFloat)player_top{
    return self.frame.origin.y;
}

-(void)setPlayer_top:(CGFloat)player_top{
    CGRect newFrame   = self.frame;
    newFrame.origin.y = player_top;
    self.frame        = newFrame;
}

-(CGFloat)player_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setPlayer_bottom:(CGFloat)player_bottom{
    CGRect newFrame   = self.frame;
    newFrame.origin.y = player_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

-(CGFloat)player_left{
    return self.frame.origin.x;
}

-(void)setPlayer_left:(CGFloat)player_left{
    CGRect newFrame   = self.frame;
    newFrame.origin.x = player_left;
    self.frame        = newFrame;
}

-(CGFloat)player_right{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setPlayer_right:(CGFloat)player_right{
    CGRect newFrame   = self.frame;
    newFrame.origin.x = player_right - self.frame.size.width;
    self.frame        = newFrame;
}

-(CGFloat)player_centerX{
    return self.center.x;
}

-(void)setPlayer_centerX:(CGFloat)player_centerX{
    CGPoint newCenter = self.center;
    newCenter.x       = player_centerX;
    self.center       = newCenter;
}

-(CGFloat)player_centerY{
    return self.center.y;
}

-(void)setPlayer_centerY:(CGFloat)player_centerY{
    CGPoint newCenter = self.center;
    newCenter.y       = player_centerY;
    self.center       = newCenter;
}

-(CGPoint)player_origin{
    return self.frame.origin;
}

-(void)setPlayer_origin:(CGPoint)player_origin{
    CGRect newFrame = self.frame;
    newFrame.origin = player_origin;
    self.frame      = newFrame;
}

-(CGSize)player_size{
    return self.frame.size;
}

-(void)setPlayer_size:(CGSize)player_size{
    CGRect newFrame = self.frame;
    newFrame.size   = player_size;
    self.frame      = newFrame;
}
@end
