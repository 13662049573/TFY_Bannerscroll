//
//  DemoCard.m
//  WMZBanner
//
//  Created by wmz on 2019/12/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoCard.h"
#import "MyCell.h"
@interface DemoCard ()

@end

@implementation DemoCard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demoOne];
    [self demoTwo];
    [self demoThree];
}

- (void)demoOne{
    TFY_BannerParam *param =paramModel()
    //自定义视图必传
    .tfy_MyCellClassNamesSet(@"MyCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCell class]) forIndexPath:indexPath];
        cell.leftText.text = model[@"name"];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
        return cell;
    })
    .tfy_FrameSet(CGRectMake(0, 40, BannerWitdh, BannerHeight*0.2))
    .tfy_DataSet([self getData])
    //关闭pageControl
    .tfy_HideBannerControlSet(YES)
    //开启缩放
    .tfy_ScaleSet(YES)
    //自定义item的大小
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh*0.55, BannerHeight*0.2))
    //固定移动的距离
    .tfy_ContentOffsetXSet(0.5)
    //循环
    .tfy_RepeatSet(YES)
    //自动滚动
    .tfy_AutoScrollSet(YES)
    //整体左右间距  设置为size.width的一半 让最后一个可以居中
    .tfy_SectionInsetSet(UIEdgeInsetsMake(0,10, 0, BannerWitdh*0.55*0.3))
    //间距
    .tfy_LineSpacingSet(20)
    //开启背景毛玻璃
    .tfy_EffectSet(YES)
    .tfy_PositionSet(BannerCellPositionBottom);
    
    TFY_BannerView *bannerView = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:bannerView];
}

- (void)demoTwo{
    TFY_BannerParam *param =paramModel()
   //自定义视图必传
   .tfy_MyCellClassNamesSet(@"MyCell")
   .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
              //自定义视图
       MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCell class]) forIndexPath:indexPath];
       cell.leftText.text = model[@"name"];
       [cell.icon sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
       return cell;
   })
   .tfy_FrameSet(CGRectMake(0, BannerHeight*0.2+70, BannerWitdh, BannerHeight*0.2))
   .tfy_DataSet([self getData])
   //关闭pageControl
   .tfy_HideBannerControlSet(YES)
   //自定义item的大小
   .tfy_ItemSizeSet(CGSizeMake(BannerWitdh*0.55, BannerHeight*0.2))
   //固定移动的距离
   .tfy_ContentOffsetXSet(0.5)
    .tfy_AutoScrollSecondSet(4)
   //自动滚动
   .tfy_AutoScrollSet(YES)
    //循环
    .tfy_RepeatSet(YES)
    
   //整体左右间距  设置为size.width的一半 让最后一个可以居中
   .tfy_SectionInsetSet(UIEdgeInsetsMake(0,20, 0, BannerWitdh*0.55*0.3))
   //间距
   .tfy_LineSpacingSet(20)
   .tfy_PositionSet(BannerCellPositionTop);
    
   TFY_BannerView *bannerView = [[TFY_BannerView alloc]initConfigureWithModel:param];
   [self.view addSubview:bannerView];
}

- (void)demoThree{
     TFY_BannerParam *param =paramModel()
    //自定义视图必传
    .tfy_MyCellClassNamesSet(@"MyCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCell class]) forIndexPath:indexPath];
        cell.leftText.text = model[@"name"];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
        return cell;
    })
    .tfy_FrameSet(CGRectMake(0, BannerHeight*0.55, BannerWitdh, BannerHeight*0.2))
    .tfy_DataSet([self getData])
    //关闭pageControl
    .tfy_HideBannerControlSet(YES)
    //开启缩放
    .tfy_ScaleSet(YES)
    .tfy_AutoScrollSecondSet(5)
    //自定义item的大小
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh*0.2-10, BannerHeight*0.2))
    //固定移动的距离
    .tfy_ContentOffsetXSet(0.5)
     //循环
     .tfy_RepeatSet(YES)
    .tfy_AutoScrollSet(YES)
    //整体左右间距  设置为size.width的一半 让最后一个可以居中
    .tfy_SectionInsetSet(UIEdgeInsetsMake(0,10, 0, BannerWitdh*0.55*0.3))
    //间距
    .tfy_LineSpacingSet(10)
    .tfy_ClickCenterSet(YES);
    
    TFY_BannerView *bannerView = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:bannerView];
}
- (NSArray*)getData{
    return @[
      @{@"name":@"自定义文本1",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本2",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本3",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    
      @{@"name":@"自定义文本1",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本2",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本3",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
       @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"}
      ];
}
@end
