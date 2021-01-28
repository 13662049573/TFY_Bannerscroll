//
//  TFY_BannerControl.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerControl : UIPageControl
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;
@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;
@property (nonatomic, strong) TFY_BannerParam *param;
- (instancetype)initWithFrame:(CGRect)frame WithModel:(TFY_BannerParam *)param;
@end

NS_ASSUME_NONNULL_END
