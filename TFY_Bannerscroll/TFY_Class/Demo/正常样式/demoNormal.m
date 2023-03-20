//
//  demoNormal.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "demoNormal.h"

@interface demoNormal ()
@property(nonatomic , strong)TFY_BannerView *bannerScrollerView;
@property(nonatomic , strong)TFY_BannerParam *bannerParam;
@end

@implementation demoNormal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     *横向
     */
    [self.view addSubview:self.bannerScrollerView];
    
    /*
     *纵向
     */
    TFY_BannerParam *param1 =  paramModel()
    .tfy_FrameSet(CGRectMake(10, BannerHeight/2, BannerWitdh-20, BannerHeight/4))
    .tfy_DataSet([self getData])
    //开启循环滚动
    .tfy_RepeatSet(YES)
    //开启自动滚动
//    .tfy_AutoScrollSet(YES)
    //开启纵向
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewTwo = [[TFY_BannerView alloc]initConfigureWithModel:param1];
    [self.view addSubview:viewTwo];
    self.bannerScrollerView = viewTwo;
}

- (TFY_BannerView *)bannerScrollerView {
    if (!_bannerScrollerView) {
        _bannerScrollerView = [[TFY_BannerView alloc] initConfigureWithModel:self.bannerParam];
    }
    return _bannerScrollerView;
}

- (TFY_BannerParam *)bannerParam {
    if (!_bannerParam) {
        _bannerParam = paramModel();
        _bannerParam
        .tfy_FrameSet(CGRectMake(0, BannerHeight/6, BannerWitdh, BannerWitdh/3))
        .tfy_DataSet([self getData])
        //开启循环滚动
        .tfy_RepeatSet(YES)
        //设置item的间距
        .tfy_LineSpacingSet(10)
        //开启自动滚动
        .tfy_AutoScrollSet(YES)
        //自动滚动时间
        .tfy_AutoScrollSecondSet(6)
        .tfy_ItemSizeSet(CGSizeMake(BannerWitdh/2, BannerWitdh/3))//item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)
        .tfy_HideBannerControlSet(YES);
    }
    return _bannerParam;
}


- (NSArray*)getData{
    NSString *url = [@"https://tj-data-bak-to-test20221028.oss-cn-hangzhou.aliyuncs.com/uploadFiles/images/app/banner/浙大妙智康宣传片.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    return @[
        url,
        @"http://dl.w.xk.miui.com/c64aea3266d6f8e777aa659152a22a73.720p.mp4",
        @"https://media.giphy.com/media/12FparngCjPtC0/giphy.gif",
        @"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248",
      ];
}

@end
