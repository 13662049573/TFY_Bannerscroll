
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
    .tfy_FrameSet(CGRectMake(-45,60, BannerWitdh+45, BannerHeight*0.35))
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh-60, BannerHeight*0.25))
    .tfy_DataSet([self getData])
    //设置item的间距
    .tfy_LineSpacingSet(15)
    //开启卡片叠加模式
    .tfy_CardOverLapSet(CardtypeFallen)
    //毛玻璃背景
    .tfy_EffectSet(YES)
    //开启自动滚动
    .tfy_AutoScrollSet(YES)
    .tfy_EffectStyleSet(UIBlurEffectStyleDark)//毛玻璃类型
    .tfy_EffectAlphaSet(0.5);
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
    .tfy_CardOverLapSet(CardtypeFallen)
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
