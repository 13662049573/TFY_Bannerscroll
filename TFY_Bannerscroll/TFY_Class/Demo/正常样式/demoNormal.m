//
//  demoNormal.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "demoNormal.h"
@interface demoNormal ()

@end

@implementation demoNormal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    /*
     *横向
     */
    TFY_BannerParam *param =  paramModel()
    .tfy_FrameSet(CGRectMake(0, BannerHeight/6, BannerWitdh, BannerWitdh/3))
    .tfy_DataSet([self getData])
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //设置item的间距
    .tfy_LineSpacingSet(10)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    //自动滚动时间
    .tfy_AutoScrollSecondSet(3)
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh/2, BannerWitdh/3))//item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)
    .tfy_HideBannerControlSet(YES);
    
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewOne];
    
    
    
    
    
    /*
     *纵向
     */
    TFY_BannerParam *param1 =  paramModel()
    .tfy_FrameSet(CGRectMake(10, BannerHeight/2, BannerWitdh-20, BannerHeight/4))
    .tfy_DataSet([self getData])
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    //开启纵向
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewTwo = [[TFY_BannerView alloc]initConfigureWithModel:param1];
    [self.view addSubview:viewTwo];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
}


- (NSArray*)getData{
    return @[
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg",
      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744174216&di=36ffb42bf8757df08455b34c6b7d66c5&imgtype=0&src=http%3A%2F%2Fwww.7dapei.com%2Fimages%2F201203c%2F119.3.jpg",
      @"http://img12.360buyimg.com/piao/jfs/t2743/132/3170930521/77809/42cfd6d4/57836e27N06956fd3.jpg",
      @"http://photos.tuchong.com/285606/f/4374153.jpg",
      @"http://img5.cache.netease.com/photo/0003/2012-06-21/84G462VS51GQ0003.jpg",
      @"http://i2.hdslb.com/bfs/archive/1c471796343e34a8613518cc0d393792680a1022.jpg",@"01",@"02",@"03",@"04",@"05"
      ];
}

@end
