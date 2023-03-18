//
//  TFY_PlayerBaseView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PlayerToolsHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PlayerBaseView : UIView

/// 玩家内容视图。
@property (nonatomic, strong) UIView *playerView;

/// 决定内容如何缩放以适应视图。
@property (nonatomic, assign) PlayerScalingMode scalingMode;

/// 视频大小。
@property (nonatomic, assign) CGSize presentationSize;

/// playerView的封面。
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@end

NS_ASSUME_NONNULL_END
