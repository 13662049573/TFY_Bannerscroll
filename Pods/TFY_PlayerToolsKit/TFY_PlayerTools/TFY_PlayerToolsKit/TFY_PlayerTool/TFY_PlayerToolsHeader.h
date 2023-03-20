//
//  TFY_PlayerToolsHeader.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/1.
//  Copyright © 2019 田风有. All rights reserved.
//

#ifndef TFY_PlayerToolsHeader_h
#define TFY_PlayerToolsHeader_h

// 屏幕尺寸
#define TFY_PLAYER_ScreenW  [UIScreen mainScreen].bounds.size.width
#define TFY_PLAYER_ScreenH  [UIScreen mainScreen].bounds.size.height

#define TFY_PLAYER_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//等比宽
#define TFY_PLAYER_DEBI_WIDTH(CGFloat) (double)CGFloat/(double)375*PLAYER_ScreenW
//等比高
#define TFY_PLAYER_DEBI_HEIGHT(CGFloat) (double)CGFloat/(double)667*PLAYER_ScreenH

#ifndef player_weakify
   #if DEBUG
       #if __has_feature(objc_arc)
           #define player_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
       #else
           #define player_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
      #endif
   #else
#if __has_feature(objc_arc)
          #define player_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
      #else
          #define player_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
      #endif
   #endif
#endif

/** strongSelf */
#ifndef player_strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define player_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define player_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
#if __has_feature(objc_arc)
           #define player_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
           #define player_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

typedef NS_ENUM(NSUInteger, PlayerPlaybackState) {
    PlayerPlayStateUnknown,
    PlayerPlayStatePlaying,
    PlayerPlayStatePaused,
    PlayerPlayStatePlayFailed,
    PlayerPlayStatePlayStopped
};

typedef NS_OPTIONS(NSUInteger, PlayerLoadState) {
    PlayerLoadStateUnknown        = 0,
    PlayerLoadStatePrepare        = 1 << 0,
    PlayerLoadStatePlayable       = 1 << 1,
    PlayerLoadStatePlaythroughOK  = 1 << 2, // 回放将自动开始。
    PlayerLoadStateStalled        = 1 << 3, // 如果开始播放，将在此状态下自动暂停。
};

typedef NS_ENUM(NSInteger, PlayerScalingMode) {
    PlayerScalingModeNone,       // 没有扩展。
    PlayerScalingModeAspectFit,  // 统一尺度，直到一个维度合适。
    PlayerScalingModeAspectFill, // 均匀的比例，直到电影充满可见的界限。一个维度的内容可能会被剪切。
    PlayerScalingModeFill        // 不均匀的规模。两个渲染维度都将完全匹配可见边界。
};

#endif /* TFY_PlayerToolsHeader_h */
