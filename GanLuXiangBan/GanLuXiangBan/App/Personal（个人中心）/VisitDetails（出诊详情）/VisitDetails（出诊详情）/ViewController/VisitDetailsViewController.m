//
//  VisitDetailsViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/2.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "VisitDetailsViewController.h"
#import "VisitDetailsView.h"
#import "VisitDetailsViewModel.h"
#import "SortingAreaViewModel.h"

@interface VisitDetailsViewController ()

@property (nonatomic, strong) VisitDetailsView *visitDetailsView;

@end

@implementation VisitDetailsViewController
@synthesize visitDetailsView;

- (void)viewDidLoad {

    [super viewDidLoad];

    [self createHeader];
    [self getDetails];
    [self getHelp];
    
    @weakify(self);
    [self addNavRightTitle:@"确定" complete:^{
        @strongify(self);
        [self saveDetails];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getHospitalList];    
}

- (void)createHeader {
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 3 * i, 0, ScreenWidth / 3, 40)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x919191"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [self.view addSubview:titleLabel];
        
        if (i > 0) {
            
            titleLabel.text = i == 1 ? @"上午" : @"下午";
        }
    }
}

#pragma mark - lazy
- (VisitDetailsView *)visitDetailsView {
    
    if (!visitDetailsView) {
        
        visitDetailsView = [[VisitDetailsView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - self.navHeight - 40) style:UITableViewStyleGrouped];
        [self.view addSubview:visitDetailsView];
        
        @weakify(self);
        [visitDetailsView setGoViewController:^(UIViewController *viewController) {
           
            @strongify(self);
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }
    
    return visitDetailsView;
}

#pragma mark - request
- (void)getDetails {
    
    @weakify(self);
    [[VisitDetailsViewModel new] getWeekScheduleComplete:^(id object) {
       
        @strongify(self);
        self.visitDetailsView.dataSources = @[object, @[@"管理分院区", @"出诊设置帮助"]];
    }];
}

- (void)saveDetails {
    
    @weakify(self);
    [[VisitDetailsViewModel new] saveWeekScheduleWithModel:self.visitDetailsView.dataSources Complete:^(id object) {
        
        @strongify(self);
        [self.view makeToast:object];
    }];
}

- (void)getHospitalList {
    
    @weakify(self);
    [[SortingAreaViewModel new] getHospitalListComplete:^(id object) {
        
        @strongify(self);
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < [object count]; i++) {
            
            SortingAreaModel *model = object[i];
            [arr addObject:model.text];
        }
        
        [arr insertObject:@"本院区" atIndex:0];
        self.visitDetailsView.hospitalList = arr;
    }];
}

- (void)getHelp {
    
    @weakify(self);
    [[VisitDetailsViewModel new] getHelpComplete:^(id object) {
        
        @strongify(self);
        self.visitDetailsView.helpBodyString = object;
        
    }];
}

@end
