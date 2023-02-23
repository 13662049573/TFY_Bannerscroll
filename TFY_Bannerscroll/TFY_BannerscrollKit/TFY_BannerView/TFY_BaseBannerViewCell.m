//
//  TFY_BaseBannerViewCell.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2023/2/23.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_BaseBannerViewCell.h"

@implementation TFY_BaseBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseBannerViewLayout];
    }
    return self;
}

- (void)baseBannerViewLayout{}

@end
