//
//  TFY_BaseBannerViewCell.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/23.
//  Copyright © 2023 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BaseBannerViewCell : UICollectionViewCell
@property(nonatomic,strong)TFY_BannerParam *param;
@property (nonatomic, strong) NSString *bannerUrl;
- (void)baseBannerViewLayout;
@property (nonatomic , copy, nullable) void (^banner_Block)(id data,NSString *bannerUrl);
@end

NS_ASSUME_NONNULL_END
