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
    .tfy_DataSet(@[@"01",@"02",@"03",@"04",@"05"])
    .tfy_AutoScrollSet(YES)
    .tfy_RepeatSet(YES)
    .tfy_AutoScrollSecondSet(1)
    .tfy_FrameSet(CGRectMake(10, 0, BannerWitdh-20, BannerHeight*0.2))
    .tfy_CustomControlSet(^(TFY_BannerPageControl *pageControl) {
        pageControl.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
        pageControl.pageControlType = PageControlTypeCircle;
        pageControl.pageSizeWidth = 15.0;
        pageControl.pageSizeHeight = 15.0;
        pageControl.pageIndicatorColor = [UIColor yellowColor];
        pageControl.currentPageIndicatorColor = [UIColor redColor];
        pageControl.transformScale = 1.5;
        pageControl.showPageNumber = YES;
        pageControl.pageNumberColor = [UIColor blackColor];
        pageControl.pageNumberFont = [UIFont systemFontOfSize:8.0];
        pageControl.currentPageNumberColor = [UIColor yellowColor];
        pageControl.currentPageNumberFont = [UIFont boldSystemFontOfSize:9.0];
    });
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
    [self.view addSubview:viewOne];
   
}

- (void)styleOne{
      TFY_BannerParam *param =  paramModel()
      .tfy_FrameSet(CGRectMake(10, BannerHeight*0.2 + 10, BannerWitdh-20, BannerHeight*0.2))
      .tfy_DataSet([self getData])
    .tfy_AutoScrollSet(YES)
    .tfy_RepeatSet(YES)
    .tfy_AutoScrollSecondSet(2)
    .tfy_CustomControlSet(^(TFY_BannerPageControl *pageControl) {
        pageControl.pageControlType = PageControlTypeLine;
        pageControl.pageMargin = 3.0;
        pageControl.pageIndicatorColor = [UIColor orangeColor];
        pageControl.currentPageIndicatorColor = [UIColor blackColor];
    });
    TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
      [self.view addSubview:viewOne];
   
}

- (void)styleTwo{
      TFY_BannerParam *param =  paramModel()
      .tfy_FrameSet(CGRectMake(10,BannerHeight*0.4 + 20, BannerWitdh-20, BannerHeight*0.2))
      .tfy_DataSet([self getData])
    .tfy_AutoScrollSet(YES)
    .tfy_RepeatSet(YES)
    .tfy_AutoScrollSecondSet(3)
    .tfy_CustomControlSet(^(TFY_BannerPageControl *pageControl) {
        pageControl.pageControlType = PageControlTypeImage;
        pageControl.pageMargin = 5.0;
        pageControl.pageSizeWidth = 20.0;
        pageControl.pageSizeHeight = 20.0;
        pageControl.shouldAutoresizingImage = YES;
        pageControl.pageIndicatorImage = [UIImage imageNamed:@"a"];
        pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"a-h"];
        pageControl.transformScale = 1.2;
    });
      TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
      [self.view addSubview:viewOne];
   
}

- (void)styleThree{
      TFY_BannerParam *param =  paramModel()
      .tfy_FrameSet(CGRectMake(10, BannerHeight*0.6 + 30, BannerWitdh-20,BannerHeight*0.2))
      .tfy_DataSet(@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg"])
    .tfy_AutoScrollSet(YES)
    .tfy_RepeatSet(YES)
    .tfy_AutoScrollSecondSet(4)
    .tfy_CustomControlSet(^(TFY_BannerPageControl *pageControl) {
        pageControl.pageIndicatorColor = [UIColor greenColor];
        pageControl.currentPageIndicatorColor = [UIColor purpleColor];
        pageControl.pageSizeWidth = 10.0;
        pageControl.pageSizeHeight = 10.0;
        pageControl.transformScale = 1.5;
        pageControl.pageControlAlignment = PageControlAlignmentRight;
    });
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
