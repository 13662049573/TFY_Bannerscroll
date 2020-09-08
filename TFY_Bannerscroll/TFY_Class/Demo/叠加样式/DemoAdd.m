
//
//  DemoAdd.m
//  WMZBanner
//
//  Created by wmz on 2019/12/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoAdd.h"

@interface DemoAdd ()

@end

@implementation DemoAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /*
     *横向
     */
    TFY_BannerParam *param =  paramModel()
    .tfy_FrameSet(CGRectMake(10,100, BannerWitdh-20, BannerHeight*0.35))
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh-60, BannerHeight*0.25))
    .tfy_DataSet([self getData])
    //设置item的间距
    .tfy_LineSpacingSet(15)
    //开启卡片叠加模式
    .tfy_CardOverLapSet(YES)
    //毛玻璃背景
    .tfy_EffectSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES);
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewOne];


    

    /*
    *纵向
    */
     TFY_BannerParam *param1 =paramModel()
    .tfy_EventScrollEndSet(^(id anyID, NSInteger index, BOOL isCenter, UICollectionViewCell *cell) {
        NSLog(@"%ld",index);
    })
    .tfy_FrameSet(CGRectMake(10,  CGRectGetMaxY(viewOne.frame)+30 , BannerWitdh-20, BannerHeight*0.35))
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh/2, BannerHeight*0.3))
    .tfy_DataSet([self getData])
    .tfy_HideBannerControlSet(YES)
    //设置item的间距
    .tfy_LineSpacingSet(15)
    //开启卡片叠加模式
    .tfy_CardOverLapSet(YES)
//    //开启自动滚动
//    .tfy_AutoScrollSet(YES)
    //缩放系数
    .tfy_ScaleFactorSet(0.7)
    //开启纵向
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewTwo = [[TFY_BannerView alloc]initConfigureWithModel:param1];
    [self.view addSubview:viewTwo];
    
}

- (NSArray*)getData{
    return @[
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744174216&di=36ffb42bf8757df08455b34c6b7d66c5&imgtype=0&src=http%3A%2F%2Fwww.7dapei.com%2Fimages%2F201203c%2F119.3.jpg"
      ];
}


@end
