//
//  TFY_VideoCollectionCell.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/23.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BaseBannerViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_VideoCollectionCell : TFY_BaseBannerViewCell
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