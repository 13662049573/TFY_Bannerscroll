//
//  DemoTianMao.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoTianMao.h"
#import "TianMaoCell.h"
@interface DemoTianMao ()
@property(nonatomic,strong)TFY_BannerView *bannerView;
@end

@implementation DemoTianMao

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TFY_BannerParam *param = paramModel()
    //自定义视图必传
    .tfy_MyCellClassNamesSet(@"TianMaoCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        TianMaoCell *cell = (TianMaoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TianMaoCell class]) forIndexPath:indexPath];
        cell.titleLa.text = model[@"name"];
        cell.topLa.backgroundColor = model[@"color"];
        cell.bottomView.backgroundColor = model[@"color"];
        [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
        return cell;
    })
    .tfy_FrameSet(CGRectMake(0, BannerHeight*0.3, BannerWitdh, BannerHeight*0.4))
    .tfy_DataSet([self getData])
    //关闭pageControl
    .tfy_HideBannerControlSet(YES)
    .tfy_SelectIndexSet(2)
    //开启缩放
    .tfy_ScaleSet(YES)
    //自定义item的大小
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh*0.55, BannerHeight*0.4))
    //固定移动的距离
    .tfy_ContentOffsetXSet(0.32)
    //循环
    .tfy_RepeatSet(YES)
    //毛玻璃背景的高度系数
    .tfy_EffectHeightSet(0.8)
    //自动滚动
    .tfy_AutoScrollSet(YES)
    //整体左右间距  设置为size.width的一半 让最后一个可以居中
    .tfy_SectionInsetSet(UIEdgeInsetsMake(0,10, 0, BannerWitdh*0.55*0.3))
    //间距
    .tfy_LineSpacingSet(10)
    //开启背景毛玻璃
    .tfy_EffectSet(YES);
    self.bannerView = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:self.bannerView];
}

- (NSArray*)getData{
    return @[
      @{
          @"name":@"天猫精灵,每天晚安闹钟1",
          @"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"
              , @"color":BannerColor(0x035eef)
      },
      @{
          @"name":@"天猫精灵,每天晚安闹钟3",
        @"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248",
      @"color":BannerColor(0x00D762)},
      @{
          @"name":@"天猫精灵,每天晚安闹钟3",
        @"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248",
          @"color":BannerColor(0xD41B14)},
      @{
          @"name":@"天猫精灵,每天晚安闹钟4",
        @"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"
          ,@"color":BannerColor(0xF5DE95)
      }
      ];
}


- (void)dealloc{
    
}

@end
