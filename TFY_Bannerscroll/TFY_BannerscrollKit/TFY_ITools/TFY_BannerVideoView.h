//
//  TFY_BannerVideoView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2022/3/22.
//  Copyright © 2022 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerVideoView : UIView

// ******* 是否处于播放状态 ******
@property (nonatomic, assign) BOOL isPlay;
// ******* 视频播放地址 ******
@property (nonatomic, strong) NSString *videoUrl;

/*
 * 开始播放
 */
- (void)start;

/*
 * 暂停播放
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
