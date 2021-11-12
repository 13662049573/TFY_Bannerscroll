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
      .tfy_DataSet(@[
        @"http://p4.music.126.net/KBGimsi9Oyx10aZZM5_rkA==/18767563976515199.jpg?param=640y248",
        @"http://p4.music.126.net/DOUERTQqfwX40zHtGsCnWw==/18688399139301883.jpg?param=640y248",
        @"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248",
        @"http://p3.music.126.net/7lvZQAdwUktLAdUSCvWjmA==/18653214767235643.jpg?param=640y248",
        @"http://p3.music.126.net/nZCNbtXbzn0NieGZniBw9w==/18964376556159465.jpg?param=640y248",
        @"http://p4.music.126.net/w0gNUJQmI8vDTXDTsByOgA==/19041342370095071.jpg?param=640y248",
        @"http://p1.music.126.net/M3YaF1uVBhhX9yw1K3-kvQ==/18984167765277108.jpg?param=210y210"
        ])
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
