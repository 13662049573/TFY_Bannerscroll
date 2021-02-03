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
        [cell.icon tfy_setImageWithURL:model[@"icon"]];
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
       [cell.icon tfy_setImageWithURL:model[@"icon"]];
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
   ;
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
        [cell.icon tfy_setImageWithURL:model[@"icon"]];
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
      @{@"name":@"自定义文本1",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg"},
      @{@"name":@"自定义文本2",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg"},
      @{@"name":@"自定义文本3",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg"},
      @{@"name":@"自定义文本4",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744174216&di=36ffb42bf8757df08455b34c6b7d66c5&imgtype=0&src=http%3A%2F%2Fwww.7dapei.com%2Fimages%2F201203c%2F119.3.jpg"},
    
      @{@"name":@"自定义文本1",@"icon":@"http://img12.360buyimg.com/piao/jfs/t2743/132/3170930521/77809/42cfd6d4/57836e27N06956fd3.jpg"},
      @{@"name":@"自定义文本2",@"icon":@"http://photos.tuchong.com/285606/f/4374153.jpg"},
      @{@"name":@"自定义文本3",@"icon":@"http://img5.cache.netease.com/photo/0003/2012-06-21/84G462VS51GQ0003.jpg"},
      @{@"name":@"自定义文本4",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564463770360&di=c93e799328198337ed68c61381bcd0be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170714%2F1eed483f1874437990ad84c50ecfc82a_th.jpg"},
       @{@"name":@"自定义文本4",@"icon":@"http://i2.hdslb.com/bfs/archive/1c471796343e34a8613518cc0d393792680a1022.jpg"}
      ];
}
@end
