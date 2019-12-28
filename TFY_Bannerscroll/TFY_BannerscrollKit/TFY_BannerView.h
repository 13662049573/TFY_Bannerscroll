//
//  TFY_BannerView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerView : UIView
/**背景图*/
@property(strong,nonatomic)UIImageView *bgImgView;

/**调用方法*/
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param withView:(UIView*)parentView;
/**调用方法*/
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param;
/**更新UI*/
- (void)updateUI;

@end

@interface Collectioncell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)TFY_BannerParam *param;
@end

@interface CollectionTextCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)TFY_BannerParam *param;
@end

NS_ASSUME_NONNULL_END
