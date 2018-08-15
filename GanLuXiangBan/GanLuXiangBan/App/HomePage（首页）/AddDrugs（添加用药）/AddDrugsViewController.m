//
//  AddDrugsViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/6.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "AddDrugsViewController.h"
#import "NinaPagerView.h"
#import "CommonlyDrugViewController.h"
#import "ContinuePrescriptionViewController.h"
#import "AllDrugViewController.h"
#import "LeftMenuView.h"
#import "DrugRequest.h"

@interface AddDrugsViewController ()<NinaPagerViewDelegate>

@property (nonatomic ,assign) NSInteger currentPage;

@property (nonatomic ,strong) ContinuePrescriptionViewController *continuePrescriptionView;

@property (nonatomic ,strong) AllDrugViewController *allDrugView;

@property (nonatomic ,strong) CommonlyDrugViewController *commonlyDrugView;

#pragma mark ----------- 分类 --------------

@property (nonatomic ,strong) UIView *classificationView;

@property (nonatomic, strong) LeftMenuView *leftMenuView;

@property (nonatomic ,retain) DrugRequest *drugRequest;

@property (nonatomic, strong) NSMutableArray *leftDataSource;

@end

@implementation AddDrugsViewController
@synthesize leftMenuView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加用药";
    
    [self addChildViewController];
    
    [self initUI];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ContinuePrescription:) name:@"ContinuePrescription" object:nil];
    
}

-(void)setArray:(NSArray *)array{
    
    _array = array;
    
    self.continuePrescriptionView.array = self.array;
    self.allDrugView.array = self.array;
    self.commonlyDrugView.array = self.array;
}

-(void)addChildViewController{

    self.continuePrescriptionView = [[ContinuePrescriptionViewController alloc] init];
    [self addChildViewController:self.continuePrescriptionView];
    
    self.allDrugView = [[AllDrugViewController alloc] init];
    [self addChildViewController:self.allDrugView];
    
    self.commonlyDrugView = [[CommonlyDrugViewController alloc] init];
    [self addChildViewController:self.commonlyDrugView];
    
}

-(void)initUI{
    
    NSArray *titleArray = @[@"续方",@"所有药品",@"常用药"];
    
    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) WithTitles:titleArray WithVCs:self.childViewControllers];
    ninaPagerView.ninaPagerStyles = NinaPagerStyleStateNormal;
    ninaPagerView.nina_navigationBarHidden = NO;
    ninaPagerView.selectTitleColor = kMainColor;
    ninaPagerView.unSelectTitleColor = [UIColor blackColor];
    ninaPagerView.underlineColor = kMainColor;
    ninaPagerView.selectBottomLinePer = 0.8;
    ninaPagerView.delegate = self;
    [self.view addSubview:ninaPagerView];
    
}

- (void)ninaCurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject{
    
    self.currentPage = currentPage;
    
    if (currentPage == 0) {
        
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
        self.continuePrescriptionView.array = self.array;
        
    }else if (currentPage == 1){
        
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar:)];
        rightBarBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
        self.allDrugView.array = self.array;
        
    }else{
        
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar:)];
        rightBarBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
        self.commonlyDrugView.array = self.array;
        
    }
    
}

-(void)rightBar:(UIBarButtonItem *)sender{
    
    self.classificationView = [UIView new];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.classificationView];
    
    self.classificationView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthIs(ScreenWidth)
    .heightIs(ScreenHeight);
    
    [self classification];

}

-(void)classification{
    
    self.leftDataSource = [NSMutableArray array];
    DrugModel *drugModel = [DrugModel new];
    drugModel.name = @"全部";
    [self.leftDataSource addObject:drugModel];
    
    UIView *bgView = [UIView new];
    bgView .backgroundColor = RGBA(51, 51, 51, 0.7);
    bgView .userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [bgView  addGestureRecognizer:backTap];
    [self.classificationView addSubview:bgView];
    
    bgView.sd_layout
    .leftSpaceToView(self.classificationView, 0)
    .rightSpaceToView(self.classificationView, 0)
    .topSpaceToView(self.classificationView, 0)
    .bottomSpaceToView(self.classificationView, 0);
    
    UILabel *label = [UILabel new];
    label.text = @"分类";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = kMainColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.classificationView addSubview:label];
    
    label.sd_layout
    .rightSpaceToView(self.classificationView, 0)
    .topSpaceToView(self.classificationView, 0)
    .widthIs(ScreenWidth/3)
    .heightIs(64);
    
    self.leftMenuView = [[LeftMenuView alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth / 3, 64, ScreenWidth / 3, ScreenHeight - self.navHeight-50) style:UITableViewStyleGrouped];
    self.leftMenuView.backgroundColor = [UIColor whiteColor];
    self.leftMenuView.showsVerticalScrollIndicator = NO;
    self.leftMenuView.showsHorizontalScrollIndicator = NO;
    [self.classificationView addSubview:self.leftMenuView];
    
    self.leftMenuView.sd_layout
    .rightSpaceToView(self.classificationView, 0)
    .topSpaceToView(self.classificationView, 64)
    .widthIs(ScreenWidth/3)
    .heightIs(ScreenHeight - self.navHeight);
    
    @weakify(self);
    [self.leftMenuView setDidSelectBlock:^(NSInteger currentIndex) {
        
        @strongify(self);
        
        DrugModel *model = self.leftDataSource[currentIndex];
        NSLog(@"%@",model.name);
        
        NSString *string = @"";
        
        if ([model.name isEqualToString:@"全部"]) {
            string = @"";
        }
        
        NSString *idString = model.id;

        if (self.currentPage == 1) {
//            self.allDrugView.keyString = string;
            
            self.allDrugView.idString = idString;
            
        }else if (self.currentPage == 2){
            
//            self.commonlyDrugView.keyString = string;
            
            self.commonlyDrugView.idString = idString;
            
        }
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.leftMenuView.width - 0.5, 0, 0.5, ScreenHeight)];
    lineView.backgroundColor = CurrentLineColor;
    [self.classificationView insertSubview:lineView atIndex:0];
    
    
    self.drugRequest = [DrugRequest new];
    [self.drugRequest getDrug:^(HttpGeneralBackModel *genneralBackModel) {
        
        for (NSDictionary *dict in genneralBackModel.data) {
            
            DrugModel *model = [DrugModel new];
            [model setValuesForKeysWithDictionary:dict];
            model.itmeArray = dict[@"items"];
            [self.leftDataSource addObject:model];
            
        }
        
        self.leftMenuView.dataSources = self.leftDataSource;
        
    }];
    
}

-(void)ContinuePrescription:(NSNotification *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)back{
    
    [self.classificationView removeFromSuperview];
    
}

@end
