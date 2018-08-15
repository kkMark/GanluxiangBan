//
//  ScheduleViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/7.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleView.h"
#import "ScheduleModel.h"
#import "ScheduleRequest.h"
#import "SubscribeDetailsViewController.h"

@interface ScheduleViewController ()

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) ScheduleView *scheduleView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的日程";

    [self initUI];
    
    [self block];
    
    [self refresh];
    
}

//即将进入
- (void)viewWillAppear:(BOOL)animated{
    
    self.page = 1;
    [self.scheduleView.dataSource removeAllObjects];
    [self request];
    
}

-(void)initUI{
    
    self.scheduleView = [ScheduleView new];
    self.scheduleView.noMessageLabel.text = @"您暂时没有新日程";
    [self.view addSubview:self.scheduleView];
    
    self.scheduleView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
}

-(void)block{
    WS(weakSelf);
    self.scheduleView.pushBlock = ^(NSString *pushString) {
        
        SubscribeDetailsViewController *subsribeDetailsView = [[SubscribeDetailsViewController alloc] init];
        subsribeDetailsView.idString = pushString;
        subsribeDetailsView.visitId = pushString;
        [weakSelf.navigationController pushViewController:subsribeDetailsView animated:YES];
        
    };
    
}

-(void)request{
    
    WS(weakSelf);
    [[ScheduleRequest new] getPreOrderListPageindex:self.page :^(HttpGeneralBackModel *genneralBackModel) {
        

        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in genneralBackModel.data) {
            
            ScheduleModel *model = [ScheduleModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
            
        }
        
        [weakSelf.scheduleView addData:array];
        
        if (array.count != 0) {
            
            [weakSelf.scheduleView.NoMessageView removeFromSuperview];
            
        }
        
        [weakSelf.scheduleView.myTable.mj_header endRefreshing];
        [weakSelf.scheduleView.myTable.mj_footer endRefreshing];
        
    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.scheduleView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.scheduleView.dataSource removeAllObjects];
        [weakSelf request];
        
    }];
    
    self.scheduleView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf request];
        
    }];
}

@end
