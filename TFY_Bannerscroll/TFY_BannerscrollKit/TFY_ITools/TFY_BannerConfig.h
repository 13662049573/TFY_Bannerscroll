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
#import "TFY_BannerPageControl.h"
#import "TFY_BannerImageView+webURL.h"
#import "UIImageView+webURL.h"

#define BannerWitdh  [UIScreen mainScreen].bounds.size.width
#define BannerHeight [UIScreen mainScreen].bounds.size.height

#define BannerWSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define BannerWeakSelf(obj) __weak typeof(obj) weakObject = obj;
#define BannerStrongSelf(obj) __strong typeof(obj) strongObject = weakObject;

#define BannerColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**需要传入的值*/
#define TFY_BannerSetFuncStatement(className,propertyModifier,propertyPointerType,propertyName) \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;\
- (className * (^) (propertyPointerType propertyName))propertyName##Set;
/**回调数据*/
#define TFY_BannerSetFuncImplementation(className,propertyPointerType, propertyName)  \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{ \
    BannerWSelf(myself);\
    return ^(propertyPointerType propertyName){\
        myself.propertyName = propertyName;\
        return myself;\
    };\
}

/** cell的block*/
typedef UICollectionViewCell* (^BannerCellCallBlock)(NSIndexPath *indexPath,UICollectionView* collectionView,id model,TFY_BannerImageView* bgImageView,NSArray*dataArr);

/** 点击*/
typedef void (^BannerClickBlock)(id anyID,NSInteger index);

/** 自定义pageControl*/
typedef void (^BannerPageControl)(TFY_BannerPageControl* pageControl);

/** 点击 ,可获取居中cell*/
typedef void (^BannerCenterClickBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/** 滚动结束*/
typedef void (^BannerScrollEndBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/** 滚动*/
typedef void (^BannerScrollBlock)(CGPoint point);

/** 自定义下划线*/
typedef void (^BannerSpecialLine)(UIView *line);

/**
  卡片类型
*/
typedef enum {
    CardtypeCommon = 0,//普通模式
    CardtypeFallen = 1,//重叠卡片
    CardtypeMultifunction = 2, //多功能卡片
}Cardtype;


/**cell动画的位置*/
typedef enum :NSInteger{
    BannerCellPositionCenter = 0,  //居中 默认
    BannerCellPositionBottom = 1,  //置底
    BannerCellPositionTop    = 2,  //顶部
}BannerCellPosition;

/**定时器选择 -- */
typedef enum :NSInteger{
    BannTimeTypeGCD = 0,  //----  GCD
    BannTimeTypeTime = 1, //----  TIME
}BannTimeType;

/*
 *特殊样式
 */
typedef enum :NSInteger{
    SpecialStyleLine       = 1, //下划线
    SpecialStyleFirstScale = 2, //首个变大效果
}SpecialStyle;

/**
图片滚动的样式  这里只属于第三模块
*/
typedef enum {
    DiverseImageScrollNone,
    DiverseImageScrollCardOne,
    DiverseImageScrollCardTwo,
    DiverseImageScrollCardThird,
    DiverseImageScrollCardFour,
    DiverseImageScrollCardFive,
    DiverseImageScrollCardSix,
    DiverseImageScrollCardSeven,
}DiverseImageScrollType;

#endif /* TFY_BannerConfig_h */
