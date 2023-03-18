//
//  TFY_BannerImageViewCell.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/25.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFY_BannerParam.h"
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerImageViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *bannerImageView;
@property(nonatomic,strong)TFY_BannerParam *param;
@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic , copy, nullable) void (^banner_Block)(id data,NSString *bannerUrl);

@end

NS_ASSUME_NONNULL_END
