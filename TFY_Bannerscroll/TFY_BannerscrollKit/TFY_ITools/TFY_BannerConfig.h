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
#import <SDWebImage/SDWebImage.h>

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
typedef UICollectionViewCell* _Nonnull (^BannerCellCallBlock)(NSIndexPath * _Nonnull indexPath,UICollectionView* _Nonnull collectionView,id _Nonnull model,UIImageView* _Nonnull bgImageView,NSArray* _Nonnull dataArr);

/** 点击*/
typedef void (^BannerClickBlock)(id _Nonnull anyID,NSInteger index);

/** 自定义pageControl*/
typedef void (^BannerPageControl)(TFY_BannerPageControl* _Nonnull pageControl);

/** 点击 ,可获取居中cell*/
typedef void (^BannerCenterClickBlock)(id _Nonnull anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* _Nonnull cell);

/** 滚动结束*/
typedef void (^BannerScrollEndBlock)(id _Nonnull anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* _Nonnull cell);

/** 滚动*/
typedef void (^BannerScrollBlock)(CGPoint point);

/**开始滚动**/
typedef void (^BannerscrollViewWillBeginDraggingBlock)(UIScrollView *_Nonnull scrollView);

/** 自定义下划线*/
typedef void (^BannerSpecialLine)(UIView * _Nonnull line);

/**
  卡片类型
*/
typedef enum {
    CardtypeCommon = 0,//普通模式
    CardtypeFallen = 1,//重叠卡片
}Cardtype;


/**cell动画的位置*/
typedef enum :NSInteger{
    BannerCellPositionCenter = 0,  //居中 默认
    BannerCellPositionBottom = 1,  //置底
    BannerCellPositionTop    = 2,  //顶部
}BannerCellPosition;

/*
 *特殊样式
 */
typedef enum :NSInteger{
    SpecialStyleLine       = 1, //下划线
    SpecialStyleFirstScale = 2, //首个变大效果
}SpecialStyle;

/**返回图片类型*/
typedef NS_ENUM(NSInteger, BannerImageType) {
    BannerImageTypeUnknown = 0, /// 未知
    BannerImageTypeJpeg    = 1, /// jpg
    BannerImageTypePng     = 2, /// png
    BannerImageTypeGif     = 3, /// gif
    BannerImageTypeTiff    = 4, /// tiff
    BannerImageTypeWebp    = 5, /// webp
};

/// 图片链接类型
typedef NS_ENUM(NSInteger, BannerImageURLType) {
    BannerImageURLTypeMixture = 0,/// 混合
    BannerImageURLTypeCommon,     /// png和jpg
    BannerImageURLTypeGif,        /// gif
    BannerImageURLTypeWebp,       /// webp
};

/// 判断是网络图片还是本地
NS_INLINE bool kBannerLocality(NSString * _Nonnull urlString){
    return ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) ? false : true;
}
/// 判断该字符串是不是一个有效的URL
NS_INLINE bool kBannerValid(NSString * _Nonnull urlString){
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:urlString];
}

/// 根据DATA判断图片类型
NS_INLINE BannerImageType kBannerContentType(NSData * _Nonnull data){
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return BannerImageTypeJpeg;
        case 0x89:
            return BannerImageTypePng;
        case 0x47:
            return BannerImageTypeGif;
        case 0x49:
        case 0x4D:
            return BannerImageTypeTiff;
        case 0x52:
            if ([data length] < 12) return BannerImageTypeUnknown;
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) return BannerImageTypeWebp;
            return BannerImageTypeUnknown;
    }
    return BannerImageTypeUnknown;
}

#endif /* TFY_BannerConfig_h */
