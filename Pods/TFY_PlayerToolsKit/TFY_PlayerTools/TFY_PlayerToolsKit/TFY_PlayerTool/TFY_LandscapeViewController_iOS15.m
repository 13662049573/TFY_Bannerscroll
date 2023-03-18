//
//  TFY_LandscapeViewController_iOS15.m
//  TFY_PlayerTools
//
//  Created by 田风有 on 2023/3/16.
//  Copyright © 2023 田风有. All rights reserved.
//

#import "TFY_LandscapeViewController_iOS15.h"

@interface TFY_LandscapeViewController_iOS15 ()

@end

@implementation TFY_LandscapeViewController_iOS15

- (void)viewDidLoad {
    [super viewDidLoad];
    _playerSuperview = [[UIView alloc] initWithFrame:CGRectZero];
    _playerSuperview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_playerSuperview];
}

- (BOOL)shouldAutorotate {
    return [self.delegate ls_shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
