//
//  TFY_BannerOverLayout.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerOverLayout : UICollectionViewFlowLayout
@property(nonatomic,strong)TFY_BannerParam *param;
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param;
@end

NS_ASSUME_NONNULL_END
