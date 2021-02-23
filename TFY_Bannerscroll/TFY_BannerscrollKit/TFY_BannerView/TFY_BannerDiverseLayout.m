//
//  TFY_BannerDiverseLayout.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2021/1/31.
//  Copyright © 2021 田风有. All rights reserved.
//

#import "TFY_BannerDiverseLayout.h"
#import "TFY_BannerDiverseLayoutAttributes.h"

@interface TFY_BannerDiverseLayout ()<UICollectionViewDelegate>
/// 所有的item的属性数组
@property (nonatomic,strong) NSMutableArray *attributeArray;
@end

@implementation TFY_BannerDiverseLayout
{
    CGFloat   _viewHeight;// 竖直滚动表示collectionView高,水平表示宽
    CGFloat   _itemHeight;// 竖直滚动表示cell高,水平表示宽
    NSInteger _cellCount;
}

- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param{
    if (self = [super init]) {
        self.param = param;
    }
    return self;
}

/*
接下来需要告诉collection view使用自定义的类而不是系统的UICollectionViewLayoutAttributes类，需要在自定义的LVCollectionViewLayout中重写类方法+(Class)layoutAttributesClass
 */
+ (Class)layoutAttributesClass{
    return [TFY_BannerDiverseLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    if (self.param.tfy_Vertical) {
        _viewHeight = CGRectGetHeight(self.collectionView.frame);
        _itemHeight = self.param.tfy_ItemSize.height + self.param.tfy_space;
        if (self.param.tfy_scrollType != DiverseImageScrollCardSeven) {
            self.collectionView.contentInset = UIEdgeInsetsMake((_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2, 0);
        }
    } else {
        _viewHeight = CGRectGetWidth(self.collectionView.frame);
        _itemHeight = self.param.tfy_ItemSize.width + self.param.tfy_space;
        if (self.param.tfy_scrollType != DiverseImageScrollCardSeven) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2);
        }
    }
    
    [self.attributeArray removeAllObjects];
    
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    if (_cellCount == 0) {
        return;
    }
    
    /// 获取总的旋转的角度
    CGFloat angleAtExtreme = (_cellCount - 1) * self.param.tfy_anglePerItem;
    /// 随着UICollectionView的移动，第0个cell初始时的角度
    CGFloat angle;
    //// 锚点的位置
    CGFloat anchorPoint;
    
    CGFloat zommScale = (self.param.tfy_ScreenScale-0.2);
    
    NSInteger minIndex = 0;
    NSInteger maxIndex = _cellCount - 1;
    if (self.param.tfy_visibleCount <= 0) {
        NSAssert(NO, @"visibleCount不能小于等于0");
    }else {
        NSInteger index = 0;
        if (self.param.tfy_scrollType != DiverseImageScrollCardSeven) {
            CGFloat centerY = (self.param.tfy_Vertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
            index = centerY / _itemHeight;
        }else {
            CGFloat factor;
            // 默认停下来时，旋转的角度
            CGFloat proposedAngle;
            if (self.param.tfy_Vertical) {
                factor = angleAtExtreme / (self.collectionView.contentSize.height - _viewHeight);
                proposedAngle = factor * self.collectionView.contentOffset.y;

            }else {
                factor = angleAtExtreme / (self.collectionView.contentSize.width - _viewHeight);
                proposedAngle = factor * self.collectionView.contentOffset.x;
            }
            CGFloat ratio = proposedAngle / self.param.tfy_anglePerItem;
            index = roundf(ratio);

        }
        if (index < 0) {
            index = 0;
        }
        if (index >= _cellCount) {
            index = _cellCount - 1;
        }

        NSInteger count = (self.param.tfy_visibleCount - 1) / 2;
        minIndex = MAX(0, (index - count));
        maxIndex = MIN((_cellCount - 1), (index + count));
    }

    if (self.param.tfy_Vertical) {
        angle = - angleAtExtreme * self.collectionView.contentOffset.y / (self.collectionView.contentSize.height - _viewHeight);
        anchorPoint = (self.param.tfy_ItemSize.width/2.0 + self.param.tfy_radius) / self.param.tfy_ItemSize.width;
    }else {
        angle = - angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionView.contentSize.width - _viewHeight);
        anchorPoint = (self.param.tfy_ItemSize.height/2.0 + self.param.tfy_radius) / self.param.tfy_ItemSize.height;
    }
    
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        TFY_BannerDiverseLayoutAttributes *attribute = [TFY_BannerDiverseLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attribute.size = self.param.tfy_ItemSize;
        CGFloat rowCenter = _itemHeight * i + _itemHeight / 2;
        
        CGFloat center = (self.param.tfy_Vertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
        
        switch (self.param.tfy_scrollType) {
            case DiverseImageScrollCardFour:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CGFloat scale = 1 - ABS(ratio) * (1 - zommScale);
                if (self.param.tfy_Vertical) {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width * scale, self.param.tfy_ItemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2 - self.param.tfy_ItemSize.width * ((1 - zommScale)/2) * ABS(ratio), rowCenter);
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width, self.param.tfy_ItemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width * zommScale, self.param.tfy_ItemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2 - self.param.tfy_ItemSize.width * ((1 - zommScale)/2), rowCenter);
                    }
                }else {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width, self.param.tfy_ItemSize.height * scale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2 + self.param.tfy_ItemSize.height * ((1 - zommScale)/2) * ABS(ratio));
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width, self.param.tfy_ItemSize.height);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.param.tfy_ItemSize.width, self.param.tfy_ItemSize.height * zommScale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2 + self.param.tfy_ItemSize.height * ((1 - zommScale)/2));
                    }
                }
            }
                break;
            case DiverseImageScrollCardFive:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                attribute.transform = CGAffineTransformRotate(attribute.transform, - ratio * self.param.tfy_rotationAngle);
                if (self.param.tfy_Vertical) {
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                }else {
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
                attribute.zIndex = (int)(-1) *i *1000;
            }
                break;
            case DiverseImageScrollCardSix:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CATransform3D transform = CATransform3DIdentity;
                transform.m34 = -1.0/400.0f;
                if (self.param.tfy_Vertical) {
                    transform = CATransform3DRotate(transform, ratio * self.param.tfy_rotationAngle, 1, 0, 0);
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                }else {
                    transform = CATransform3DRotate(transform, -ratio * self.param.tfy_rotationAngle, 0, 1, 0);
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
                attribute.transform3D = transform;
            }
                break;
            case DiverseImageScrollCardSeven:
            {
                attribute.angle = angle + self.param.tfy_anglePerItem *i;
                attribute.scrollDirection = self.param.tfy_Vertical;
                if (self.param.tfy_Vertical) {
                    attribute.anchorPoint = CGPointMake(-anchorPoint, 0.5);
                    attribute.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), center);
                }else {
                    attribute.anchorPoint = CGPointMake(0.5, anchorPoint);
                    attribute.center = CGPointMake(center, CGRectGetMidY(self.collectionView.bounds));
                    
                }
                attribute.transform = CGAffineTransformMakeRotation(attribute.angle);
                attribute.zIndex = (int)(-1) *i *1000;
            }
                break;
            default:
            {
                if (self.param.tfy_Vertical) {
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                } else {
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
            }
                break;
        }

        
        [self.attributeArray addObject:attribute];
    }
    
}

- (CGSize)collectionViewContentSize {
    if (self.param.tfy_Vertical) {
        if (self.param.tfy_scrollType == DiverseImageScrollCardSeven) {
            // UICollectionView不满一屏时，无法滚动
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame), _cellCount * self.param.tfy_ItemSize.height + _viewHeight);
        }
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), _cellCount * _itemHeight);
    }else {
        if (self.param.tfy_scrollType == DiverseImageScrollCardSeven) {
            // 加上_viewHeight是因为UICollectionView不满一屏时，无法滚动,并且加上了滚动会丝滑点,具体原因以后再学习
            return CGSizeMake(_cellCount * self.param.tfy_ItemSize.width + _viewHeight, CGRectGetHeight(self.collectionView.frame));
        }
        return CGSizeMake(_cellCount * _itemHeight, CGRectGetHeight(self.collectionView.frame));
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributeArray;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 预期停下来original
    CGPoint finalContentOffset = proposedContentOffset;
    if (self.param.tfy_scrollType == DiverseImageScrollCardSeven) {
        if (self.param.tfy_Vertical) {
            // 影响参数
            CGFloat angleAtExtreme = (_cellCount - 1) * self.param.tfy_anglePerItem;
            CGFloat factor = -angleAtExtreme / (self.collectionView.contentSize.height - _viewHeight);

            // 默认停下来时，旋转的角度
            CGFloat proposedAngle = factor * self.collectionView.contentOffset.y;
            CGFloat ratio = proposedAngle / self.param.tfy_anglePerItem;

            CGFloat multiplier = 0;
            if (velocity.y > 0) {
                //向下运动
                if (self.param.myCurrentPath) {
                    multiplier = self.param.myCurrentPath - 1;
                }else {
                    multiplier = ceil(ratio);
                }
                
            }else if (velocity.y < 0){
                //向上运动
                if (self.param.myCurrentPath) {
                    multiplier = self.param.myCurrentPath + 1;
                }else {
                    multiplier = floor(ratio);
                }
            }else{
                //速度为0
                multiplier = round(ratio);
            }
            finalContentOffset.y = multiplier * self.param.tfy_anglePerItem / factor;
        }else {
            // 影响参数
            CGFloat angleAtExtreme = (_cellCount - 1) * self.param.tfy_anglePerItem;
            CGFloat factor = -angleAtExtreme / (self.collectionView.contentSize.width - _viewHeight);

            // 默认停下来时，旋转的角度
            CGFloat proposedAngle = factor * self.collectionView.contentOffset.x;
            CGFloat ratio = proposedAngle / self.param.tfy_anglePerItem;

            CGFloat multiplier = 0;
            if (velocity.x > 0) {
                //向右运动
                if (self.param.myCurrentPath) {
                    multiplier = self.param.myCurrentPath - 1;
                }else {
                    multiplier = ceil(ratio);
                }
                
            }else if (velocity.x < 0){
                //向左运动
                if (self.param.myCurrentPath) {
                    multiplier = self.param.myCurrentPath + 1;
                }else {
                    multiplier = floor(ratio);
                }
            }else{
                //速度为0
                multiplier = round(ratio);
            }
            finalContentOffset.x = multiplier * self.param.tfy_anglePerItem / factor;
        }
        
    }else {
        CGFloat index;
        if (self.param.tfy_Vertical) {
            index = roundf((proposedContentOffset.y + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
        }else {
            index = roundf((proposedContentOffset.x + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
        }
        
        if (self.param.myCurrentPath) {
            if (index > self.param.myCurrentPath) {
                index = self.param.myCurrentPath +1;
            }else {
                index = self.param.myCurrentPath -1;
            }
        }
        if (self.param.tfy_Vertical) {
            finalContentOffset.y = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
        } else {
            finalContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
        }
    }
    return finalContentOffset;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


#pragma mark - Setter && Getter
- (NSMutableArray *)attributeArray{
    if (!_attributeArray) {
        _attributeArray = [[NSMutableArray alloc]init];
    }
    return _attributeArray;
}

@end
