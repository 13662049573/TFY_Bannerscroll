//
//  DemoPageControl.m
//  WMZBanner
//
//  Created by wmz on 2019/12/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoPageControl.h"
@interface DemoPageControl ()

@end

@implementation DemoPageControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self styleDefault];
    [self styleOne];
    [self styleTwo];
    [self styleThree];
}

- (void)styleDefault{
    TFY_BannerParam *param =  paramModel()
    .tfy_BannerControlColorSet([UIColor lightGrayColor])
    .tfy_BannerControlSelectColorSet([UIColor orangeColor])
    .tfy_FrameSet(CGRectMake(10, 100, BannerWitdh-20, BannerHeight/6))
    .tfy_dataSet([self getData]);
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewOne];
}

- (void)styleOne{
      TFY_BannerParam *param =  paramModel()
      .tfy_BannerControlImageSet(@"bannerP1")
      .tfy_BannerControlSelectImageSet(@"bannerP2")
      .tfy_BannerControlImageSizeSet(CGSizeMake(8, 20))
      .tfy_BannerControlSelectImageSizeSet(CGSizeMake(20, 20))
       //调整间距
      .tfy_BannerControlSelectMarginSet(3)
      .tfy_BannerControlPositionSet(BannerControlRight)
      .tfy_FrameSet(CGRectMake(10, BannerHeight/3, BannerWitdh-20, BannerHeight/6))
      .tfy_dataSet([self getData]);
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
      [self.view addSubview:viewOne];
}

- (void)styleTwo{
      TFY_BannerParam *param =  paramModel()
      .tfy_FrameSet(CGRectMake(10, BannerHeight/2+20, BannerWitdh-20, BannerHeight/6))
      .tfy_BannerControlImageSet(@"bannerP3")
      .tfy_BannerControlSelectImageSet(@"bannerP4")
      .tfy_BannerControlImageSizeSet(CGSizeMake(14, 14))
      .tfy_BannerControlSelectImageSizeSet(CGSizeMake(14, 14))
      .tfy_BannerControlPositionSet(BannerControlLeft)
      .tfy_dataSet([self getData]);
      TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
      [self.view addSubview:viewOne];
}

- (void)styleThree{
      TFY_BannerParam *param =  paramModel()
      .tfy_FrameSet(CGRectMake(10, BannerHeight*0.7+20, BannerWitdh-20, BannerHeight/6))
      .tfy_BannerControlImageSet(@"bannerP3")
      .tfy_BannerControlSelectImageSet(@"bannerP2")
      .tfy_BannerControlImageSizeSet(CGSizeMake(10, 10))
      .tfy_BannerControlSelectImageSizeSet(CGSizeMake(30, 30))
      //自定义pageControl的位置
      .tfy_CustomControlSet(^(UIPageControl *pageControl) {
          //随意改变xy值
          CGRect rect = pageControl.frame;
          rect.origin.y =  10;
          pageControl.frame = rect;
      })
      .tfy_dataSet([self getData]);
      TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
      [self.view addSubview:viewOne];
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
