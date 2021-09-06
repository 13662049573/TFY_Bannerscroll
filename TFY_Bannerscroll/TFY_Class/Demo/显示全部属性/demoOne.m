//
//  demoOne.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "demoOne.h"
#import "MyCell.h"

#define gif @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564463770360&di=c93e799328198337ed68c61381bcd0be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170714%2F1eed483f1874437990ad84c50ecfc82a_th.jpg"


#define gif2 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579085817466&di=0c1cba2b5dba938cd33ea7d053b1493a&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Flarge%2F85cc5ccbgy1ffngbkq2c9g20b206k78d.jpg"

#define tu1 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579082232413&di=2775dc6e781e712d518bf1cf7a1e675e&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fnote%2Fl%2Fpublic%2Fp41813904.jpg"

#define tu2 @"http://photos.tuchong.com/285606/f/4374153.jpg"

#define tu3 @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fgss0.baidu.com%2F-4o3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2Ff636afc379310a558f3f592dbb4543a9832610cb.jpg&refer=http%3A%2F%2Fgss0.baidu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614246801&t=096f32d80f2f04110b4bddde27f2165e"

#define tu4 @"https://tfile.melinked.com/2021/01/5c071de1-b7e9-4bf4-a1f7-a2f35eff9ed6.jpg"


@interface demoOne ()
@property(nonatomic,strong)TFY_BannerView *viewOne;
@property(nonatomic,strong)TFY_BannerParam *param;

@end

@implementation demoOne


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"更新数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(updata) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn sizeToFit]; 
    self.navigationItem.rightBarButtonItem = barItem;

    
    BannerWeakSelf(self);
    self.param =paramModel()
    //自定义pageControl的位置
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
    })
    //自定义视图必传
    .tfy_MyCellClassNamesSet(@"MyCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
        MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCell class]) forIndexPath:indexPath];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]]];
        cell.leftText.text = model[@"name"];
        return cell;
    })
    .tfy_EventClickSet(^(id anyID, NSInteger index) {
        NSLog(@"点击 %@ %ld",anyID,(long)index);
    })
    .tfy_EventCenterClickSet(^(id anyID, NSInteger index,BOOL isCenter,UICollectionViewCell *cell) {
        NSLog(@"判断居中点击");
    })
    .tfy_EventScrollEndSet( ^(id anyID, NSInteger index, BOOL isCenter,UICollectionViewCell *cell) {
        //毛玻璃效果外部调整
         BannerStrongSelf(weakObject)
        [strongObject.viewOne.bgImgView sd_setImageWithURL:[NSURL URLWithString:anyID[@"icon"]]];
    })
    //图片对应的key值
    .tfy_DataParamIconNameSet(@"icon")
    .tfy_FrameSet(CGRectMake(0, BannerHeight/3, BannerWitdh, BannerHeight/3))
    //图片铺满
    .tfy_ImageFillSet(YES)
    //item间距
    .tfy_LineSpacingSet(10)
    //开启缩放
    .tfy_ScaleSet(YES)
    //毛玻璃效果
    .tfy_EffectSet(YES)
    //毛玻璃背景的高度系数
    .tfy_EffectHeightSet(1)
    //缩放垂直间距
    .tfy_ActiveDistanceSet(400)
    //缩放系数
    .tfy_ScaleFactorSet(0.2)
    //item的size
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh - 40, BannerHeight/3))
    //滑动固定偏移距离 itemSize.width*倍数
    .tfy_ContentOffsetXSet(0.5)
    //默认滑动到第index个
    .tfy_SelectIndexSet(0)
    //循环滚动
    .tfy_RepeatSet(YES)
    //自动滚动时间
    .tfy_AutoScrollSecondSet(3)
    //自动滚动
    .tfy_AutoScrollSet(YES)
    //卡片叠加模式
    .tfy_CardOverLapSet(CardtypeCommon)
    //cell的位置
    .tfy_PositionSet(BannerCellPositionCenter)
    //隐藏分页按钮
    .tfy_HideBannerControlSet(NO)
    //能否拖动
    .tfy_CanFingerSlidingSet(YES)
    //整体缩小
    .tfy_ScreenScaleSet(1)
    //左右半透明 中间不透明
    .tfy_AlphaSet(0.5)
    //开启跑马灯效果
    .tfy_MarqueeSet(NO)
    //跑马灯速度
    .tfy_MarqueeRateSet(5)
    //开启纵向
    .tfy_VerticalSet(NO)
    //左右偏移 让第一个和最后一个可以居中
    .tfy_SectionInsetSet(UIEdgeInsetsMake(0,BannerWitdh*0.25, 0, BannerWitdh*0.25))
    //数据源
    .tfy_DataSet([self getData]);
    
    self.viewOne = [[TFY_BannerView alloc]initConfigureWithModel:self.param withView:self.view];
}


//更新数据
- (void)updata{//02
    self.param.tfy_DataSet(@[
    @{@"name":@"自定义文本11",@"icon":gif},
    @{@"name":@"自定义文本22",@"icon":gif2},
    @{@"name":@"自定义文本33",@"icon":tu1},
    @{@"name":@"自定义文本44",@"icon":tu2},
    @{@"name":@"自定义文本44",@"icon":tu3},
    @{@"name":@"自定义文本44",@"icon":@"http://photos.tuchong.com/285606/f/4374153.jpg"},
    ]);
    [self.viewOne updateUI];
}

- (NSArray*)getData{
    return @[
      @{@"name":@"自定义文本11",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052334&di=47c55150e39ee4e13f52c2a2d60e3249&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn%2Fw800h450%2F20171207%2F9641-fypnsin6729109.jpg"},
      @{@"name":@"自定义文本22",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501100534&di=59ea2b526bd9050cd0e606be63ca1235&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20110%2F82%2Fw1080h602%2F20191105%2F3093-ihyxcrp3886394.jpg"},
  @{@"name":@"自定义文本1",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg"},
      @{@"name":@"自定义文本2",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg"},
      @{@"name":@"自定义文本3",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg"},
      @{@"name":@"自定义文本4",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744174216&di=36ffb42bf8757df08455b34c6b7d66c5&imgtype=0&src=http%3A%2F%2Fwww.7dapei.com%2Fimages%2F201203c%2F119.3.jpg"},
      @{@"name":@"自定义文本1",@"icon":@"http://img12.360buyimg.com/piao/jfs/t2743/132/3170930521/77809/42cfd6d4/57836e27N06956fd3.jpg"},
      @{@"name":@"自定义文本2",@"icon":@"http://photos.tuchong.com/285606/f/4374153.jpg"},
      @{@"name":@"自定义文本3",@"icon":@"http://img5.cache.netease.com/photo/0003/2012-06-21/84G462VS51GQ0003.jpg"},
      @{@"name":@"自定义文本4",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564463770360&di=c93e799328198337ed68c61381bcd0be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170714%2F1eed483f1874437990ad84c50ecfc82a_th.jpg"},
       @{@"name":@"自定义文本4",@"icon":@"http://i2.hdslb.com/bfs/archive/1c471796343e34a8613518cc0d393792680a1022.jpg"}
      ];
}

@end
