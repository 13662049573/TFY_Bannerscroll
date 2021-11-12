




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

    [self styleOne];
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
    .tfy_FrameSet(CGRectMake(10, BannerHeight/4+80, BannerWitdh-20, 50))
    .tfy_MyCellClassNamesSet(@"marqueCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        marqueCell *cell = (marqueCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([marqueCell class]) forIndexPath:indexPath];
        cell.label.text = model[@"name"];
        [cell.detailBtn setTitle:model[@"detail"] forState:UIControlStateNormal];
        return cell;
    })
    .tfy_DataSet(data)
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
    .tfy_FrameSet(CGRectMake(10, BannerHeight/4+150, BannerWitdh-20, 50))
    .tfy_MyCellClassNamesSet(@"KuaiBaoCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
               //自定义视图
        KuaiBaoCell *cell = (KuaiBaoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KuaiBaoCell class]) forIndexPath:indexPath];
        cell.label.text = model[@"detail"];
        cell.detailBtn.text = model[@"name"];
        return cell;
    })
    .tfy_DataSet(data)
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

- (void)styleOne{
    TFY_BannerParam *param =  paramModel()
    .tfy_FrameSet(CGRectMake(10,30, BannerWitdh-20, BannerHeight*0.25))
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh-20, BannerHeight*0.23))
    .tfy_DataSet([self getData])
    //自定义下划线
    .tfy_SpecialCustumLineSet(^(UIView *line) {
        line.frame = CGRectMake(0, 0, 100, 3);
        line.backgroundColor = [UIColor purpleColor];
    })
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    .tfy_HideBannerControlSet(YES)
    .tfy_SpecialStyleSet(SpecialStyleLine);
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewOne];
    
}

- (NSArray*)getData{
    return @[
      @"http://p4.music.126.net/KBGimsi9Oyx10aZZM5_rkA==/18767563976515199.jpg?param=640y248",
      @"http://p4.music.126.net/DOUERTQqfwX40zHtGsCnWw==/18688399139301883.jpg?param=640y248",
      @"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248",
      @"http://p3.music.126.net/7lvZQAdwUktLAdUSCvWjmA==/18653214767235643.jpg?param=640y248",
      @"http://p3.music.126.net/nZCNbtXbzn0NieGZniBw9w==/18964376556159465.jpg?param=640y248",
      @"http://p4.music.126.net/w0gNUJQmI8vDTXDTsByOgA==/19041342370095071.jpg?param=640y248",
      @"http://p1.music.126.net/M3YaF1uVBhhX9yw1K3-kvQ==/18984167765277108.jpg?param=210y210"
      ];
}


@end
