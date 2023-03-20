//
//  TFY_ITools.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define Player_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define Player_Image(file)                 [TFY_ITools imageNamed:file]

// 屏幕的宽
#define Player_ScreenWidth                 [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define Player_ScreenHeight                [[UIScreen mainScreen] bounds].size.height

#define UIColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TFY_ITools : NSObject

+ (NSString *)convertTimeSecond:(NSInteger)timeSecond;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
