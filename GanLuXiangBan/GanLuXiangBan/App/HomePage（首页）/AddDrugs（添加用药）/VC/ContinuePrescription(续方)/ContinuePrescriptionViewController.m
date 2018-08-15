//
//  ContinuePrescriptionViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/6.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "ContinuePrescriptionViewController.h"
#import "RecDrugsRequest.h"
#import "ContinueModel.h"
#import "ContinuePrescriptionView.h"

@interface ContinuePrescriptionViewController ()

@property (nonatomic ,strong) ContinuePrescriptionView *continuePrescriptionView;

@end

@implementation ContinuePrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self request];
    
}

-(void)initUI{
    
    self.continuePrescriptionView = [ContinuePrescriptionView new];
    [self.view addSubview:self.continuePrescriptionView];
    
    self.continuePrescriptionView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(ScreenHeight - 64 - 50);
    
}

-(void)request{
    
    WS(weakSelf);
    
    [[RecDrugsRequest new] getXufangItemsMid:@"" :^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in genneralBackModel.data) {
            
            ContinueModel *model = [ContinueModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
            
        }
        
        [weakSelf.continuePrescriptionView addData:array];
        
        [weakSelf.continuePrescriptionView.NoMessageView removeFromSuperview];
        
        [weakSelf.continuePrescriptionView.myTable.mj_header endRefreshing];
        [weakSelf.continuePrescriptionView.myTable.mj_footer endRefreshing];
        
    }];
    
}

@end
