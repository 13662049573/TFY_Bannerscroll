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
    .tfy_MyCellClassNameSet(@"TianMaoCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        TianMaoCell *cell = (TianMaoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TianMaoCell class]) forIndexPath:indexPath];
        cell.titleLa.text = model[@"name"];
        cell.topLa.backgroundColor = model[@"color"];
        cell.bottomView.backgroundColor = model[@"color"];
        [cell.backImage tfy_setImage:[NSURL URLWithString:model[@"icon"]]];
        return cell;
    })
    .tfy_FrameSet(CGRectMake(0, BannerHeight*0.3, BannerWitdh, BannerHeight*0.4))
    .tfy_dataSet([self getData])
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
          @"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052339&di=92f3a70f4a5a52a5a3d2038e1442d2b7&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01fd035c626614a801203d2261c846.jpg%401280w_1l_2o_100sh.jpg"
              , @"color":BannerColor(0x035eef)
      },
      @{
          @"name":@"天猫精灵,每天晚安闹钟3",
        @"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052339&di=9b3a0de1a35a502272c5d2c0788a2e55&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn10%2F266%2Fw640h426%2F20180321%2F97f6-fyskeue0515269.jpg",
      @"color":BannerColor(0x00D762)},
      @{
          @"name":@"天猫精灵,每天晚安闹钟3",
        @"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052338&di=9b686119c43280dccc0e523e3533a2b2&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2F19%2F1934%2F193450%2F19345029_1200x1000_0.jpg",
          @"color":BannerColor(0xD41B14)},
      @{
          @"name":@"天猫精灵,每天晚安闹钟4",
        @"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052336&di=6c5774392c54591c03ff4f6587c75848&imgtype=0&src=http%3A%2F%2Fimg.265g.com%2Fuserup%2F1111%2F201111071016446505.jpg"
          ,@"color":BannerColor(0xF5DE95)
      }
      ];
}


- (void)dealloc{
    
}

@end
