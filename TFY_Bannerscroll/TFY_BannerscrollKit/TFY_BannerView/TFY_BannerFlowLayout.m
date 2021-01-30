//
//  TFY_BannerFlowLayout.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BannerFlowLayout.h"

@interface TFY_BannerFlowLayout (){
    CGSize factItemSize;
}
@end

@implementation TFY_BannerFlowLayout
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param{
    if (self = [super init]) {
        self.param = param;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
  
    self.itemSize = self.param.tfy_ItemSize;
    self.minimumInteritemSpacing = (self.param.tfy_Frame.size.height-self.param.tfy_ItemSize.height)/2;
    self.minimumLineSpacing = self.param.tfy_LineSpacing;
    self.sectionInset = self.param.tfy_SectionInset;
    if ([self.collectionView isPagingEnabled]) {
         self.scrollDirection = self.param.tfy_Vertical? UICollectionViewScrollDirectionVertical
                                                     :UICollectionViewScrollDirectionHorizontal;
    }else{
         self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self cardScaleTypeInRect:rect];
}

//卡片缩放
- (NSArray<UICollectionViewLayoutAttributes *> *)cardScaleTypeInRect:(CGRect)rect{
    
    NSArray *array = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:rect]];
    if (!self.param.tfy_Scale||self.param.tfy_Marquee) {
        return array;
    }
    CGRect  visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (int i = 0; i<array.count; i++) {
        UICollectionViewLayoutAttributes *attributes = array[i];
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat normalizedDistance = fabs(distance / self.param.tfy_ActiveDistance);
        CGFloat zoom = 1 - self.param.tfy_ScaleFactor  * normalizedDistance;
        attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributes.frame = CGRectMake(attributes.frame.origin.x, attributes.frame.origin.y + zoom, attributes.size.width, attributes.size.height);
        if (self.param.tfy_Alpha<1) {
            CGFloat collectionCenter =  self.collectionView.frame.size.width / 2 ;
            CGFloat offset = self.collectionView.contentOffset.x ;
            CGFloat normalizedCenter =  attributes.center.x - offset;
            CGFloat maxDistance = (self.itemSize.width) + self.minimumLineSpacing;
            CGFloat distance1 = MIN(fabs(collectionCenter - normalizedCenter), maxDistance);
            CGFloat ratio = (maxDistance - distance1) / maxDistance;
            CGFloat alpha = ratio * (1 - self.param.tfy_Alpha) +self.param.tfy_Alpha;
            attributes.alpha = alpha;
        }
        attributes.center = CGPointMake(attributes.center.x, (self.param.tfy_Position == BannerCellPositionBottom?attributes.center.y:self.collectionView.center.y) + zoom);

    }
    return array;
}



- (NSArray *)getCopyOfAttributes:(NSArray *)attributes
{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (self.param.tfy_Marquee){
        return NO;
    }
    return ![self.collectionView isPagingEnabled];
}

/**
 * collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if ([self.collectionView isPagingEnabled]||self.param.tfy_Marquee) {
        return proposedContentOffset;
    }
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
  
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * self.param.tfy_ContentOffsetX;
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }

    proposedContentOffset.x += minDelta;

    if (!self.param.tfy_CardOverLap) {
        self.param.myCurrentPath = round((ABS(proposedContentOffset.x))/(self.param.tfy_ItemSize.width+self.param.tfy_LineSpacing));
    }

    return proposedContentOffset;
    
}

@end
