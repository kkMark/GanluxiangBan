//
//  AllDrugViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/6.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "AllDrugViewController.h"
#import "DrugRequest.h"
#import "SearchView.h"
#import "DrugList.h"
#import "DrugListModel.h"
#import "AddDrugsView.h"
#import "DrugDosageModel.h"

@interface AllDrugViewController ()

@property (nonatomic ,retain)DrugRequest *drugRequest;

@property (nonatomic, strong) SearchView *searchView;

@property (nonatomic, strong) DrugList *drugListView;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic ,strong) AddDrugsView *addDrugsView;

@end

@implementation AllDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self block];
    
    [self refresh];
    
    self.keyString = @"";
    
}

-(void)initUI{
    
    self.searchView = [SearchView new];
    [self.view addSubview:self.searchView];
    
    self.searchView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(50);
    
    self.drugListView = [DrugList new];
    self.drugListView.Type = 2;
    [self.view addSubview:self.drugListView];
    
    self.drugListView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.searchView, 0)
    .heightIs(ScreenHeight - 64 - 50);
    
}

-(void)setArray:(NSArray *)array{
    
    _array = array;
    
    self.drugListView.drug_idArray = array;
    
}

-(void)setKeyString:(NSString *)keyString{
    
    _keyString = keyString;
    
    self.page = 1;
    [self.drugListView.dataSource removeAllObjects];
    [self request:keyString sort:1 isDesc:YES];
    
}

-(void)setIdString:(NSString *)idString{
    
    _idString = idString;
    
    self.page = 1;
    [self.drugListView.dataSource removeAllObjects];
    [self request:self.keyString sort:1 isDesc:YES];
    
}

-(void)block{
    
    WS(weakSelf)
    
    [self.searchView setSearchBlock:^(NSString *searchTextString) {
        
        weakSelf.keyString = searchTextString;
        
        weakSelf.page = 1;
        
//        [weakSelf.drugListView.dataSource removeAllObjects];
//        
//        [weakSelf request:weakSelf.keyString sort:1 isDesc:YES];
        
    }];
    
    self.drugListView.collectBlock = ^(DrugListModel *model) {
        
        DrugDosageModel *drugDosageModel = [DrugDosageModel new];
        drugDosageModel.drug_name = [NSString stringWithFormat:@"%@(%@)",model.drug_name,model.common_name];
        drugDosageModel.drugid = model.drug_id;
        drugDosageModel.drug_code = model.drug_code;
        drugDosageModel.standard = model.standard;
        
        
        weakSelf.addDrugsView = [AddDrugsView new];
        weakSelf.addDrugsView.model = drugDosageModel;
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.addDrugsView];
        
        weakSelf.addDrugsView.sd_layout
        .xIs(0)
        .yIs(0)
        .widthIs(ScreenWidth)
        .heightIs(ScreenHeight);
        
        weakSelf.addDrugsView.addDurgDosageBlock = ^(DrugDosageModel *drugModel) {
            
            [weakSelf.addDrugsView removeFromSuperview];
            
        };
        
        weakSelf.addDrugsView.backBlock = ^(NSString *back) {
            
            [weakSelf.addDrugsView removeFromSuperview];
            
        };
        
    };
    
}

-(void)request:(NSString *)key sort:(NSInteger)sort isDesc:(BOOL)isDesc{
    
    self.drugRequest = [DrugRequest new];
    WS(weakSelf)
    [self.drugRequest getSearchDrugClass_id:self.idString key:key sort_col:sort is_desc:isDesc pageindex:self.page :^(HttpGeneralBackModel *model) {
        
        NSArray *array = model.data;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            
            DrugListModel *drugModel = [DrugListModel new];
            [drugModel setValuesForKeysWithDictionary:dict];
            
            [dataArray addObject:drugModel];
            
        }
        
        [weakSelf.drugListView addData:dataArray];
        
        [weakSelf.drugListView.myTable.mj_header endRefreshing];
        [weakSelf.drugListView.myTable.mj_footer endRefreshing];
        
    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.drugListView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.drugListView.dataSource removeAllObjects];
        [weakSelf request:weakSelf.keyString sort:1 isDesc:YES];
        
    }];
    
    self.drugListView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf request:weakSelf.keyString sort:1 isDesc:YES];
        
    }];
}

@end
