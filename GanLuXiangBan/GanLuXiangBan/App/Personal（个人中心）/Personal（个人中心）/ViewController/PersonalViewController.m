//
//  PersonalViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/4/30.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalView.h"
#import "PersonalInfoViewModel.h"

@interface PersonalViewController ()

@property (nonatomic, strong) PersonalView *personalView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PersonalViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"个人中心";
    
    [self setupSubviews];
    [self getInfo];
}
-(void)action{
    [self getInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)setupSubviews {
    
    self.personalView = [[PersonalView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.tabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.personalView];
    
    WS(weakSelf);
    [self.personalView setGoViewControllerBlock:^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    }];
}

- (void)goViewController:(UIViewController *)viewController {
    
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)getInfo {
    
    [[PersonalInfoViewModel new] getDoctorInfoWithId:GetUserDefault(UserID) complete:^(PersonalInfoModel *model) {
        self.personalView.model = model;
    }];
}

@end
