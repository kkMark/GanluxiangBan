//
//  GroupEditorViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/8.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "GroupEditorViewController.h"
#import "GroupEditorViewModel.h"
#import "GroupEditorView.h"

@interface GroupEditorViewController ()

@property (nonatomic, strong) GroupEditorView *groupEditorView;

@end

@implementation GroupEditorViewController
@synthesize groupEditorView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"分组管理";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getLabelList];
}

#pragma mark - lazy
- (GroupEditorView *)groupEditorView {
    
    if (!groupEditorView) {
        
        groupEditorView = [[GroupEditorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight - 50) style:UITableViewStyleGrouped];
        [self.view addSubview:groupEditorView];
        
        @weakify(self);
        [groupEditorView setGoViewControllerBlock:^(UIViewController *viewController) {
            @strongify(self);
            [self.navigationController pushViewController:viewController animated:YES];
        }];
        
        UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addGroupBtn.frame = CGRectMake(0, ScreenHeight - 50 - self.navHeight, ScreenWidth, 50);
        addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        addGroupBtn.backgroundColor = kMainColor;
        [addGroupBtn setTitle:@"新建分组" forState:UIControlStateNormal];
        [addGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:addGroupBtn];
        
        [[addGroupBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.navigationController pushViewController:[NSClassFromString(@"GroupAddViewController") new] animated:YES];
        }];
    }
    
    return groupEditorView;
}

#pragma mark - request
- (void)getLabelList {
    
    [[GroupEditorViewModel new] getLabelListComplete:^(id object) {
        self.groupEditorView.dataSources = object;
    }];
}

@end
