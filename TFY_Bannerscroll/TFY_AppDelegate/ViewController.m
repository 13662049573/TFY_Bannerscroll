//
//  ViewController.m
//  TFY_Bannerscroll
//
//  Created by 田风有 on 2019/12/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *taData;
@property(nonatomic,strong)NSArray *vcData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"列表展示";

    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = UITableViewCreateWithStyle(UITableViewStylePlain);
        _tableView.makeChain
        .showsVerticalScrollIndicator(NO)
        .showsHorizontalScrollIndicator(NO)
        .adJustedContentIOS11()
        .delegate(self)
        .dataSource(self)
        .backgroundColor(UIColor.whiteColor)
        .estimatedSectionFooterHeight(0.01)
        .estimatedSectionHeaderHeight(0.01)
        .rowHeight(60)
        .tableHeaderView(UIView.new)
        .tableFooterView(UIView.new);
    }
    return _tableView;
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.taData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell tfy_cellFromCodeWithTableView:tableView];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.taData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.vcData[indexPath.row]);
    [self.navigationController pushViewController:[class new] animated:YES];
}

- (NSArray *)taData{
    if (!_taData) {
        _taData = @[@"显示全部属性(+更新数据)",@"自定义pageControl",@"正常样式(横向+纵向)",@"天猫精灵样式",@"电商播报",@"自定义卡片样式",@"叠加样式",@"跑马灯"];
    }
    return _taData;
}

- (NSArray *)vcData{
    if (!_vcData) {
        _vcData = @[@"demoOne",@"DemoPageControl",@"demoNormal",@"DemoTianMao",@"DemoDianshang",@"DemoCard",@"DemoAdd",@"DemoMarqueen"];
    }
    return _vcData;
}


@end
