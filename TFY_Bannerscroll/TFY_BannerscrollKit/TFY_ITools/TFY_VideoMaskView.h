//
//  TFY_VideoMaskView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2022/3/22.
//  Copyright © 2022 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFY_PlayerState) {
    TFY_PlayerStateStart,
    TFY_PlayerStateReplay
};

typedef void(^StartButtonTapedBlock)(TFY_PlayerState state);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_VideoMaskView : UIView
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
