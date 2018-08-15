//
//  DrugViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/5/25.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "DrugViewController.h"
#import "DrugRequest.h"
#import "LeftMenuView.h"
#import "DrugRightView.h"
#import "DrugListViewController.h"
#import "CollectionViewController.h"
#import "SearchView.h"

@interface DrugViewController ()

@property (nonatomic ,strong) SearchView *searchView;
@property (nonatomic, strong) LeftMenuView *leftMenuView;
@property (nonatomic, strong) DrugRightView *rightMenuView;
@property (nonatomic ,retain) DrugRequest *drugRequest;
@property (nonatomic, strong) NSMutableArray *leftDataSource;
@property (nonatomic, strong) NSMutableArray *rightDataSource;
@property (nonatomic ,strong) UIButton *collectionButton;

@end

@implementation DrugViewController
@synthesize leftMenuView;
@synthesize rightMenuView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的药箱";
    self.leftDataSource = [NSMutableArray array];
    self.rightDataSource = [NSMutableArray array];

    [self initUI];
    
    [self request];
    
    [self block];
    
}

-(void)initUI{
    
    self.searchView = [SearchView new];
    [self.view addSubview:self.searchView];
    
    self.searchView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(50);
    
    self.collectionButton = [UIButton new];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.collectionButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.collectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionButton setBackgroundColor: kMainColor];
    [self.collectionButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionButton];
    
    self.collectionButton.sd_layout
    .centerYEqualToView(self.view)
    .widthIs(ScreenWidth)
    .heightIs(50)
    .bottomSpaceToView(self.view, 0);
    
}

- (void)request{
    
    self.drugRequest = [DrugRequest new];
    [self.drugRequest getDrug:^(HttpGeneralBackModel *genneralBackModel) {
       
        for (NSDictionary *dict in genneralBackModel.data) {

            DrugModel *model = [DrugModel new];
            [model setValuesForKeysWithDictionary:dict];
            model.itmeArray = dict[@"items"];
            [self.leftDataSource addObject:model];

            if (self.rightDataSource.count == 0) {

                for (NSDictionary *rightDict in model.itmeArray) {

                    DrugModel *rightModel = [DrugModel new];
                    [rightModel setValuesForKeysWithDictionary:rightDict];
                    [self.rightDataSource addObject:rightModel];
                }
            }
        }
        
        self.leftMenuView.dataSources = self.leftDataSource;
        self.rightMenuView.dataSource = self.rightDataSource;
        
    }];
}

-(void)block{
    
    WS(weakSelf)
    
    [self.searchView setSearchBlock:^(NSString *searchTextString) {
        
        DrugListViewController *drugListView = [[DrugListViewController alloc] init];
        drugListView.keyString = searchTextString;
        drugListView.searchString = searchTextString;
        [drugListView request:searchTextString sort:0 isDesc:YES];
        
        [weakSelf.navigationController pushViewController:drugListView animated:YES];
        
    }];
    
}

#pragma mark - lazy
- (LeftMenuView *)leftMenuView {
    
    if (!leftMenuView) {
        
        leftMenuView = [[LeftMenuView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth / 3, ScreenHeight - self.navHeight-100) style:UITableViewStyleGrouped];
        leftMenuView.backgroundColor = [UIColor clearColor];
        leftMenuView.showsVerticalScrollIndicator = NO;
        leftMenuView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:leftMenuView];
        
        @weakify(self);
        [leftMenuView setDidSelectBlock:^(NSInteger currentIndex) {
            
            @strongify(self);
            
            DrugModel *model = self.leftDataSource[currentIndex];
            [self.rightDataSource removeAllObjects];
            
            for (NSDictionary *rightDict in model.itmeArray) {
                DrugModel *rightModel = [DrugModel new];
                [rightModel setValuesForKeysWithDictionary:rightDict];
                [self.rightDataSource addObject:rightModel];
            }
            self.rightMenuView.dataSource = self.rightDataSource;
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftMenuView.width - 0.5, 0, 0.5, ScreenHeight)];
        lineView.backgroundColor = CurrentLineColor;
        [self.view insertSubview:lineView atIndex:0];
    }
    
    return leftMenuView;
}

- (DrugRightView *)rightMenuView {
    
    if (!rightMenuView) {
        
        rightMenuView = [[DrugRightView alloc] initWithFrame:CGRectMake(ScreenWidth / 3, 50, ScreenWidth / 3 * 2, self.leftMenuView.height)];
        rightMenuView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:rightMenuView];
        
        @weakify(self);
        [rightMenuView setDidSelectBlock:^(NSString *idString) {
            @strongify(self);
            
            DrugListViewController *drugListView = [[DrugListViewController alloc] init];
            drugListView.idString = idString;
            [self.navigationController pushViewController:drugListView animated:YES];
            
        }];
    }
    
    return rightMenuView;
}

-(void)collection:(UIButton *)sender{
    
    CollectionViewController *collectionView = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionView animated:YES];
    
}

@end
