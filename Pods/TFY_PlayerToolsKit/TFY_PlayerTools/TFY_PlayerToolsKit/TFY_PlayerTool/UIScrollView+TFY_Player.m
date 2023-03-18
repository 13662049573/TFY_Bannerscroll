//
//  UIScrollView+TFY_Player.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "UIScrollView+TFY_Player.h"
#import <objc/runtime.h>
#import "TFY_ReachabilityManager.h"
#import "TFY_KVOController.h"
#import "TFY_PlayerToolsHeader.h"

#define Player_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface UIScrollView ()
@property (nonatomic) CGFloat tfy_lastOffsetY;
@property (nonatomic) CGFloat tfy_lastOffsetX;
@property (nonatomic) PlayerScrollDirection tfy_scrollDirection;
@end


@implementation UIScrollView (TFY_Player)

#pragma mark - public method

- (UIView *)tfy_getCellForIndexPath:(NSIndexPath *)indexPath {
    if ([self _isTableView]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([self _isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (NSIndexPath *)tfy_getIndexPathForCell:(UIView *)cell {
    if ([self _isTableView]) {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];
        return indexPath;
    } else if ([self _isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)cell];
        return indexPath;
    }
    return nil;
}

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
                completionHandler:(void (^ __nullable)(void))completionHandler {
    [self tfy_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animateDuration:animated ? 0.4 : 0.0 completionHandler:completionHandler];
}

- (void)tfy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath
                 atScrollPosition:(PlayerScrollViewScrollPosition)scrollPosition
                  animateDuration:(NSTimeInterval)duration
                completionHandler:(void (^ __nullable)(void))completionHandler {
    BOOL animated = duration > 0.0;
    if ([self _isTableView]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewScrollPosition tableScrollPosition = UITableViewScrollPositionNone;
        if (scrollPosition <= PlayerScrollViewScrollPositionBottom) {
            tableScrollPosition = (UITableViewScrollPosition)scrollPosition;
        }
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:tableScrollPosition animated:animated];
    } else if ([self _isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
            UICollectionViewScrollPosition collectionScrollPosition = UICollectionViewScrollPositionNone;
            switch (scrollPosition) {
                case PlayerScrollViewScrollPositionNone:
                    collectionScrollPosition = UICollectionViewScrollPositionNone;
                    break;
                case PlayerScrollViewScrollPositionTop:
                    collectionScrollPosition = UICollectionViewScrollPositionTop;
                    break;
                case PlayerScrollViewScrollPositionCenteredVertically:
                    collectionScrollPosition = UICollectionViewScrollPositionCenteredVertically;
                    break;
                case PlayerScrollViewScrollPositionBottom:
                    collectionScrollPosition = UICollectionViewScrollPositionBottom;
                    break;
                default:
                    break;
            }
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:collectionScrollPosition animated:animated];
        } else if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionHorizontal) {
            UICollectionViewScrollPosition collectionScrollPosition = UICollectionViewScrollPositionNone;
            switch (scrollPosition) {
                case PlayerScrollViewScrollPositionNone:
                    collectionScrollPosition = UICollectionViewScrollPositionNone;
                    break;
                case PlayerScrollViewScrollPositionLeft:
                    collectionScrollPosition = UICollectionViewScrollPositionLeft;
                    break;
                case PlayerScrollViewScrollPositionCenteredHorizontally:
                    collectionScrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
                    break;
                case PlayerScrollViewScrollPositionRight:
                    collectionScrollPosition = UICollectionViewScrollPositionRight;
                    break;
                default:
                    break;
            }
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:collectionScrollPosition animated:animated];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completionHandler) completionHandler();
    });
}

- (void)tfy_scrollViewDidEndDecelerating {
    BOOL scrollToScrollStop = !self.tracking && !self.dragging && !self.decelerating;
    if (scrollToScrollStop) {
        [self _scrollViewDidStopScroll];
    }
}

- (void)tfy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = self.tracking && !self.dragging && !self.decelerating;
        if (dragToDragStop) {
            [self _scrollViewDidStopScroll];
        }
    }
}

- (void)tfy_scrollViewDidScrollToTop {
    [self _scrollViewDidStopScroll];
}

- (void)tfy_scrollViewDidScroll {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        [self _findCorrectCellWhenScrollViewDirectionVertical:nil];
        [self _scrollViewScrollingDirectionVertical];
    } else {
        [self _findCorrectCellWhenScrollViewDirectionHorizontal:nil];
        [self _scrollViewScrollingDirectionHorizontal];
    }
}

- (void)tfy_scrollViewWillBeginDragging {
    [self _scrollViewBeginDragging];
}

#pragma mark - private method

- (void)_scrollViewDidStopScroll {
    self.tfy_scrollDirection = PlayerScrollDirectionNone;
    @player_weakify(self)
    [self tfy_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        @player_strongify(self)
        if (self.tfy_scrollViewDidEndScrollingCallback) self.tfy_scrollViewDidEndScrollingCallback(indexPath);
    }];
}

- (void)_scrollViewBeginDragging {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        self.tfy_lastOffsetY = self.contentOffset.y;
    } else {
        self.tfy_lastOffsetX = self.contentOffset.x;
    }
}

/**
  The percentage of scrolling processed in vertical scrolling.
 */
- (void)_scrollViewScrollingDirectionVertical {
    CGFloat offsetY = self.contentOffset.y;
    self.tfy_scrollDirection = (offsetY - self.tfy_lastOffsetY > 0) ? PlayerScrollDirectionUp : PlayerScrollDirectionDown;
    self.tfy_lastOffsetY = offsetY;
    if (self.tfy_stopPlay) return;
    
    UIView *playerView;
    if (self.tfy_containerType == PlayerContainerTypeCell) {
        // Avoid being paused the first time you play it.
        if (self.contentOffset.y < 0) return;
        if (!self.tfy_playingIndexPath) return;
        
        UIView *cell = [self tfy_getCellForIndexPath:self.tfy_playingIndexPath];
        if (!cell) {
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
            return;
        }
        playerView = [cell viewWithTag:self.tfy_containerViewTag];
    } else if (self.tfy_containerType == PlayerContainerTypeView) {
        if (!self.tfy_containerView) return;
        playerView = self.tfy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView top to scrollView top space.
    CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
    /// playerView bottom to scrollView bottom space.
    CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) { /// Scroll up
        /// Player is disappearing.
        if (topSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -topSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (topSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (topSpacing > 0 && topSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(topSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (topSpacing <= contentInsetHeight && topSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
        
    } else if (self.tfy_scrollDirection == PlayerScrollDirectionDown) { /// Scroll Down
        /// Player is disappearing.
        if (bottomSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -bottomSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (bottomSpacing > 0 && bottomSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(bottomSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (bottomSpacing <= contentInsetHeight && bottomSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
    }
}

/**
 The percentage of scrolling processed in horizontal scrolling.
 */
- (void)_scrollViewScrollingDirectionHorizontal {
    CGFloat offsetX = self.contentOffset.x;
    self.tfy_scrollDirection = (offsetX - self.tfy_lastOffsetX > 0) ? PlayerScrollDirectionLeft : PlayerScrollDirectionRight;
    self.tfy_lastOffsetX = offsetX;
    if (self.tfy_stopPlay) return;
    
    UIView *playerView;
    if (self.tfy_containerType == PlayerContainerTypeCell) {
        // Avoid being paused the first time you play it.
        if (self.contentOffset.x < 0) return;
        if (!self.tfy_playingIndexPath) return;
        
        UIView *cell = [self tfy_getCellForIndexPath:self.tfy_playingIndexPath];
        if (!cell) {
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
            return;
        }
       playerView = [cell viewWithTag:self.tfy_containerViewTag];
    } else if (self.tfy_containerType == PlayerContainerTypeView) {
        if (!self.tfy_containerView) return;
        playerView = self.tfy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView left to scrollView left space.
    CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
    /// playerView bottom to scrollView right space.
    CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetWidth = CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.tfy_scrollDirection == PlayerScrollDirectionLeft) { /// Scroll left
        /// Player is disappearing.
        if (leftSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -leftSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (leftSpacing <= 0 && leftSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (leftSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (leftSpacing > 0 && leftSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(leftSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (leftSpacing <= contentInsetWidth && leftSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
        
    } else if (self.tfy_scrollDirection == PlayerScrollDirectionRight) { /// Scroll right
        /// Player is disappearing.
        if (rightSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -rightSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.tfy_playerDisappearingInScrollView) self.tfy_playerDisappearingInScrollView(self.tfy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (rightSpacing <= 0 && rightSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.tfy_playerWillDisappearInScrollView) self.tfy_playerWillDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (rightSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.tfy_playerDidDisappearInScrollView) self.tfy_playerDidDisappearInScrollView(self.tfy_playingIndexPath);
        } else if (rightSpacing > 0 && rightSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(rightSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.tfy_playerAppearingInScrollView) self.tfy_playerAppearingInScrollView(self.tfy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (rightSpacing <= contentInsetWidth && rightSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.tfy_playerWillAppearInScrollView) self.tfy_playerWillAppearInScrollView(self.tfy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.tfy_playerDidAppearInScrollView) self.tfy_playerDidAppearInScrollView(self.tfy_playingIndexPath);
            }
        }
    }
}

/**
 Find the playing cell while the scrollDirection is vertical.
 */
- (void)_findCorrectCellWhenScrollViewDirectionVertical:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    if (self.tfy_containerType == PlayerContainerTypeView) return;

    if (!self.tfy_stopWhileNotVisible) {
        /// If you have a cell that is playing, stop the traversal.
        if (self.tfy_playingIndexPath) {
            NSIndexPath *finalIndexPath = self.tfy_playingIndexPath;
            if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(finalIndexPath);
            if (handler) handler(finalIndexPath);
            self.tfy_shouldPlayIndexPath = finalIndexPath;
            return;
        }
    }
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    BOOL isLast = self.contentOffset.y + self.frame.size.height >= self.contentSize.height;
    if ([self _isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if ((self.contentOffset.y <= 0 || isLast) && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView && !playerView.hidden && playerView.alpha > 0.01) {
                if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self _isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = isLast ? sortedIndexPaths.lastObject : sortedIndexPaths.firstObject;
        if ((self.contentOffset.y <= 0 || isLast) && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView && !playerView.hidden && playerView.alpha > 0.01) {
                if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidY = CGRectGetHeight(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @player_weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @player_strongify(self)
        UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
        if (!playerView || playerView.hidden || playerView.alpha <= 0.01) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        /// playerView top to scrollView top space.
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
        /// playerView bottom to scrollView bottom space.
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        NSIndexPath *indexPath = [self tfy_getIndexPathForCell:cell];
        
        /// Play when the video playback section is visible.
        if ((topSpacing >= -(1 - self.tfy_playerApperaPercent) * CGRectGetHeight(rect)) && (bottomSpacing >= -(1 - self.tfy_playerApperaPercent) * CGRectGetHeight(rect))) {
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
        if (handler) handler(finalIndexPath);
    }
    self.tfy_shouldPlayIndexPath = finalIndexPath;
}

/**
 Find the playing cell while the scrollDirection is horizontal.
 */
- (void)_findCorrectCellWhenScrollViewDirectionHorizontal:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    if (self.tfy_containerType == PlayerContainerTypeView) return;
    if (!self.tfy_stopWhileNotVisible) {
        /// If you have a cell that is playing, stop the traversal.
        if (self.tfy_playingIndexPath) {
            NSIndexPath *finalIndexPath = self.tfy_playingIndexPath;
            if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(finalIndexPath);
            if (handler) handler(finalIndexPath);
            self.tfy_shouldPlayIndexPath = finalIndexPath;
            return;
        }
    }
    
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    BOOL isLast = self.contentOffset.x + self.frame.size.width >= self.contentSize.width;
    if ([self _isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if ((self.contentOffset.x <= 0 || isLast) && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView && !playerView.hidden && playerView.alpha > 0.01) {
                if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self _isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = isLast ? sortedIndexPaths.lastObject : sortedIndexPaths.firstObject;
        if ((self.contentOffset.x <= 0 || isLast) && (!self.tfy_playingIndexPath || [indexPath compare:self.tfy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
            if (playerView && !playerView.hidden && playerView.alpha > 0.01) {
                if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
                if (handler) handler(indexPath);
                self.tfy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.tfy_scrollDirection == PlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidX = CGRectGetWidth(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @player_weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @player_strongify(self)
        UIView *playerView = [cell viewWithTag:self.tfy_containerViewTag];
        if (!playerView || playerView.hidden || playerView.alpha <= 0.01) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        /// playerView left to scrollView top space.
        CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
        /// playerView right to scrollView top space.
        CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidX - CGRectGetMidX(rect));
        NSIndexPath *indexPath = [self tfy_getIndexPathForCell:cell];
        
        /// Play when the video playback section is visible.
        if ((leftSpacing >= -(1 - self.tfy_playerApperaPercent) * CGRectGetWidth(rect)) && (rightSpacing >= -(1 - self.tfy_playerApperaPercent) * CGRectGetWidth(rect))) {
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (self.tfy_scrollViewDidScrollCallback) self.tfy_scrollViewDidScrollCallback(indexPath);
        if (handler) handler(finalIndexPath);
        self.tfy_shouldPlayIndexPath = finalIndexPath;
    }
}

- (BOOL)_isTableView {
    return [self isKindOfClass:[UITableView class]];
}

- (BOOL)_isCollectionView {
    return [self isKindOfClass:[UICollectionView class]];
}

#pragma mark - getter

- (PlayerScrollDirection)tfy_scrollDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (PlayerScrollViewDirection)tfy_scrollViewDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (CGFloat)tfy_lastOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)tfy_lastOffsetX {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

#pragma mark - setter

- (void)setTfy_scrollDirection:(PlayerScrollDirection)tfy_scrollDirection {
    objc_setAssociatedObject(self, @selector(tfy_scrollDirection), @(tfy_scrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_scrollViewDirection:(PlayerScrollViewDirection)tfy_scrollViewDirection {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDirection), @(tfy_scrollViewDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_lastOffsetY:(CGFloat)tfy_lastOffsetY {
    objc_setAssociatedObject(self, @selector(tfy_lastOffsetY), @(tfy_lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_lastOffsetX:(CGFloat)tfy_lastOffsetX {
    objc_setAssociatedObject(self, @selector(tfy_lastOffsetX), @(tfy_lastOffsetX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (PlayerCannotCalled)

- (void)tfy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (self.tfy_scrollViewDirection == PlayerScrollViewDirectionVertical) {
        [self _findCorrectCellWhenScrollViewDirectionVertical:handler];
    } else {
        [self _findCorrectCellWhenScrollViewDirectionHorizontal:handler];
    }
}

- (void)tfy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.tfy_shouldAutoPlay) return;
    @player_weakify(self)
    [self tfy_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        @player_strongify(self)
        /// 如果当前控制器已经消失，直接return
        if (self.tfy_viewControllerDisappear) return;
        if ([TFY_ReachabilityManager sharedManager].isReachableViaWWAN && !self.tfy_WWANAutoPlay) {
            /// 移动网络
            self.tfy_shouldPlayIndexPath = indexPath;
            return;
        }
        if (handler) handler(indexPath);
        self.tfy_playingIndexPath = indexPath;
    }];
}

#pragma mark - getter

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidEndScrollingCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))tfy_playerShouldPlayInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)tfy_playerApperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)tfy_playerDisapperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (BOOL)tfy_viewControllerDisappear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)tfy_stopPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.tfy_stopPlay = YES;
    return YES;
}

- (BOOL)tfy_stopWhileNotVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (NSIndexPath *)tfy_playingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSIndexPath *)tfy_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)tfy_containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)tfy_isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)tfy_shouldAutoPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.tfy_shouldAutoPlay = YES;
    return YES;
}

- (PlayerContainerType)tfy_containerType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (UIView *)tfy_containerView {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setTfy_playerDisappearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerDisappearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDisappearingInScrollView), tfy_playerDisappearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerAppearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))tfy_playerAppearingInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerAppearingInScrollView), tfy_playerAppearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidAppearInScrollView), tfy_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillDisappearInScrollView), tfy_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerWillAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerWillAppearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerWillAppearInScrollView), tfy_playerWillAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerDidDisappearInScrollView), tfy_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_scrollViewDidEndScrollingCallback:(void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidEndScrollingCallback {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDidEndScrollingCallback), tfy_scrollViewDidEndScrollingCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_scrollViewDidScrollCallback:(void (^)(NSIndexPath * _Nonnull))tfy_scrollViewDidScrollCallback {
    objc_setAssociatedObject(self, @selector(tfy_scrollViewDidScrollCallback), tfy_scrollViewDidScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerShouldPlayInScrollView:(void (^)(NSIndexPath * _Nonnull))tfy_playerShouldPlayInScrollView {
    objc_setAssociatedObject(self, @selector(tfy_playerShouldPlayInScrollView), tfy_playerShouldPlayInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerApperaPercent:(CGFloat)tfy_playerApperaPercent {
    objc_setAssociatedObject(self, @selector(tfy_playerApperaPercent), @(tfy_playerApperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_playerDisapperaPercent:(CGFloat)tfy_playerDisapperaPercent {
    objc_setAssociatedObject(self, @selector(tfy_playerDisapperaPercent), @(tfy_playerDisapperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_viewControllerDisappear:(BOOL)tfy_viewControllerDisappear {
    objc_setAssociatedObject(self, @selector(tfy_viewControllerDisappear), @(tfy_viewControllerDisappear), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTfy_stopPlay:(BOOL)tfy_stopPlay {
    objc_setAssociatedObject(self, @selector(tfy_stopPlay), @(tfy_stopPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_stopWhileNotVisible:(BOOL)tfy_stopWhileNotVisible {
    objc_setAssociatedObject(self, @selector(tfy_stopWhileNotVisible), @(tfy_stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_playingIndexPath:(NSIndexPath *)tfy_playingIndexPath {
    objc_setAssociatedObject(self, @selector(tfy_playingIndexPath), tfy_playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tfy_playingIndexPath && [tfy_playingIndexPath compare:self.tfy_shouldPlayIndexPath] != NSOrderedSame) {
        self.tfy_shouldPlayIndexPath = tfy_playingIndexPath;
    }
}

- (void)setTfy_shouldPlayIndexPath:(NSIndexPath *)tfy_shouldPlayIndexPath {
    if (self.tfy_playerShouldPlayInScrollView) self.tfy_playerShouldPlayInScrollView(tfy_shouldPlayIndexPath);
    objc_setAssociatedObject(self, @selector(tfy_shouldPlayIndexPath), tfy_shouldPlayIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerViewTag:(NSInteger)tfy_containerViewTag {
    objc_setAssociatedObject(self, @selector(tfy_containerViewTag), @(tfy_containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerType:(PlayerContainerType)tfy_containerType {
    objc_setAssociatedObject(self, @selector(tfy_containerType), @(tfy_containerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_containerView:(UIView *)tfy_containerView {
    objc_setAssociatedObject(self, @selector(tfy_containerView), tfy_containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_shouldAutoPlay:(BOOL)tfy_shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(tfy_shouldAutoPlay), @(tfy_shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_WWANAutoPlay:(BOOL)tfy_WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(tfy_isWWANAutoPlay), @(tfy_WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
#pragma clang diagnostic pop
