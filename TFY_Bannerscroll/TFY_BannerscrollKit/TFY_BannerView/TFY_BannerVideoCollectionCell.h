//
//  TFY_BannerVideoCollectionCell.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BaseBannerViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerVideoCollectionCell : TFY_BaseBannerViewCell
// ******* 是否处于播放状态 ******
@property (nonatomic, assign) BOOL isPlay;
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
