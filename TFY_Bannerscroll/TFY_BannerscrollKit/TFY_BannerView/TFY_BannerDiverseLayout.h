//
//  TFY_BannerDiverseLayout.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerDiverseLayout : UICollectionViewFlowLayout

@property(nonatomic,strong)TFY_BannerParam *param;
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param;

@end

NS_ASSUME_NONNULL_END
