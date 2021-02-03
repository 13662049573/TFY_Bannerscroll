//
//  demoNormal.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "demoNormal.h"

#define gif @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564463770360&di=c93e799328198337ed68c61381bcd0be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170714%2F1eed483f1874437990ad84c50ecfc82a_th.jpg"


#define gif2 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579085817466&di=0c1cba2b5dba938cd33ea7d053b1493a&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Flarge%2F85cc5ccbgy1ffngbkq2c9g20b206k78d.jpg"

#define tu1 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579082232413&di=2775dc6e781e712d518bf1cf7a1e675e&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fnote%2Fl%2Fpublic%2Fp41813904.jpg"

#define tu2 @"http://photos.tuchong.com/285606/f/4374153.jpg"

#define tu3 @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fgss0.baidu.com%2F-4o3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2Ff636afc379310a558f3f592dbb4543a9832610cb.jpg&refer=http%3A%2F%2Fgss0.baidu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614246801&t=096f32d80f2f04110b4bddde27f2165e"

#define tu4 @"https://tfile.melinked.com/2021/01/5c071de1-b7e9-4bf4-a1f7-a2f35eff9ed6.jpg"

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
    .tfy_AutoScrollSet(YES)
    //开启纵向
    .tfy_VerticalSet(YES);
    TFY_BannerView *viewTwo = [[TFY_BannerView alloc]initConfigureWithModel:param1];
    [self.view addSubview:viewTwo];
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
        .tfy_AutoScrollSecondSet(1.5)
        .tfy_ItemSizeSet(CGSizeMake(BannerWitdh/2, BannerWitdh/3))//item的size default 视图的宽高 item的width最小为父视图的一半 (为了保证同屏最多显示3个 减少不必要的bug)
        .tfy_HideBannerControlSet(YES);
    }
    return _bannerParam;
}


- (NSArray*)getData{
    return @[
        @"http://photos.tuchong.com/285606/f/4374153.jpg",
        gif,
        tu1,
        gif2,
        tu2,
        tu3,
        tu4,
      @"http://i2.hdslb.com/bfs/archive/1c471796343e34a8613518cc0d393792680a1022.jpg",@"01",@"02",@"03",@"04",@"05"
      ];
}

@end
