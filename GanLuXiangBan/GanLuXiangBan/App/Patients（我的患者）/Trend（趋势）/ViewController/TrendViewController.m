//
//  TrendViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/20.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "TrendViewController.h"
#import "TrendView.h"
#import "TrendViewModel.h"
#import "ScreeningViewController.h"

@interface TrendViewController ()

@property (nonatomic, strong) TrendView *trendView;

@end

@implementation TrendViewController
@synthesize trendView;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"趋势图";
    [self getDataSource];
    
    @weakify(self);
    [self addNavRightTitle:@"筛选" complete:^{
       
        @strongify(self);
        
        ScreeningViewController *vc = [ScreeningViewController new];
        vc.allTypes = self.trendView.allTypes;
        vc.title = @"筛选";
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


- (TrendView *)trendView {
    
    if (!trendView) {
        
        trendView = [[TrendView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight)];
        trendView.backgroundColor = kPageBgColor;
        [self.view addSubview:trendView];
    }
    
    return trendView;
}


#pragma mark - request
- (void)getDataSource {
    
    [[TrendViewModel new] getChkTrend:self.midString chkTypeId:self.chkTypeId items:self.items complete:^(id object) {
        self.trendView.model = object;
    }];
}


@end
