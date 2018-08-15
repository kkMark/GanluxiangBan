//
//  PatientListViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PatientListViewController.h"
#import "PatientsViewModel.h"
#import "PatientListView.h"

@interface PatientListViewController ()

@property (nonatomic, strong) PatientListView *patientListView;

@end

@implementation PatientListViewController
@synthesize patientListView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"患者列表";
    [self getDataSource];
    
    @weakify(self);
    [self addNavRightTitle:@"确定" complete:^{
        
        @strongify(self);
        if (self.completeBlock) {
            
            NSArray *keys = self.patientListView.dictDataSource.allKeys;
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < keys.count; i++) {
                
                NSArray *values = self.patientListView.dictDataSource[keys[i]];
                for (PatientsModel *model in values) {
                    
                   if (model.isSelect) {
                        
                        GroupAddModel *groupAddModel = [GroupAddModel new];
                        groupAddModel.mid = model.mid;
                        groupAddModel.head = model.head;
                        groupAddModel.patient_name = model.membername;
                        [arr addObject:groupAddModel];
                    }
                }
            }
            
            self.completeBlock(arr);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - patientListView
- (PatientListView *)patientListView {
    
    if (!patientListView) {
        
        patientListView = [[PatientListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:patientListView];
    }
    
    return patientListView;
}


#pragma mark - request
- (void)getDataSource {
    
    [[PatientsViewModel new] getDrPatientWithIds:self.selectIdArray complete:^(id object) {
        self.patientListView.dictDataSource = object;
    }];
}

@end
