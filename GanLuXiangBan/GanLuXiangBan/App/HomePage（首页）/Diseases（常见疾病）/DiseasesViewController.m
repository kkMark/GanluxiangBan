//
//  DiseasesViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/4.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "DiseasesViewController.h"
#import "DiseaseLibraryViewController.h"
#import "DiseasesRequest.h"
#import "DiseaseLibraryView.h"
#import "BaseView.h"

@interface DiseasesViewController ()

@property (nonatomic ,strong) UIButton *collectionButton;

@property (nonatomic ,strong) DiseaseLibraryView *diseaseLibraryView;

@property (nonatomic ,copy) NSString *keyString;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic ,assign) BOOL isEdit;

@property (nonatomic ,strong) UIBarButtonItem *rightBarBtn;

@end

@implementation DiseasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"常用疾病";
    
    [self initNav];
    
    [self initUI];

    [self refresh];
    
    [self block];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.keyString = @"";
    
    self.page = 1;
    
    [self.diseaseLibraryView.dataSource removeAllObjects];
    
    [self request:self.keyString page:self.page];
    
}

-(void)initNav{
    
    self.isEdit = NO;
    
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar:)];
    self.rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    
}

-(void)rightBar:(UIBarButtonItem *)sender{
    
    if (self.isEdit == YES) {
        
        self.isEdit = NO;
        
        self.rightBarBtn.title = @"编辑";
        
        self.diseaseLibraryView.typeInteger = 1;
        
        
    }else{
        
        self.isEdit = YES;
        
        self.rightBarBtn.title = @"完成";
        
        self.diseaseLibraryView.typeInteger = 2;

    }
    
}

-(void)initUI{

    self.collectionButton = [UIButton new];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.collectionButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.collectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionButton setBackgroundColor: kMainColor];
    [self.collectionButton addTarget:self action:@selector(addDiseases:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionButton];
    
    self.collectionButton.sd_layout
    .centerYEqualToView(self.view)
    .widthIs(ScreenWidth)
    .heightIs(50)
    .bottomSpaceToView(self.view, 0);
    
    self.diseaseLibraryView = [DiseaseLibraryView new];
    self.diseaseLibraryView.typeInteger = 1;
    [self.view addSubview:self.diseaseLibraryView];
    
    self.diseaseLibraryView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.collectionButton, 0);
    
}

-(void)addDiseases:(UIButton *)sender{
    
    DiseaseLibraryViewController *diseaseLibraryView = [[DiseaseLibraryViewController alloc] init];
    [self.navigationController pushViewController:diseaseLibraryView animated:YES];
    
}

-(void)request:(NSString *)key page:(NSInteger)page{
    WS(weakSelf);
    
    [[DiseasesRequest new] getSearchMedicalDiseaseKey:self.keyString pageindex:self.page complete:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dict in genneralBackModel.data) {
            
            DiseaseLibraryModel *model = [DiseaseLibraryModel new];
            [model setValuesForKeysWithDictionary:dict];
            
            [dataArray addObject:model];
            
        }
        
        [weakSelf.diseaseLibraryView addData:dataArray];
        
        [weakSelf.diseaseLibraryView.myTable.mj_header endRefreshing];
        [weakSelf.diseaseLibraryView.myTable.mj_footer endRefreshing];
        
    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.diseaseLibraryView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.diseaseLibraryView.dataSource removeAllObjects];
        [weakSelf request:weakSelf.keyString page:weakSelf.page];
        
    }];
    
    self.diseaseLibraryView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf request:weakSelf.keyString page:weakSelf.page];
        
    }];
}

-(void)block{
    WS(weakSelf);
    self.diseaseLibraryView.collecDeleteBlock = ^(DiseaseLibraryModel *model) {
        
        [[DiseasesRequest new] postDelDrDisease:model complete:^(HttpGeneralBackModel *genneralBackModel) {
           
            weakSelf.page = 1;
            [weakSelf.diseaseLibraryView.dataSource removeAllObjects];
            [weakSelf request:weakSelf.keyString page:weakSelf.page];
            
        }];
        
    };
    
}

@end
