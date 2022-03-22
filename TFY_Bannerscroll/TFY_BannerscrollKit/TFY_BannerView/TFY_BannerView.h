//
//  TFY_BannerView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TFY_BannerParam.h"
#import "TFY_BannerVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_BannerView : UIView
/**背景图*/
@property(strong,nonatomic)UIImageView *bgImgView;

/**调用方法*/
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param withView:(UIView*)parentView;
/**调用方法*/
- (instancetype)initConfigureWithModel:(TFY_BannerParam *)param;
/**更新UI*/
- (void)updateUI;
/**更新fram 必须要假的把item 重新设置一下*/
- (void)FrameUpdate;

- (void)stopVideo;

@end

@interface Collectioncell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *bannerImageView;
@property(nonatomic,strong)TFY_BannerParam *param;
@property (nonatomic , strong)TFY_BannerVideoView *playerView;
@end

@interface CollectionTextCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)TFY_BannerParam *param;
@end


NS_ASSUME_NONNULL_END
