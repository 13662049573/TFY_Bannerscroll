//
//  TFY_BannerDiverseLayoutAttributes.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerDiverseLayoutAttributes.h"

@implementation TFY_BannerDiverseLayoutAttributes

- (instancetype)init{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.angle = 0;
    }
    return self;
}

// 由于布局属性对象可能会被collectionView复制，因此布局属性对象应该遵循NSCoping协议，并实现copyWithZone:方法，否则我们获取的自定义属性会一直是空值。
- (id)copyWithZone:(NSZone *)zone{
    TFY_BannerDiverseLayoutAttributes *attribute = [super copyWithZone:zone];
    attribute.anchorPoint = self.anchorPoint;
    attribute.angle = self.angle;
    attribute.scrollDirection = self.scrollDirection;
    return attribute;
}

@end
