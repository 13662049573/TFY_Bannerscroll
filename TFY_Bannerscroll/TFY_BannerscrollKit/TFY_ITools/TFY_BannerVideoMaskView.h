//
//  TFY_BannerVideoMaskView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TFY_PlayerState) {
    TFY_PlayerStateStart,
    TFY_PlayerStateReplay
};

typedef void(^StartButtonTapedBlock)(TFY_PlayerState state);

@interface TFY_BannerVideoMaskView : UIView

/*
 * 底部进度条的值
 */
@property (nonatomic, assign) CGFloat progressValue;

/*
 * 开始按钮的状态
 */
@property (nonatomic, assign) BOOL isStartButton;

/*
 * 开始按钮点击Block
 */
@property (nonatomic, copy) StartButtonTapedBlock buttonValue;

/**
 禁音 开关
 */
@property (nonatomic , copy, nullable) void (^broadcasting_Block)(UIButton *btn);

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue;

@end

NS_ASSUME_NONNULL_END
