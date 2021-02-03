//
//  TFY_BannerView.h
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_BannerParam.h"

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

@end

@interface Collectioncell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *bannerImageView;
@property(nonatomic,strong)TFY_BannerParam *param;

@end

@interface CollectionTextCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)TFY_BannerParam *param;
@end


@interface BannerTime : NSObject

/**
  start 开始时间
  interval 间隔多少秒执行下一次
  repeats 是否开启循环执行
  async 选择主线程还是子线程执行
 */
+ (NSString *)bannerTimerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(void))completion;

/**
 target 那个对象需要执行
 selector 执行方法
 start 开始时间
 interval 间隔多少秒执行下一次
 repeats 是否开启循环执行
 async 选择主线程还是子线程执行
 */
+ (NSString *)bannerTimerWithTarget:(id)target
                     selector:(SEL)selector
                    StartTime:(NSTimeInterval)start
                     interval:(NSTimeInterval)interval
                      repeats:(BOOL)repeats
                    mainQueue:(BOOL)async;


/**取消定时器，通过上面返回ID*/
+ (void)bannerCancel:(NSString *)timerID;

@end

NS_ASSUME_NONNULL_END
