//
//  NSData+ImageType.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "NSData+ImageType.h"
#import <MobileCoreServices/MobileCoreServices.h>

// Currently Image/IO does not support WebP
#define kSDUTTypeWebP ((__bridge CFStringRef)@"public.webp")
// AVFileTypeHEIC/AVFileTypeHEIF is defined in AVFoundation via iOS 11, we use this without import AVFoundation
#define kSDUTTypeHEIC ((__bridge CFStringRef)@"public.heic")
#define kSDUTTypeHEIF ((__bridge CFStringRef)@"public.heif")

@implementation NSData (ImageType)

/**
 *  返回图像格式
 */
+ (ImageFormat)tfy_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return ImageFormatUndefined;
    }
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return ImageFormatJPEG;
        case 0x89:
            return ImageFormatPNG;
        case 0x47:
            return ImageFormatGIF;
        case 0x49:
        case 0x4D:
            return ImageFormatTIFF;
        case 0x52: {
            if (data.length >= 12) {
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return ImageFormatWebP;
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return ImageFormatHEIC;
                }
                if ([testString isEqualToString:@"ftypmif1"] || [testString isEqualToString:@"ftypmsf1"]) {
                    return ImageFormatHEIF;
                }
            }
            break;
        }
    }
    return ImageFormatUndefined;
}

/**
 *  转换SDImageFormat为UTType
 */
+ (nonnull CFStringRef)tfy_UTTypeFromSDImageFormat:(ImageFormat)format {
    CFStringRef UTType;
    switch (format) {
        case ImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case ImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        case ImageFormatGIF:
            UTType = kUTTypeGIF;
            break;
        case ImageFormatTIFF:
            UTType = kUTTypeTIFF;
            break;
        case ImageFormatWebP:
            UTType = kSDUTTypeWebP;
            break;
        case ImageFormatHEIC:
            UTType = kSDUTTypeHEIC;
            break;
        case ImageFormatHEIF:
            UTType = kSDUTTypeHEIF;
            break;
        default:
            // default is kUTTypePNG
            UTType = kUTTypePNG;
            break;
    }
    return UTType;
}

/**
 *  Convert UTTyppe to ImageFormat
 */
+ (ImageFormat)tfy_imageFormatFromUTType:(nonnull CFStringRef)uttype {
    if (!uttype) {
        return ImageFormatUndefined;
    }
    ImageFormat imageFormat;
    if (CFStringCompare(uttype, kUTTypeJPEG, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatJPEG;
    } else if (CFStringCompare(uttype, kUTTypePNG, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatPNG;
    } else if (CFStringCompare(uttype, kUTTypeGIF, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatGIF;
    } else if (CFStringCompare(uttype, kUTTypeTIFF, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatTIFF;
    } else if (CFStringCompare(uttype, kSDUTTypeWebP, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatWebP;
    } else if (CFStringCompare(uttype, kSDUTTypeHEIC, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatHEIC;
    } else if (CFStringCompare(uttype, kSDUTTypeHEIF, 0) == kCFCompareEqualTo) {
        imageFormat = ImageFormatHEIF;
    } else {
        imageFormat = ImageFormatUndefined;
    }
    return imageFormat;
}


@end
