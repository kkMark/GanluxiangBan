//
//  SubscribeViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/17.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeView.h"
#import "SubscribeViewModel.h"

@interface SubscribeViewController ()

@property (nonatomic, strong) SubscribeView *subscribeView;
/// 类型 - 默认 2、电话预约   3、线下预约
@property (nonatomic, strong) NSString *preType;
/// 状态 - 默认 0、全部    1、成功 2、待处理 3、失败
@property (nonatomic, strong) NSString *opStatus;
/// 页数 - 默认 1
@property (nonatomic, strong) NSString *page;

@end

@implementation SubscribeViewController
@synthesize subscribeView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.preType = @"2";
    self.opStatus = @"0";
    self.page = @"1";
    [self setNavTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getCount:self.preType];
}

- (void)setNavTitleView {
    
    NSArray *titles = @[@"电话预约", @"线下预约"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titles];
    segment.frame = CGRectMake(0, 0, 120, 30);
    segment.tintColor = [UIColor whiteColor];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    @weakify(self);
    [[segment rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
     
        @strongify(self);
        UISegmentedControl *segment = (UISegmentedControl *)x;
        self.page = @"1";
        self.opStatus = @"0";
        self.preType = [NSString stringWithFormat:@"%zd", segment.selectedSegmentIndex + 2];
        [self getCount:self.preType];
    }];
}

#pragma mark - lazy
- (SubscribeView *)subscribeView {
    
    if (!subscribeView) {
        
        subscribeView = [[SubscribeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:subscribeView];
        
        @weakify(self);
        [self.subscribeView setSelectTypeBlock:^(NSInteger type) {
           
            @strongify(self);
            self.opStatus = [NSString stringWithFormat:@"%zd", type + 1];
            [self getDataSource:self.preType opStatus:self.opStatus page:self.page];
        }];
        
        [self.subscribeView setGoViewController:^(UIViewController *viewController) {
           
            @strongify(self);
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }
    
    return subscribeView;
}


#pragma mark - request
- (void)getDataSource:(NSString *)preType opStatus:(NSString *)opStatus page:(NSString *)page {
    
    [[SubscribeViewModel new] getOrderApps:preType opStatus:opStatus page:page complete:^(id object) {
        self.subscribeView.dataSources = object;
    }];
}


- (void)getCount:(NSString *)preType {
    
    [[SubscribeViewModel new] getAppCount:preType complete:^(id object) {
        self.subscribeView.model = object;
        [self getDataSource:preType opStatus:self.opStatus page:self.page];
    }];
}

@end
