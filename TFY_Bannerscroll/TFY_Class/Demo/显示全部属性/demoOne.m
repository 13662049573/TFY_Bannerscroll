//
//  demoOne.m
//  WMZBanner
//
//  Created by wmz on 2019/12/16.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "demoOne.h"
#import "MyCell.h"
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
    .tfy_CustomControlSet(^(UIPageControl *pageControl) {
        
    })
    //自定义视图必传
    .tfy_MyCellClassNameSet(@"MyCell")
    .tfy_MyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
        MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCell class]) forIndexPath:indexPath];
        [cell.icon tfy_BannerImage:[NSURL URLWithString:model[@"icon"]]];
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
         [strongObject.viewOne.bgImgView tfy_BannerImage:[NSURL URLWithString:anyID[@"icon"]]];
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
    .tfy_ScaleFactorSet(0.5)
    //item的size
    .tfy_ItemSizeSet(CGSizeMake(BannerWitdh*0.5, BannerHeight/3))
    //滑动固定偏移距离 itemSize.width*倍数
    .tfy_ContentOffsetXSet(0.5)
    //默认滑动到第index个
    .tfy_SelectIndexSet(2)
    //循环滚动
    .tfy_RepeatSet(YES)
    //自动滚动时间
    .tfy_AutoScrollSecondSet(3)
    //自动滚动
    .tfy_AutoScrollSet(YES)
    //卡片叠加模式
    .tfy_CardOverLapSet(NO)
    //cell的位置
    .tfy_PositionSet(BannerCellPositionCenter)
    //分页按钮的选中的颜色
    .tfy_BannerControlSelectColorSet([UIColor whiteColor])
    //分页按钮的未选中的颜色
    .tfy_BannerControlColorSet([UIColor cyanColor])
    //分页按钮的未选中的图片
    .tfy_BannerControlImageSet(@"slideCirclePoint")
    //分页按钮的选中的图片
    .tfy_BannerControlSelectImageSet(@"slidePoint")
    //分页按钮的未选中图片的size
    .tfy_BannerControlImageSizeSet(CGSizeMake(10, 10))
    //分页按钮选中的图片的size
    .tfy_BannerControlSelectImageSizeSet(CGSizeMake(15, 10))
    //分页按钮的圆角
    .tfy_BannerControlImageRadiusSet(5)
    //自定义圆点间距
    .tfy_BannerControlSelectMarginSet(3)
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
    //分页按钮的位置
    .tfy_BannerControlPositionSet(BannerControlCenter)
    //左右偏移 让第一个和最后一个可以居中
    .tfy_SectionInsetSet(UIEdgeInsetsMake(0,BannerWitdh*0.25, 0, BannerWitdh*0.25))
    //数据源
    .tfy_DataSet([self getData])
    ;
    
    self.viewOne = [[TFY_BannerView alloc]initConfigureWithModel:self.param withView:self.view];
}


//更新数据
- (void)updata{
    self.param.tfy_DataSet(@[
@{@"name":@"自定义文本11",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501052334&di=47c55150e39ee4e13f52c2a2d60e3249&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn%2Fw800h450%2F20171207%2F9641-fypnsin6729109.jpg"},
@{@"name":@"自定义文本22",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576501100534&di=59ea2b526bd9050cd0e606be63ca1235&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20110%2F82%2Fw1080h602%2F20191105%2F3093-ihyxcrp3886394.jpg"}
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
