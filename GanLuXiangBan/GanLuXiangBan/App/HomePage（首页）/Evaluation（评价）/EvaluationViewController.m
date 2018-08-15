//
//  EvaluationViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/11.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluationRequest.h"
#import "EvaluationModel.h"
#import "EvaluationView.h"

@interface EvaluationViewController ()

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) EvaluationView *evaluationView;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"患者评价";
    
    self.page = 1;
    
    [self initUI];
    
    [self request];
    
    [self refresh];
    
}

-(void)initUI{
    
    self.evaluationView = [EvaluationView new];
    [self.view addSubview:self.evaluationView];
    
    self.evaluationView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
}

-(void)request{
    
    WS(weakSelf);
    [[EvaluationRequest new] getEvaluatesPageindex:self.page complete:^(HttpGeneralBackModel *genneralBackModel) {
        
        [weakSelf.evaluationView.NoMessageView removeFromSuperview];
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in genneralBackModel.data) {
            
            EvaluationModel *model = [EvaluationModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
            
        }
        
        [weakSelf.evaluationView addData:array];
        
        [weakSelf.evaluationView.myTable.mj_header endRefreshing];
        [weakSelf.evaluationView.myTable.mj_footer endRefreshing];
        
    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.evaluationView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.evaluationView.dataSource removeAllObjects];
        [weakSelf request];
        
    }];
    
    self.evaluationView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf request];
        
    }];
}

@end
