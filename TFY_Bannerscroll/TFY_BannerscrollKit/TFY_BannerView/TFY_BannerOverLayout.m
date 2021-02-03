//
//  TFY_BannerOverLayout.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BannerOverLayout.h"

@interface TFY_BannerOverLayout ()
@property(nonatomic,assign)CGPoint collectionContenOffset;
@property(nonatomic,assign)CGSize collectionContenSize;
@end

@implementation TFY_BannerOverLayout
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param{
    if (self = [super init]) {
        self.param = param;
        self.collectionView.bounces = NO;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    if (self.param.tfy_CardOverLapCount<=0) {
        self.param.tfy_CardOverLapCount = 4;
    }
    self.collectionView.pagingEnabled = YES;
    self.itemSize = self.param.tfy_Vertical?
    CGSizeMake(self.param.tfy_ItemSize.width , (self.param.tfy_ItemSize.height - (self.param.tfy_CardOverLapCount - 1)*self.param.tfy_LineSpacing)):
    CGSizeMake(self.param.tfy_ItemSize.width - (self.param.tfy_CardOverLapCount - 1)*self.param.tfy_LineSpacing, self.param.tfy_ItemSize.height);
    self.minimumInteritemSpacing = (self.param.tfy_CardOverLapCount - 1)*self.param.tfy_LineSpacing*2;
    self.minimumLineSpacing = (self.param.tfy_CardOverLapCount - 1)*self.param.tfy_LineSpacing*2;
    self.sectionInset = self.param.tfy_SectionInset;
    self.scrollDirection = self.param.tfy_Vertical? UICollectionViewScrollDirectionVertical
                                                        :UICollectionViewScrollDirectionHorizontal;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self cardOverLapTypeInRect:rect];
}

//卡片重叠
- (NSArray<UICollectionViewLayoutAttributes *> *)cardOverLapTypeInRect:(CGRect)rect{
    
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (itemsCount <= 0) {
        return nil;
    }

    self.param.myCurrentPath = self.param.tfy_Vertical?
    MAX(floor ((int)self.collectionContenOffset.y / self.collectionContenSize.height ), 0):
    MAX(floor((int)self.collectionContenOffset.x / self.collectionContenSize.width ), 0);

    self.param.overFactPath = self.param.tfy_Vertical?
           MAX(ceil ((int)self.collectionContenOffset.y / self.collectionContenSize.height ), 0):
           MAX(ceil((int)self.collectionContenOffset.x / self.collectionContenSize.width ), 0);
    NSInteger minVisibleIndex = MAX(self.param.myCurrentPath, 0);
    NSInteger contentOffset =  self.param.tfy_Vertical?
    self.collectionContenOffset.y:self.collectionContenOffset.x;
    NSInteger collectionBounds = self.param.tfy_Vertical?
    self.collectionContenSize.height:self.collectionContenSize.width;
    CGFloat offset = contentOffset % collectionBounds;
    CGFloat offsetProgress = offset / (self.param.tfy_Vertical?self.collectionContenSize.height:self.collectionContenSize.width)*1.0f;
    NSInteger maxVisibleIndex = MAX(MIN(itemsCount - 1, self.param.myCurrentPath + self.param.tfy_CardOverLapCount), minVisibleIndex);
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = minVisibleIndex; i<=maxVisibleIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [[self layoutAttributesForItemAtIndexPath:indexPath] copy];
           
        NSInteger visibleIndex = MAX(indexPath.item - self.param.myCurrentPath + 1, 0);
        attributes.size =  self.itemSize;
        CGFloat topCardMidX = self.param.tfy_Vertical?
        (self.collectionContenOffset.y +  self.collectionContenSize.height / 2):
        (self.collectionContenOffset.x +  self.collectionContenSize.width / 2);
        attributes.center = self.param.tfy_Vertical?
        CGPointMake(self.collectionContenSize.width/2, topCardMidX + self.param.tfy_LineSpacing * (visibleIndex - 1)):
        CGPointMake(topCardMidX + self.param.tfy_LineSpacing * (visibleIndex - 1), self.collectionContenSize.height/2);
        attributes.zIndex = 925457662 - visibleIndex;
        CGFloat scale = [self parallaxProgressForVisibleIndex:visibleIndex offsetProgress:offsetProgress minScale:self.param.tfy_ScaleFactor];
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
        if (visibleIndex == 1) {
            if (self.param.tfy_Vertical) {
                if (minVisibleIndex != maxVisibleIndex) {
                    if (self.collectionContenOffset.y >= 0) {
                        attributes.center = CGPointMake(attributes.center.x, attributes.center.y - offset);
                    }else{
                        attributes.center = CGPointMake(attributes.center.x , attributes.center.y + attributes.size.height * (1 - scale)/2 - self.param.tfy_LineSpacing * offsetProgress);
                    }
                }
            }else{
                if (minVisibleIndex != maxVisibleIndex) {
                    if (self.collectionContenOffset.x >= 0) {
                           attributes.center =  CGPointMake(attributes.center.x - offset, attributes.center.y);
                       }else{
                           attributes.center = CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - self.param.tfy_LineSpacing * offsetProgress, attributes.center.y);
                       }
                   }
               }
               if (self.param.tfy_CardOverAlphaOpen) {
                    attributes.alpha = MAX(1-offsetProgress, MAX(self.param.tfy_CardOverMinAlpha, 0));
               }
           }else if (visibleIndex == self.param.tfy_CardOverLapCount + 1){
               attributes.center = self.param.tfy_Vertical?
                    CGPointMake(attributes.center.x, attributes.center.y + attributes.size.height * (1 - scale)/2 - self.param.tfy_LineSpacing):
                    CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - self.param.tfy_LineSpacing, attributes.center.y);
                    if (self.param.tfy_CardOverAlphaOpen) {
                        attributes.alpha = MAX(offsetProgress, MAX(self.param.tfy_CardOverMinAlpha, 0));
                    }
           }else{
               attributes.center = self.param.tfy_Vertical?
                        CGPointMake(attributes.center.x , attributes.center.y + attributes.size.height * (1 - scale)/2 - self.param.tfy_LineSpacing * offsetProgress):
                        CGPointMake(attributes.center.x + attributes.size.width * (1 - scale)/2 - self.param.tfy_LineSpacing * offsetProgress, attributes.center.y);
              if (self.param.tfy_CardOverAlphaOpen) {
                 attributes.alpha = MAX(offsetProgress, MAX(self.param.tfy_CardOverMinAlpha*2, 0));
              }
           }
           [mArr addObject:attributes];
        }
    return mArr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGFloat)parallaxProgressForVisibleIndex:(NSInteger)visibleIndex
                         offsetProgress:(CGFloat)offsetProgress
                               minScale:(CGFloat)minScale
{
    CGFloat step = (1.0 - minScale) / (self.param.tfy_CardOverLapCount-1)*1.0;
    return (1.0 - (visibleIndex - 1) * step + step * offsetProgress);
}

- (CGSize)collectionContenSize{
     return CGSizeMake((int)self.collectionView.bounds.size.width, (int)self.collectionView.bounds.size.height);
}

- (CGPoint)collectionContenOffset{
    return CGPointMake((int)self.collectionView.contentOffset.x, (int)self.collectionView.contentOffset.y);
}

@end
