


//
//  DemoMarqueen.m
//  WMZBanner
//
//  Created by wmz on 2019/12/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoMarqueen.h"

@interface DemoMarqueen ()

@end

@implementation DemoMarqueen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
     /*
      *横向
      */
     TFY_BannerParam *param =  paramModel()
     .tfy_FrameSet(CGRectMake(0, BannerHeight/6, BannerWitdh,125))
     .tfy_DataSet([self getData])
     .tfy_ItemSizeSet(CGSizeMake(116, 125))
    //开启跑马灯
     .tfy_MarqueeSet(YES)
     //开启循环滚动
     .tfy_RepeatSet(YES)
     //设置item的间距
     .tfy_LineSpacingSet(10);
    
     TFY_BannerView *viewOne = [[TFY_BannerView alloc]initConfigureWithModel:param];
     [self.view addSubview:viewOne];
    
    
     /*
      *纵向
      */
     TFY_BannerParam *param1 =  paramModel()
     .tfy_FrameSet(CGRectMake(10, BannerHeight/2, BannerWitdh-20, BannerHeight/4))
     .tfy_DataSet([self getData])

    .tfy_CanFingerSlidingSet(NO)
    
    .tfy_MarqueeSet(YES)
    //开启循环滚动
    .tfy_RepeatSet(YES)
    
    .tfy_HideBannerControlSet(YES)
    .tfy_VerticalSet(YES)
    
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh, 100))
    //固定移动的距离
   .tfy_LineSpacingSet(20);
    
     TFY_BannerView *viewOne1 = [[TFY_BannerView alloc]initConfigureWithModel:param1];
     [self.view addSubview:viewOne1];
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
