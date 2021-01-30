//
//  TFY_BannerPageControl.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/27.
//  Copyright © 2021 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 页码对齐方式，默认PageControlAlignmentDefault
typedef NS_ENUM(NSInteger, PageControlAlignment) {
    PageControlAlignmentDefault = 0,
    PageControlAlignmentLeft = 1,
    PageControlAlignmentRight = 2,
    PageControlAlignmentCenter = PageControlAlignmentDefault,
    PageControlAlignmentEqual = 4,
    /// PageControlTypeLine时有效
    PageControlAlignmentBottom = 5,
};

/// 页码样式，默认PageControlTypeSquare
typedef NS_ENUM(NSInteger, PageControlType) {
    PageControlTypeSquare = 0,//正方形
    PageControlTypeCircle = 1,//圆点
    PageControlTypeLine = 2,//线条型
    PageControlTypeImage = 3,//图片设置，需要自己定义
};


NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerPageControl : UIView

- (instancetype)initWithFrame:(CGRect)frame;

/// 页码数量，默认0
@property (nonatomic, assign) NSInteger numberOfPages;
/// 当前页码，默认0，取值范围是0~numberOfPages-1
@property (nonatomic, assign) NSInteger currentPage;

/// 只有一页时是否隐藏页码，默认NO
@property (nonatomic, assign) BOOL hidesForSinglePage;

/// 页码非高亮颜色，默认灰色
@property(nonatomic, strong) UIColor *pageIndicatorColor;
/// 页码高亮时颜色，默认黑色
@property(nonatomic, strong) UIColor *currentPageIndicatorColor;

/// 页码非高亮图标，默认无
@property(nonatomic, strong) UIImage *pageIndicatorImage;
/// 页码高亮时图标，默认无
@property(nonatomic, strong) UIImage *currentPageIndicatorImage;

/// 页码样式，默认PageControlTypeSquare
@property(nonatomic, assign) PageControlType pageControlType;
/// 页码对齐方式，默认PageControlAlignmentDefault
@property(nonatomic, assign) PageControlAlignment pageControlAlignment;

/// 页码高亮时放大倍数，默认1.0，取值范围1.0~2.0
@property(nonatomic, assign) CGFloat transformScale;

/// 页码序号是否显示，默认NO
@property(nonatomic, assign) BOOL showPageNumber;
/// 页码序号非高亮时颜色，默认灰色
@property(nonatomic, strong) UIColor *pageNumberColor;
/// 页码序号高亮时颜色，默认黑色
@property(nonatomic, strong) UIColor *currentPageNumberColor;
/// 页码序号非高亮时字体大小，默认6.0
@property(nonatomic, strong) UIFont *pageNumberFont;
/// 页码序号高亮时字体大小，默认6.0
@property(nonatomic, strong) UIFont *currentPageNumberFont;

/// 页码间距，默认6.0
@property(nonatomic, assign) CGFloat pageMargin;
/// 没有选中的页码大小-高，默认6.0
@property(nonatomic, assign) CGFloat pageSizeHeight;
/// 没有选中页码大小-宽，默认6.0
@property(nonatomic, assign) CGFloat pageSizeWidth;
/// 选中页码大小-高，默认6.0
@property(nonatomic, assign) CGFloat currentPageSizeHeight;
/// 选中页码大小-宽，默认6.0
@property(nonatomic, assign) CGFloat currentPageSizeWidth;
/// 适配图标大小，默认NO（设置YES后，宽高pageSizeHeight,pageSizeWidth,currentPageSizeHeight,currentPageSizeHeight设置无效）
@property (nonatomic, assign) BOOL shouldAutoresizingImage;

/// 圆角属性，默认无
@property (nonatomic, assign) CGFloat pageCornerRadius;
///
@property (nonatomic, assign) CGFloat currentPageCornerRadius;

#pragma mark - 链式属性

/// 页码数量
- (TFY_BannerPageControl *(^)(NSInteger pages))pages;

/// 页码当前页
- (TFY_BannerPageControl *(^)(NSInteger page))page;

/// 页码单个时是否隐藏
- (TFY_BannerPageControl *(^)(BOOL hidden))hidesPageWhileSingle;

/// 页码非高亮颜色
- (TFY_BannerPageControl *(^)(UIColor *color))pageColor;

/// 页码高亮颜色
- (TFY_BannerPageControl *(^)(UIColor *color))currentPageColor;

/// 页码非高亮图标
- (TFY_BannerPageControl *(^)(UIImage *image))pageImage;

/// 页码高亮图标
- (TFY_BannerPageControl *(^)(UIImage *image))currentPageImage;

/// 页码显示样式
- (TFY_BannerPageControl *(^)(PageControlType type))pageType;

/// 页码对齐方式
- (TFY_BannerPageControl *(^)(PageControlAlignment alignment))pageAlignment;

/// 页码高亮时放大
- (TFY_BannerPageControl *(^)(CGFloat scale))pageScale;

/// 页码序号是否显示
- (TFY_BannerPageControl *(^)(BOOL show))showPageIndex;

/// 页码序号非高亮时颜色
- (TFY_BannerPageControl *(^)(UIColor *color))pageIndexColor;

/// 页码序号高亮时颜色
- (TFY_BannerPageControl *(^)(UIColor *color))currentPageIndexColor;

/// 页码序号非高亮时字体大小
- (TFY_BannerPageControl *(^)(UIFont *font))pageIndexFont;

/// 页码高亮时字体大小
- (TFY_BannerPageControl *(^)(UIFont *font))currentPageIndexFont;

/// 页码间距
- (TFY_BannerPageControl *(^)(CGFloat margin))pageMarginX;

/// 页码高
- (TFY_BannerPageControl *(^)(CGFloat height))pageHeight;

/// 页码宽
- (TFY_BannerPageControl *(^)(CGFloat width))pageWidth;

/// 页码是否适配图标大小
- (TFY_BannerPageControl *(^)(BOOL autoresizing))autoresizingImage;

@end

NS_ASSUME_NONNULL_END
