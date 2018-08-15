//
//  PaySetViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/11.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PaySetViewController.h"
#import "PaySetViewModel.h"
#import "PaidConsultingViewModel.h"
#import "PaySetView.h"

@interface PaySetViewController ()

@property (nonatomic, strong) PaySetView *paySetView;

@end

@implementation PaySetViewController
@synthesize paySetView;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"付费设置";
    
    @weakify(self);
    [self addNavRightTitle:@"保存" complete:^{
        @strongify(self);
        [self save];
    }];
    [self getDataSource];
}


#pragma mark - lazy
- (PaySetView *)paySetView {
    
    if (!paySetView) {
        
        paySetView = [[PaySetView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:paySetView];
    }
    
    return paySetView;
}


#pragma mark - request
- (void)getDataSource {
    
    [[PaySetViewModel new] getPatientVisit:self.mid complete:^(id object) {
        self.paySetView.prices = object;
        self.paySetView.dataSources = @[@"图文咨询", @"电话咨询", @"线下咨询"];
    }];
}

- (void)save {
    
    __block int a = 0;
    for (PaySetModel *model in self.paySetView.prices) {
        
        [[PaySetViewModel new] saveVisitDetailWithModel:model ids:@[self.mid] complete:^(id object) {
            
            if (a == 0) {
                
                [self.view makeToast:object];
            }
            
            a += 1;
        }];
    }
}

@end
