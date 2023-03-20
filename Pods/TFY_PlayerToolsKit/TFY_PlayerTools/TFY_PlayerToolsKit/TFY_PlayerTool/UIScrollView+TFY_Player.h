//
//  UIScrollView+TFY_Player.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * scrollView的滚动方向。
 */
typedef NS_ENUM(NSUInteger, PlayerScrollDirection) {
    PlayerScrollDirectionNone,
    PlayerScrollDirectionUp,         // 向上滑动
    PlayerScrollDirectionDown,       // 向下滚动
    PlayerScrollDirectionLeft,       // 向左滚动
    PlayerScrollDirectionRight       // 向右滚动
};

/*
 * scrollView方向。
 */
typedef NS_ENUM(NSInteger, PlayerScrollViewDirection) {
    PlayerScrollViewDirectionVertical,
    PlayerScrollViewDirectionHorizontal
};

/*
 * 播放器容器类型
 */
typedef NS_ENUM(NSInteger, PlayerContainerType) {
    PlayerContainerTypeCell,
    PlayerContainerTypeView
};

typedef NS_ENUM(NSInteger , PlayerScrollViewScrollPosition) {
    PlayerScrollViewScrollPositionNone,
    /// 应用于UITableView和UICollectionViewDirection是垂直滚动。
    PlayerScrollViewScrollPositionTop,
    PlayerScrollViewScrollPositionCenteredVertically,
    PlayerScrollViewScrollPositionBottom,
    
    /// 只适用于UICollectionViewDirection是水平滚动。
    PlayerScrollViewScrollPositionLeft,
    PlayerScrollViewScrollPositionCenteredHorizontally,
    PlayerScrollViewScrollPositionRight
};

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TFY_Player)

/// 当 PlayerScrollViewDirection是 PlayerScrollViewDirectionVertical时，该属性具有值。
@property (nonatomic, readonly) CGFloat tfy_lastOffsetY;

/// 当PlayerScrollViewDirection是PlayerScrollViewDirectionHorizo​​ntal时，该属性具有值。
@property (nonatomic, readonly) CGFloat tfy_lastOffsetX;

/// scrollView滚动方向，默认为PlayerScrollViewDirectionVertical。
@property (nonatomic) PlayerScrollViewDirection tfy_scrollViewDirection;

///滚动时scrollView的滚动方向。
///当PlayerScrollViewDirection为tfyPlayerScrollViewDirectionVertical时，此值只能是PlayerScrollDirectionUp或tfyPlayerScrollDirectionDown。
///当PlayerScrollViewDirection为tfyPlayerScrollViewDirectionVertical时，此值只能是PlayerScrollDirectionLeft或tfyPlayerScrollDirectionRight。
@property (nonatomic, readonly) PlayerScrollDirection tfy_scrollDirection;

/// Get the cell according to indexPath.
- (UIView *)tfy_getCellForIndexPath:(NSIndexPath *)indexPath;

/// Get the indexPath for cell.
- (NSIndexPath *)tfy_getIndexPathForCell:(UIView *)cell;

/**
Scroll to indexPath with position.
 
@param indexPath scroll the  indexPath.
@param scrollPosition  scrollView scroll position.
@param animated animate.
@param completionHandler  Scroll completion callback.
*/
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath
                 atScrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                         animated:(BOOL)animated
                completionHandler:(void (^ __nullable)(void))completionHandler;

/**
Scroll to indexPath with position.
 
@param indexPath scroll the  indexPath.
@param scrollPosition  scrollView scroll position.
@param duration animate duration.
@param completionHandler  Scroll completion callback.
*/
- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath
                 atScrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                  animateDuration:(NSTimeInterval)duration
                completionHandler:(void (^ __nullable)(void))completionHandler;

///------------------------------------
/// The following method must be implemented in UIScrollViewDelegate.
///------------------------------------

- (void)tfy_scrollViewDidEndDecelerating;

- (void)tfy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate;

- (void)tfy_scrollViewDidScrollToTop;

- (void)tfy_scrollViewDidScroll;

- (void)tfy_scrollViewWillBeginDragging;

@end

@interface UIScrollView (PlayerCannotCalled)

/// 当出现时，方块被调用。
@property (nonatomic, copy, nullable) void(^tfy_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/// 当玩家消失时，方块被调用。
@property (nonatomic, copy, nullable) void(^tfy_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/// 当玩家出现时，块被调用。
@property (nonatomic, copy, nullable) void(^tfy_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/// 当玩家出现时，方块被调用。
@property (nonatomic, copy, nullable) void(^tfy_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/// 当玩家消失时调用的块。
@property (nonatomic, copy, nullable) void(^tfy_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/// 当玩家消失时，方块被调用。
@property (nonatomic, copy, nullable) void(^tfy_playerDidDisappearInScrollView)(NSIndexPath *indexPath);

/// 当玩家停止滚动时，方块被调用。
@property (nonatomic, copy, nullable) void(^tfy_scrollViewDidEndScrollingCallback)(NSIndexPath *indexPath);

/// 当玩家滚动时，块被调用。
@property (nonatomic, copy, nullable) void(^tfy_scrollViewDidScrollCallback)(NSIndexPath *indexPath);

/// 当玩家应该游戏时调用的块。
@property (nonatomic, copy, nullable) void(^tfy_playerShouldPlayInScrollView)(NSIndexPath *indexPath);

///当前播放器滚动滑动百分比。
///当' stopWhileNotVisible '为YES时使用的属性，停止当前播放的播放器。
///当' stopWhileNotVisible '为NO时使用的属性，当前播放的播放器添加到小容器视图。
/// 0.0~1.0，默认为0.5。
/// 0.0表示播放器将消失。
/// 1.0是播放器消失。
@property (nonatomic) CGFloat tfy_playerDisapperaPercent;

///当前播放器滚动到屏幕百分比来播放视频。
/// 0.0~1.0，默认值为0.0。
/// 0.0表示播放器将会出现。
/// 1.0是播放器确实出现。
@property (nonatomic) CGFloat tfy_playerApperaPercent;

/// 当前的播放器控制器是消失，而不是释放
@property (nonatomic) BOOL tfy_viewControllerDisappear;

/// 已经停止播放了
@property (nonatomic, assign) BOOL tfy_stopPlay;

/// 当前正在播放的单元格在单元格离开屏幕时停止播放，默认为YES。
@property (nonatomic, assign) BOOL tfy_stopWhileNotVisible;

/// indexPath正在播放。
@property (nonatomic, nullable) NSIndexPath *tfy_playingIndexPath;

/// 滚动时应该播放indexPath。
@property (nonatomic, nullable) NSIndexPath *tfy_shouldPlayIndexPath;

/// WWANA网络自动播放，默认NO。
@property (nonatomic, getter=tfy_isWWANAutoPlay) BOOL tfy_WWANAutoPlay;

/// 播放器应该自动播放，默认是YES。
@property (nonatomic) BOOL tfy_shouldAutoPlay;

/// 播放器在scrollView中显示的视图标签。
@property (nonatomic) NSInteger tfy_containerViewTag;

/// 正常模式下的视频容器视图。
@property (nonatomic, strong) UIView *tfy_containerView;

/// 视频containerview类型。
@property (nonatomic, assign) PlayerContainerType tfy_containerType;

/// 筛选当滚动停止时应该播放的单元格(当滚动停止时播放)。
- (void)tfy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler;

///在滚动时过滤应该播放的单元格(您可以使用此功能来过滤突出显示的单元格)。
- (void)tfy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler;


@end

NS_ASSUME_NONNULL_END
