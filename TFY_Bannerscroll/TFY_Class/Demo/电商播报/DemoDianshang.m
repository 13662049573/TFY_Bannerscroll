




//
//  DemoDianshang.m
//  WMZBanner
//
//  Created by wmz on 2019/12/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoDianshang.h"
#import "marqueCell.h"
#import "KuaiBaoCell.h"
@interface DemoDianshang ()

@end

@implementation DemoDianshang

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BannerColor(0xeeeeee);

    [self demoTwo];
    [self demoThree];

}


- (void)demoTwo{
    
    NSArray *data = @[
        @{@"name":@"五千万人都在玩的天猫农场",@"detail":@"快去领取>>"},
        @{@"name":@"主人,你的阳光要被偷啦",@"detail":@"快去领取>>"},
        @{@"name":@"免费兑换水果",@"detail":@"立即领取>>"},
        @{@"name":@"免费兑换红包",@"detail":@"快去领取>>"},
    ];
    
    TFY_BannerParam *param =  paramModel()
    .tfy_FrameSet(CGRectMake(10, BannerHeight/4+60, BannerWitdh-20, 50))
    .tfy_MyCellClassNameSet(@"marqueCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        marqueCell *cell = (marqueCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([marqueCell class]) forIndexPath:indexPath];
        cell.label.text = model[@"name"];
        [cell.detailBtn setTitle:model[@"detail"] forState:UIControlStateNormal];
        return cell;
    })
    .tfy_dataSet(data)
    //关闭手指滑动
    .tfy_CanFingerSlidingSet(NO)
    .tfy_HideBannerControlSet(YES)
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewMarque = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewMarque];
}

- (void)demoThree{
    NSArray *data = @[
        @{@"name":@"谁说的手动手动手动手动搜得到 手动手动手动",@"detail":@"最新"},
        @{@"name":@"麒麟880已经玩脱了，马上属于5g",@"detail":@"热门"},
        @{@"name":@"华为年底拼了,p30",@"detail":@"推荐"},
        @{@"name":@"画质慢,强大的配置",@"detail":@"HOT"},
    ];
    
    TFY_BannerParam *param =  paramModel()
    .tfy_FrameSet(CGRectMake(10, BannerHeight/4+140, BannerWitdh-20, 50))
    .tfy_MyCellClassNameSet(@"KuaiBaoCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        KuaiBaoCell *cell = (KuaiBaoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KuaiBaoCell class]) forIndexPath:indexPath];
        cell.label.text = model[@"detail"];
        cell.detailBtn.text = model[@"name"];
        return cell;
    })
    .tfy_dataSet(data)
    //关闭手指滑动
    .tfy_CanFingerSlidingSet(NO)
    .tfy_HideBannerControlSet(YES)
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewMarque = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewMarque];
    

}

@end
