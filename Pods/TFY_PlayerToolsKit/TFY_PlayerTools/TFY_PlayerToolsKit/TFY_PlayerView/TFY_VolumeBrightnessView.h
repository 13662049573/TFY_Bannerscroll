//
//  TFY_VolumeBrightnessView.h
//  TFY_PlayerTools
//
//  Created by 田风有 on 2020/7/17.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VolumeBrightnessType) {
    VolumeBrightnessTypeVolume,       // volume
    VolumeBrightnessTypeumeBrightness // brightness
};

@interface TFY_VolumeBrightnessView : UIView

@property (nonatomic, assign, readonly) VolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong, readonly) UIProgressView *progressView;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType;

/// 添加系统音量view
- (void)addSystemVolumeView;

/// 移除系统音量view
- (void)removeSystemVolumeView;

@end

NS_ASSUME_NONNULL_END
