//
//  TFY_BannerConfig.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#ifndef TFY_BannerConfig_h
#define TFY_BannerConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageView+Bannerscroll.h"
#import "TFY_BannerPageControl.h"

#define BannerWitdh  [UIScreen mainScreen].bounds.size.width
#define BannerHeight [UIScreen mainScreen].bounds.size.height

#define BannerWSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define BannerWeakSelf(obj) __weak typeof(obj) weakObject = obj;
#define BannerStrongSelf(obj) __strong typeof(obj) strongObject = weakObject;

#define BannerColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**需要传入的值*/
#define TFY_BannerPropStatementAndPropSetFuncStatement(propertyModifier,propertyPointerType,propertyName) \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;\
- (TFY_BannerParam * (^) (propertyPointerType propertyName))propertyName##Set;
/**回调数据*/
#define TFY_BannerPropSetFuncImplementation(propertyPointerType, propertyName)  \
- (TFY_BannerParam * (^) (propertyPointerType propertyName))propertyName##Set{ \
    BannerWSelf(myself);\
    return ^(propertyPointerType propertyName){\
        myself.propertyName = propertyName;\
        return myself;\
    };\
}

/** cell的block*/
typedef UICollectionViewCell* (^BannerCellCallBlock)(NSIndexPath *indexPath,UICollectionView* collectionView,id model,UIImageView* bgImageView,NSArray*dataArr);

/** 点击*/
typedef void (^BannerClickBlock)(id anyID,NSInteger index);

/** 自定义pageControl*/
typedef void (^BannerPageControl)(TFY_BannerPageControl* pageControl);

/** 点击 ,可获取居中cell*/
typedef void (^BannerCenterClickBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/** 滚动结束*/
typedef void (^BannerScrollEndBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/**cell动画的位置*/
typedef enum :NSInteger{
    BannerCellPositionCenter      = 0,             //居中 默认
    BannerCellPositionBottom      = 1,             //置底
}BannerCellPosition;

#endif /* TFY_BannerConfig_h */
