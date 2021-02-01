//
//  TFY_BannerDiverseLayoutAttributes.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerDiverseLayoutAttributes : UICollectionViewLayoutAttributes
/// 圆心
@property (nonatomic, assign) CGPoint anchorPoint;
/// 角度
@property (nonatomic, assign) CGFloat angle;
/// 竖直/水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

NS_ASSUME_NONNULL_END
