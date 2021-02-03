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
    [self setUpIndex];
    NSArray *array = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:rect]];
    if (!self.param.tfy_Scale||self.param.tfy_Marquee) {
        return array;
    }
    CGRect  visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSMutableArray *marr = [NSMutableArray new];
    NSInteger minIndex = 0;
    CGFloat minCenterX = [(UICollectionViewLayoutAttributes*)array.firstObject center].x;
    for (int i = 0; i<array.count; i++) {
        UICollectionViewLayoutAttributes *attributes = array[i];
        CGRect cellFrameInSuperview = [self.collectionView convertRect:attributes.frame toView:self.collectionView.superview];
        if (cellFrameInSuperview.origin.x>=0&&
            cellFrameInSuperview.origin.x<=self.collectionView.frame.size.width) {
            if (minCenterX>cellFrameInSuperview.origin.x) {
                minCenterX = cellFrameInSuperview.origin.x;
                minIndex = i;
            }
        }
    }
    for (int i = 0; i<array.count; i++) {
        UICollectionViewLayoutAttributes *attributes = array[i];
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        if (self.param.tfy_ContentOffsetX!=0.5) {
             distance = CGRectGetMidX(visibleRect) - (attributes.center.x + (0.5-self.param.tfy_ContentOffsetX)*visibleRect.size.width);
        }
        if (self.param.tfy_SpecialStyle == SpecialStyleFirstScale) {
            distance = CGRectGetMinX(visibleRect) - attributes.center.x;
        }
        CGFloat normalizedDistance = fabs(distance / self.param.tfy_ActiveDistance);
        CGFloat zoom = 1 - self.param.tfy_ScaleFactor  * normalizedDistance;
        if (self.param.tfy_SpecialStyle == SpecialStyleFirstScale) {
            if (i == minIndex) {
                attributes.transform3D = CATransform3DMakeScale(1.0, zoom+0.6, 1.0);
            }else{
                attributes.transform3D = CATransform3DMakeScale(1.0, 1.0, 1.0);
            }
        }else{
            attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        }
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
        if (self.param.tfy_Zindex) {
           attributes.zIndex = zoom*100;
        }
        CGPoint center = CGPointMake(attributes.center.x, self.collectionView.center.y );
        if (self.param.tfy_Position == BannerCellPositionBottom) {
            center =  CGPointMake(attributes.center.x, attributes.center.y + attributes.size.height*(1-zoom));
            attributes.center = center;
        }else if (self.param.tfy_Position == BannerCellPositionTop) {
            center =  CGPointMake(attributes.center.x, attributes.center.y-  attributes.size.height*(1-zoom));
            attributes.center = center;
        }else if (self.param.tfy_Position == BannerCellPositionCenter) {
            attributes.center = center;
        }
        [marr addObject:attributes];
    }
    return marr;
}

- (void)setUpIndex{
    switch (self.param.tfy_CardOverLap) {
        case CardtypeCommon:
            self.param.myCurrentPath = self.param.tfy_Vertical?
            round((ABS(self.collectionView.contentOffset.y))/(self.param.tfy_ItemSize.height+self.param.tfy_LineSpacing)):
                round ((ABS(self.collectionView.contentOffset.x))/(self.param.tfy_ItemSize.width+self.param.tfy_LineSpacing));
            break;
        case CardtypeFallen:
            
            break;
        case CardtypeMultifunction:
            
            break;
        default:
            break;
    }
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

       
    CGFloat offSetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = (CGFloat) (proposedContentOffset.x + self.collectionView.frame.size.width * self.param.tfy_ContentOffsetX);

    CGRect targetRect = CGRectMake(proposedContentOffset.x,
                                    0.0,
                                    self.collectionView.bounds.size.width,
                                    self.collectionView.bounds.size.height);
       
    NSArray *attributes = [self layoutAttributesForElementsInRect:targetRect];
    NSPredicate *cellAttributesPredicate = [NSPredicate predicateWithBlock: ^BOOL(UICollectionViewLayoutAttributes * _Nonnull evaluatedObject,NSDictionary<NSString *,id> * _Nullable bindings){
           return (evaluatedObject.representedElementCategory == UICollectionElementCategoryCell);
       }];
       
    NSArray *cellAttributes = [attributes filteredArrayUsingPredicate: cellAttributesPredicate];
       
    UICollectionViewLayoutAttributes *currentAttributes;
       
    for (UICollectionViewLayoutAttributes *layoutAttributes in cellAttributes)
    {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offSetAdjustment))
        {
            currentAttributes   = layoutAttributes;
            offSetAdjustment    = itemHorizontalCenter - horizontalCenter;
        }
    }
       
    CGFloat nextOffset          = proposedContentOffset.x + offSetAdjustment;
       
    proposedContentOffset.x     = nextOffset;
    CGFloat deltaX              = proposedContentOffset.x - self.collectionView.contentOffset.x;
    CGFloat velX                = velocity.x;
       
    if (fabs(deltaX) <= FLT_EPSILON || fabs(velX) <= FLT_EPSILON || (velX > 0.0 && deltaX > 0.0) || (velX < 0.0 && deltaX < 0.0))
    {
        
    }else if (velocity.x > 0.0){
      NSArray *revertedArray = [[attributes reverseObjectEnumerator] allObjects];
      BOOL found = YES;
      float proposedX = 0.0;
      for (UICollectionViewLayoutAttributes *layoutAttributes in revertedArray)
           {
               if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
               {
                   CGFloat itemHorizontalCenter = layoutAttributes.center.x;
                   if (itemHorizontalCenter > proposedContentOffset.x) {
                       found = YES;
                       proposedX = nextOffset + (currentAttributes.frame.size.width / 2) + (layoutAttributes.frame.size.width / 2);
                   } else {
                       break;
                   }
               }
           }
           
           if (found) {
               proposedContentOffset.x = proposedX;
               proposedContentOffset.x += self.param.tfy_LineSpacing;
           }
       }
       else if (velocity.x < 0.0)
       {
           for (UICollectionViewLayoutAttributes *layoutAttributes in cellAttributes)
           {
               CGFloat itemHorizontalCenter = layoutAttributes.center.x;
               if (itemHorizontalCenter > proposedContentOffset.x)
               {
                   proposedContentOffset.x = nextOffset - ((currentAttributes.frame.size.width / 2) + (layoutAttributes.frame.size.width / 2));
                   proposedContentOffset.x -= self.param.tfy_LineSpacing;
                   break;
               }
           }
       }
       proposedContentOffset.y = 0.0;
       
       return proposedContentOffset;
    
}
@end
