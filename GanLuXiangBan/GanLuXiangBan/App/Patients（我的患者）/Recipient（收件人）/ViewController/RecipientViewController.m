//
//  RecipientViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/10.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "RecipientViewController.h"
#import "RecipientView.h"
#import "GroupEditorViewModel.h"
#import "GroupAddModel.h"

@interface RecipientViewController ()

@property (nonatomic, strong) RecipientView *recipientView;

@end

@implementation RecipientViewController
@synthesize recipientView;

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"收件人";
    [self getLabelList];
    
    @weakify(self);
    [self addNavRightTitle:@"确定" complete:^{
     
        @strongify(self);
        NSMutableString *nameString = [NSMutableString string];
        NSMutableArray *groupIds = [NSMutableArray array];
        for (GroupEditorModel *model in self.recipientView.contents) {
            
            [groupIds addObject:[NSNumber numberWithInt:[model.label intValue]]];
            [nameString appendFormat:@"%@, ", model.name];
        }
        
        NSMutableArray *userIds = [NSMutableArray array];
        for (GroupAddModel *model in self.recipientView.userInfos) {
            [userIds addObject:[NSNumber numberWithInt:[model.mid intValue]]];
            [nameString appendFormat:@"%@, ", model.patient_name];
        }
        
        NSString *tempSting;
        if (nameString.length > 15) {
            tempSting = [nameString substringWithRange:NSMakeRange(0, 15)];
        }
        else if (nameString.length > 1) {
            tempSting = [nameString substringWithRange:NSMakeRange(0, nameString.length - 2)];
        }
        
        NSInteger index = self.recipientView.currentIndex;
        if (self.selectType) {
            self.selectType(index, groupIds, userIds, tempSting);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - lazy
- (RecipientView *)recipientView {
    
    if (!recipientView) {
        
        recipientView = [[RecipientView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:recipientView];
        
        @weakify(self);
        [recipientView setGoViewControllerBlock:^(UIViewController *viewController) {
            @strongify(self);
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }
    
    return recipientView;
}


#pragma mark - request
- (void)getLabelList {
    
    [[GroupEditorViewModel new] getLabelListComplete:^(id object) {
        
        GroupEditorModel *model = [GroupEditorModel new];
        model.name = @"特别关心";
        model.label = @"-1";
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:object];
        [arr addObject:model];
        self.recipientView.dataSources = arr;
    }];
}

@end
