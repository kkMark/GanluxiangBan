//
//  SelHospitalViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/2.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "SelHospitalViewController.h"
#import "SearchView.h"
#import "HospitalView.h"
#import "HospitalViewModel.h"

@interface SelHospitalViewController ()

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) HospitalView *hospitalView;
@property (nonatomic, strong) HospitalViewModel *viewModel;

@end

@implementation SelHospitalViewController
@synthesize hospitalView;
@synthesize viewModel;

- (void)viewDidLoad {

    [super viewDidLoad];

    [self createSearchView];
    [self getList];
}

// 创建搜索框
- (void)createSearchView {
    
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
    [self.view addSubview:self.searchView];
    
    @weakify(self);
    [self.searchView setSearchBlock:^(NSString *searchTextString) {

        @strongify(self);
        if (self.hospitalView.cityString.length == 0) {
            
            return [self.view makeToast:@"请选择城市之后再进行搜索"];
        }
        else {
            
            [self queryHospitalWithTitle:searchTextString];
        }
    }];
}

#pragma mark - request
- (void)getList {
    
    [self.viewModel getHospitalListComplete:^(id object) {
       
        if (![object isKindOfClass:[NSError class]]) {
            self.hospitalView.dataSources = object;
        }
    }];
}

- (void)queryHospitalWithTitle:(NSString *)title {
    
    [self.viewModel queryHospitalWithTitle:title city:self.hospitalView.cityString complete:^(id object) {
       
        if (![object isKindOfClass:[NSError class]]) {
            self.hospitalView.dataSources = object;
        }
    }];
}

#pragma mark - lazy
- (HospitalViewModel *)viewModel {
    
    if (!viewModel) {
        viewModel = [HospitalViewModel new];
    }
    
    return viewModel;
}

- (HospitalView *)hospitalView {
    
    if (!hospitalView) {
        
        hospitalView = [[HospitalView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), ScreenWidth, self.view.height - CGRectGetMaxY(self.searchView.frame)) style:UITableViewStyleGrouped];
        [self.view addSubview:hospitalView];
        
        @weakify(self);
        [hospitalView setDidSelectBlock:^(NSString *string) {
         
            @strongify(self);
            self.completeBlock(string);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [RACObserve(self.hospitalView, cityString) subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            if (self.hospitalView.cityString.length > 0) {
                [self queryHospitalWithTitle:@""];
            }
        }];
    }
    
    return hospitalView;
}

@end
