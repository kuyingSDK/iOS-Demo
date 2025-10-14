//
//  SDMNativeMainViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 2019/10/31.
//  Copyright © 2019 AnyThink. All rights reserved.
//

#import "SDMNativeMainViewController.h"
#import <Masonry/Masonry.h>
#import "SDMDemoUIHeader.h"
#import "SDMTestMutilDefine.h"
#import "SDMMenuView.h"
#import "SDMHomeTableViewCell.h"

@interface SDMNativeMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SDMNativeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.title = @"Native";
    
    [self setupData];
    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)setupData
{
    self.dataSource = @[
        @{
            @"image":@"native",
            @"title":@"Native SelfRender",
            @"class":@"SDMNativeSelfRenderViewController",
        },@{
            @"image":@"native",
            @"title":@"Native Express",
            @"class":@"SDMNativeExpressViewController",
        },
    ];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleW(238 + 10);
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDMHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDMHomeTableViewCell idString]];
    cell.backgroundColor = kRGB(245, 245, 245);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
    cell.logoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dic[@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];

    NSString *classString = [NSString stringWithFormat:@"%@", dic[@"class"]];
    Class class = NSClassFromString(classString);
  
    UIViewController *con = [class new];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SDMHomeTableViewCell class] forCellReuseIdentifier:[SDMHomeTableViewCell idString]];
    }
    return _tableView;
}

@end
