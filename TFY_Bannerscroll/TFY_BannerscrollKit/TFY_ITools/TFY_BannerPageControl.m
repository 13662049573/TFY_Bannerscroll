//
//  TFY_BannerPageControl.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/27.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerPageControl.h"

@interface TFY_BannerPageControl ()

@property (nonatomic, strong) NSMutableArray *pageNormals;
@property (nonatomic, strong) NSMutableArray *pageSelecteds;
@property (nonatomic, strong) NSMutableArray *labelNormals;
@property (nonatomic, strong) NSMutableArray *labelSelecteds;

@end

@implementation TFY_BannerPageControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self database];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        [self database];
        
        [self setNeedsLayout];
    }
    
    return self;
}

- (void)database {
    _numberOfPages = 0;
    _currentPage = 0;
    
    _hidesForSinglePage = NO;
    
    _pageIndicatorColor = [UIColor lightGrayColor];
    _currentPageIndicatorColor = [UIColor blackColor];
    
    _pageControlType = PageControlTypeSquare;
    _pageControlAlignment = PageControlAlignmentDefault;
    
    _transformScale = 1.0;
    
    _showPageNumber = NO;
    _pageNumberColor = [UIColor lightGrayColor];
    _currentPageNumberColor = [UIColor blackColor];
    _pageNumberFont = [UIFont systemFontOfSize:6.0];
    _currentPageNumberFont = [UIFont systemFontOfSize:6.0];
    
    _pageMargin = 6.0;
    _pageSizeHeight = 6.0;
    _pageSizeWidth = 6.0;
    _shouldAutoresizingImage = NO;
    _currentPageSizeWidth = 6.0;
    _currentPageSizeHeight = 6.0;
}


- (void)layoutSubviews
{
    [self reloadUIView];
}

// 初始化页签视图
- (void)initializeUIView
{
    if ((self.pageNormals.count == 0 && 0 < _numberOfPages) || self.pageNormals.count != _numberOfPages) {
        // 清空数组
        [self.pageNormals removeAllObjects];
        [self.pageSelecteds removeAllObjects];
        [self.labelNormals removeAllObjects];
        [self.labelSelecteds removeAllObjects];
        // 清空子视图
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]] || [obj isKindOfClass:[UILabel class]]) {
                [obj removeFromSuperview];
            }
        }];
        
        for (int i = 0; i < _numberOfPages; i++) {
            //
            UIImageView *imageViewNormal = [[UIImageView alloc] init];
            [self addSubview:imageViewNormal];
            imageViewNormal.clipsToBounds = YES;
            imageViewNormal.layer.masksToBounds = YES;
            [self.pageNormals addObject:imageViewNormal];
            //
            UIImageView *imageViewSelected = [[UIImageView alloc] init];
            [self addSubview:imageViewSelected];
            imageViewSelected.clipsToBounds = YES;
            imageViewSelected.layer.masksToBounds = YES;
            imageViewSelected.hidden = YES;
            [self.pageSelecteds addObject:imageViewSelected];
            //
            UILabel *labelNormal = [UILabel new];
            [imageViewNormal addSubview:labelNormal];
            labelNormal.backgroundColor = [UIColor clearColor];
            labelNormal.textAlignment = NSTextAlignmentCenter;
            labelNormal.adjustsFontSizeToFitWidth = YES;
            labelNormal.hidden = YES;
            [self.labelNormals addObject:labelNormal];
            //
            UILabel *labelSelected = [UILabel new];
            [imageViewSelected addSubview:labelSelected];
            labelSelected.backgroundColor = [UIColor clearColor];
            labelSelected.textAlignment = NSTextAlignmentCenter;
            labelSelected.adjustsFontSizeToFitWidth = YES;
            labelSelected.hidden = YES;
            [self.labelSelecteds addObject:labelSelected];
        }
    }
}

// 设置页签视图属性
- (void)resetUIView
{
    [self resetWidthHeight];
    
    __block CGFloat originX = (self.frame.size.width - _pageMargin * (_numberOfPages - 1) - (self.pageSizeWidth * (_numberOfPages - 1)) - self.currentPageSizeWidth) / 2;
    
    if (_pageControlType == PageControlTypeLine) {
        // 线条样式时，高度最大为2.0
        self.pageSizeHeight = (2.0 <= self.pageSizeHeight ? 2.0 : self.pageSizeHeight);
        self.currentPageSizeHeight = (2.0 <= self.currentPageSizeHeight ? 2.0 : self.currentPageSizeHeight);
    }
    CGFloat originY = (self.frame.size.height - self.pageSizeHeight) / 2;
    CGFloat currentOriginY = (self.frame.size.height - self.currentPageSizeHeight) / 2;
    
    if (_pageControlAlignment == PageControlAlignmentLeft) {
        originX = _pageMargin;
    } else if (_pageControlAlignment == PageControlAlignmentRight) {
        originX = self.frame.size.width - ((self.pageSizeWidth * (_numberOfPages - 1)) + self.currentPageSizeWidth + _pageMargin * _numberOfPages);
    } else if (_pageControlAlignment == PageControlAlignmentEqual) {
        _pageMargin = (self.frame.size.width - (self.pageSizeWidth * (_numberOfPages - 1)) - self.currentPageSizeWidth) / (_numberOfPages + 1);
        originX = _pageMargin;
    } else if (_pageControlAlignment == PageControlAlignmentBottom) {
        if (_pageControlType == PageControlTypeLine) {
            originY = (self.frame.size.height - self.pageSizeHeight);
            currentOriginY = (self.frame.size.height - self.currentPageSizeHeight);
        }
    }
    
    [self.pageNormals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageViewNormal = (UIImageView *)obj;
        imageViewNormal.backgroundColor = _pageIndicatorColor;
        imageViewNormal.hidden = NO;
        
        UIImageView *imageViewSelected = self.pageSelecteds[idx];
        imageViewSelected.backgroundColor = _currentPageIndicatorColor;
        imageViewSelected.hidden = YES;
        
        // 页码位置大小
        imageViewNormal.frame = CGRectMake(originX, originY, self.pageSizeWidth, self.pageSizeHeight);
        imageViewSelected.frame = CGRectMake(originX, currentOriginY, self.currentPageSizeWidth, self.currentPageSizeHeight);
        originX += ((idx == _currentPage ? self.currentPageSizeWidth : self.pageSizeWidth) + _pageMargin);
        
        // 圆角属性
        if (self.pageCornerRadius > 0) {
            imageViewNormal.layer.cornerRadius = self.pageCornerRadius;
        }
        if (self.currentPageCornerRadius > 0) {
            imageViewSelected.layer.cornerRadius = self.currentPageCornerRadius;
        }
        
        // 页码显示样式
        if (_pageControlType == PageControlTypeCircle) {
            imageViewNormal.layer.cornerRadius = self.pageSizeHeight / 2;
            imageViewSelected.layer.cornerRadius = self.currentPageSizeHeight / 2;
        } else if (_pageControlType == PageControlTypeLine) {
            // 线条样式时，不显示序号
            _showPageNumber = NO;
        } else if (_pageControlType == PageControlTypeImage) {
            imageViewNormal.backgroundColor = [UIColor clearColor];
            imageViewSelected.backgroundColor = [UIColor clearColor];
            
            imageViewNormal.image = _pageIndicatorImage;
            imageViewSelected.image = _currentPageIndicatorImage;
        }
        
        // 高亮页码显示，非高亮隐藏
        if (idx == _currentPage) {
            imageViewNormal.hidden = YES;
            imageViewSelected.hidden = NO;
        }
        
        // 显示序号
        if (_showPageNumber) {
            UILabel *labelNormal = self.labelNormals[idx];;
            labelNormal.hidden = NO;
            labelNormal.textColor = _pageNumberColor;
            labelNormal.font = _pageNumberFont;
            
            UILabel *labelSelected = self.labelSelecteds[idx];
            labelSelected.hidden = YES;
            labelSelected.textColor = _currentPageNumberColor;
            labelSelected.font = _currentPageNumberFont;
            
            labelNormal.text = [NSString stringWithFormat:@"%@", @(idx + 1)];
            labelSelected.text = [NSString stringWithFormat:@"%@", @(idx + 1)];
            
            labelNormal.frame = imageViewNormal.bounds;
            labelSelected.frame = imageViewSelected.bounds;
            
            if (idx == _currentPage) {
                labelNormal.hidden = YES;
                labelSelected.hidden = NO;
            }
        }
        
        // 高亮放大显示
        imageViewSelected.transform = CGAffineTransformScale(imageViewSelected.transform, _transformScale, _transformScale);
    }];
}

// 重置视图属性
- (void)reloadUIView
{
    if (_hidesForSinglePage && 1 == _numberOfPages) {
        // 单页时，隐藏
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        return;
    }
    
    // 初始化页签视图
    [self initializeUIView];
    
    // 设置页签视图属性
    [self resetUIView];
}

- (void)resetWidthHeight
{
    if (_pageControlType == PageControlTypeLine) {
        // 线条形
        if (_pageSizeWidth < _pageSizeHeight) {
            _pageSizeWidth = (self.frame.size.width - _pageMargin * (_numberOfPages - 1)) / _numberOfPages;
        }
    } else if (_pageControlType == PageControlTypeImage && _shouldAutoresizingImage) {
        // 图片形
        _pageSizeWidth = _pageIndicatorImage.size.width;
        _pageSizeHeight = _pageIndicatorImage.size.height;
        //
        _currentPageSizeWidth = _currentPageIndicatorImage.size.width;
        _currentPageSizeHeight = _currentPageIndicatorImage.size.height;
    }
    
    if (self.frame.size.width < (_pageMargin * (_numberOfPages - 1) + _pageSizeWidth * (_numberOfPages - 1) + _currentPageSizeWidth)) {
        // 页签宽和超过父视图时重置
        _pageSizeWidth = (self.frame.size.width - _pageMargin * (_numberOfPages - 1) - _currentPageSizeWidth) / _numberOfPages;
    }

    if (self.frame.size.height < _pageSizeHeight) {
        // 页签高超过父视图时重置
        _pageSizeHeight = self.frame.size.height;
    }
    if (self.frame.size.height < _currentPageSizeHeight) {
        // 页签高超过父视图时重置
        _currentPageSizeHeight = self.frame.size.height;
    }
}

#pragma mark - getter

- (NSMutableArray *)pageNormals
{
    if (_pageNormals == nil) {
        _pageNormals = [NSMutableArray array];
    }
    return _pageNormals;
}

- (NSMutableArray *)pageSelecteds
{
    if (_pageSelecteds == nil) {
        _pageSelecteds = [NSMutableArray array];
    }
    return _pageSelecteds;
}

- (NSMutableArray *)labelNormals
{
    if (_labelNormals == nil) {
        _labelNormals = [NSMutableArray array];
    }
    return _labelNormals;
}

- (NSMutableArray *)labelSelecteds
{
    if (_labelSelecteds == nil) {
        _labelSelecteds = [NSMutableArray array];
    }
    return _labelSelecteds;
}

#pragma mark - setter

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    if (_currentPage <= 0) {
        _currentPage = 0;
    } else if (_currentPage >= _numberOfPages) {
        _currentPage = _numberOfPages - 1;
    }
    
    [self setNeedsLayout];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformIdentity;
    }];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    [self setNeedsLayout];
}

- (void)setPageControlType:(PageControlType)pageControlType
{
    _pageControlType = pageControlType;
    [self setNeedsLayout];
}

- (void)setPageControlAlignment:(PageControlAlignment)pageControlAlignment
{
    _pageControlAlignment = pageControlAlignment;
    [self setNeedsLayout];
}

- (void)setTransformScale:(CGFloat)transformScale
{
    _transformScale = transformScale;
    if (_transformScale < 1.0) {
        _transformScale = 1.0;
    } else if (_transformScale > 2.0) {
        _transformScale = 2.0;
    }
    [self setNeedsLayout];
}

- (void)setShowPageNumber:(BOOL)showPageNumber
{
    _showPageNumber = showPageNumber;
    [self setNeedsLayout];
}

- (void)setPageNumberColor:(UIColor *)pageNumberColor
{
    _pageNumberColor = pageNumberColor;
    [self setNeedsLayout];
}

- (void)setPageNumberFont:(UIFont *)pageNumberFont
{
    _pageNumberFont = pageNumberFont;
    [self setNeedsLayout];
}

- (void)setCurrentPageNumberColor:(UIColor *)currentPageNumberColor
{
    _currentPageNumberColor = currentPageNumberColor;
    [self setNeedsLayout];
}

- (void)setCurrentPageNumberFont:(UIFont *)currentPageNumberFont
{
    _currentPageNumberFont = currentPageNumberFont;
    [self setNeedsLayout];
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage
{
    _pageIndicatorImage = pageIndicatorImage;
    [self setNeedsLayout];
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage
{
    _currentPageIndicatorImage = currentPageIndicatorImage;
    [self setNeedsLayout];
}

- (void)setPageCornerRadius:(CGFloat)pageCornerRadius
{
    _pageCornerRadius = pageCornerRadius;
    [self setNeedsLayout];
}

- (void)setCurrentPageCornerRadius:(CGFloat)currentPageCornerRadius
{
    _currentPageCornerRadius = currentPageCornerRadius;
    [self setNeedsLayout];
}

#pragma mark - 链式属性

/// 页码数量
- (TFY_BannerPageControl *(^)(NSInteger pages))pages
{
    return ^(NSInteger pages) {
        self.numberOfPages = pages;
        return self;
    };
}

/// 页码当前页
- (TFY_BannerPageControl *(^)(NSInteger page))page
{
    return ^(NSInteger page) {
        self.currentPage = page;
        return self;
    };
}

/// 页码单个时是否隐藏
- (TFY_BannerPageControl *(^)(BOOL hidden))hidesPageWhileSingle
{
    return ^(BOOL hidden) {
        self.hidesForSinglePage = hidden;
        return self;
    };
}

/// 页码非高亮颜色
- (TFY_BannerPageControl *(^)(UIColor *color))pageColor
{
    return ^(UIColor *color) {
        self.pageIndicatorColor = color;
        return self;
    };
}

/// 页码高亮颜色
- (TFY_BannerPageControl *(^)(UIColor *color))currentPageColor
{
    return ^(UIColor *color) {
        self.currentPageIndicatorColor = color;
        return self;
    };
}

/// 页码非高亮图标
- (TFY_BannerPageControl *(^)(UIImage *image))pageImage
{
    return ^(UIImage *image) {
        self.pageIndicatorImage = image;
        return self;
    };
}

/// 页码高亮图标
- (TFY_BannerPageControl *(^)(UIImage *image))currentPageImage
{
    return ^(UIImage *image) {
        self.currentPageIndicatorImage = image;
        return self;
    };
}

/// 页码显示样式
- (TFY_BannerPageControl *(^)(PageControlType type))pageType
{
    return ^(PageControlType type) {
        self.pageControlType = type;
        return self;
    };
}

/// 页码对齐方式
- (TFY_BannerPageControl *(^)(PageControlAlignment alignment))pageAlignment
{
    return ^(PageControlAlignment alignment) {
        self.pageControlAlignment = alignment;
        return self;
    };
}

/// 页码高亮时放大
- (TFY_BannerPageControl *(^)(CGFloat scale))pageScale
{
    return ^(CGFloat scale) {
        self.transformScale = scale;
        return self;
    };
}

/// 页码序号是否显示
- (TFY_BannerPageControl *(^)(BOOL show))showPageIndex
{
    return ^(BOOL show) {
        self.showPageNumber = show;
        return self;
    };
}

/// 页码序号非高亮时颜色
- (TFY_BannerPageControl *(^)(UIColor *color))pageIndexColor
{
    return ^(UIColor *color) {
        self.pageNumberColor = color;
        return self;
    };
}

/// 页码序号高亮时颜色
- (TFY_BannerPageControl *(^)(UIColor *color))currentPageIndexColor
{
    return ^(UIColor *color) {
        self.currentPageNumberColor = color;
        return self;
    };
}

/// 页码序号非高亮时字体大小
- (TFY_BannerPageControl *(^)(UIFont *font))pageIndexFont
{
    return ^(UIFont *font) {
        self.pageNumberFont = font;
        return self;
    };
}

/// 页码高亮时字体大小
- (TFY_BannerPageControl *(^)(UIFont *font))currentPageIndexFont
{
    return ^(UIFont *font) {
        self.currentPageNumberFont = font;
        return self;
    };
}

/// 页码间距
- (TFY_BannerPageControl *(^)(CGFloat margin))pageMarginX
{
    return ^(CGFloat margin) {
        self.pageMargin = margin;
        return self;
    };
}

/// 页码高
- (TFY_BannerPageControl *(^)(CGFloat height))pageHeight
{
    return ^(CGFloat height) {
        self.pageSizeHeight = height;
        return self;
    };
}

/// 页码宽
- (TFY_BannerPageControl *(^)(CGFloat width))pageWidth
{
    return ^(CGFloat width) {
        self.pageSizeWidth = width;
        return self;
    };
}

/// 页码是否适配图标大小
- (TFY_BannerPageControl *(^)(BOOL autoresizing))autoresizingImage
{
    return ^(BOOL autoresizing) {
        self.shouldAutoresizingImage = autoresizing;
        return self;
    };
}


@end
