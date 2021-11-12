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
    @{@"name":@"自定义文本11",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    @{@"name":@"自定义文本22",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    @{@"name":@"自定义文本33",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    @{@"name":@"自定义文本44",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    @{@"name":@"自定义文本44",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    @{@"name":@"自定义文本44",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
    ]);
    [self.viewOne updateUI];
}

- (NSArray*)getData{
    return @[
      @{@"name":@"自定义文本11",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本22",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
  @{@"name":@"自定义文本1",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本2",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本3",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本1",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本2",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本3",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
      @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"},
       @{@"name":@"自定义文本4",@"icon":@"http://p3.music.126.net/jGi52eDVUxCnMaVy-_bqcQ==/18531168976543961.jpg?param=640y248"}
      ];
}

@end
