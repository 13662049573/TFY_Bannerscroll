//
//  NSData+ImageType.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ImageFormat) {
    ImageFormatUndefined = -1,
    ImageFormatJPEG = 0,
    ImageFormatPNG,
    ImageFormatGIF,
    ImageFormatTIFF,
    ImageFormatWebP,
    ImageFormatHEIC,
    ImageFormatHEIF
};

@interface NSData (ImageType)

/**
 *  返回图像格式
 */
+ (ImageFormat)tfy_imageFormatForImageData:(nullable NSData *)data;

/**
 *  转换SDImageFormat为UTType
 */
+ (nonnull CFStringRef)tfy_UTTypeFromSDImageFormat:(ImageFormat)format;

/**
 *  Convert UTTyppe to ImageFormat
 */
+ (ImageFormat)tfy_imageFormatFromUTType:(nonnull CFStringRef)uttype;

@end

NS_ASSUME_NONNULL_END
