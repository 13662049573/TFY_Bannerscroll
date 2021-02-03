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

/** 自定义下划线*/
typedef void (^BannerSpecialLine)(UIView * _Nonnull line);

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

NS_INLINE void kGCD_banner_async(dispatch_block_t _Nonnull block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        dispatch_async(queue, block);
    }
}
NS_INLINE void kGCD_banner_main(dispatch_block_t _Nonnull block) {
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        if ([[NSThread currentThread] isMainThread]) {
            dispatch_async(queue, block);
        }else{
            dispatch_sync(queue, block);
        }
    }
}
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
/// 获取动态图资源
NS_INLINE NSData * _Nullable kBannerGetLocalityGIFData(NSString * _Nonnull name){
    NSBundle *bundle = [NSBundle mainBundle];
    NSData *data = [NSData dataWithContentsOfFile:[bundle pathForResource:name ofType:@"gif"]];
    if (data == nil) {
        data = [NSData dataWithContentsOfFile:[bundle pathForResource:name ofType:@"GIF"]];
    }
    return data;
}

/// 等比改变图片尺寸
NS_INLINE UIImage * _Nullable kCropImage(UIImage * _Nonnull image, CGSize size){
    CGFloat scale = UIScreen.mainScreen.scale;
    float imgHeight = image.size.height;
    float imgWidth  = image.size.width;
    float maxHeight = size.width * scale;
    float maxWidth = size.height * scale;
    if (imgHeight <= maxHeight && imgWidth <= maxWidth) return image;
    float imgRatio = imgWidth/imgHeight;
    float maxRatio = maxWidth/maxHeight;
    if (imgHeight > maxHeight || imgWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            imgRatio = maxHeight / imgHeight;
            imgWidth = imgRatio * imgWidth;
            imgHeight = maxHeight;
        }else if (imgRatio > maxRatio) {
            imgRatio = maxWidth / imgWidth;
            imgWidth = maxWidth;
            imgHeight = imgRatio * imgHeight;
        }else {
            imgWidth = maxWidth;
            imgHeight = maxHeight;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, imgWidth, imgHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// 图片下载完成回调
typedef void (^_Nullable WebImageCompleted)(BannerImageType imageType, UIImage * _Nullable image, NSData * _Nullable data);



#endif /* TFY_BannerConfig_h */
