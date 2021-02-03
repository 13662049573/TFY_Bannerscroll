




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
      @{@"name":@"第0个",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg"},
      @{@"name":@"第1个",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg"},
      @{@"name":@"第2个",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg"},
      @{@"name":@"第3个",@"icon":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3425860897,3737508983&fm=26&gp=0.jpg"}

      ];
}


@end
