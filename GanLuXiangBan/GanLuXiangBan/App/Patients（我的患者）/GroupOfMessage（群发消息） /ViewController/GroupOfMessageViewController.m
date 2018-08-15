//
//  GroupOfMessageViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "GroupOfMessageViewController.h"
#import "GroupOfMessageView.h"
#import "GroupOfMessageViewModel.h"
#import "RecipientViewController.h"

@interface GroupOfMessageViewController ()

@property (nonatomic, strong) GroupOfMessageView *groupOfMessageView;
@property (nonatomic, strong) NSArray *groupIds;
@property (nonatomic, strong) NSArray *userIds;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) UIButton *sendMsgBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GroupOfMessageViewController
@synthesize groupOfMessageView;
@synthesize sendMsgBtn;
@synthesize tipLabel;

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"新建群发";
    self.index = @"0";
    [self initGroupOfMessageView];
    [self getCount];
    
    @weakify(self);
    [self addNavRightTitle:@"消息列表" complete:^{
        @strongify(self);
        [self.navigationController pushViewController:[NSClassFromString(@"MessageListViewController") new] animated:YES];
    }];
}

- (void)initGroupOfMessageView {
    
    // 消息
    groupOfMessageView = [[GroupOfMessageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight - 50) style:UITableViewStyleGrouped];
    [self.view addSubview:groupOfMessageView];
    
    // 前往控制器
    @weakify(self);
    [groupOfMessageView setGoViewControllerBlock:^{
       
        @strongify(self);
        RecipientViewController *viewController = [RecipientViewController new];
        [viewController setSelectType:^(NSInteger index, NSArray *groupIds, NSArray *userIds, NSString *nameString) {
            
            self.index = [NSString stringWithFormat:@"%zd", index];
            self.groupIds = groupIds;
            self.userIds = userIds;
            self.groupOfMessageView.typeString = nameString;
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    // 发送消息按钮
    sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMsgBtn.frame = CGRectMake(0, CGRectGetMaxY(groupOfMessageView.frame), ScreenWidth, 50);
    sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendMsgBtn.backgroundColor = kMainColor;
    [sendMsgBtn setTitle:@"发送消息（0/3）" forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sendMsgBtn];
    
    [[sendMsgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self sendMessage];
    }];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sendMsgBtn.y - 25, ScreenWidth, 15)];
    tipLabel.text = @"为了避免影响患者，每天仅限3次";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor redColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
}

#pragma mark - request
- (void)sendMessage {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.groupIds];
    NSString *isAttention = @"0";
    if ([self.groupIds containsObject:@(-1)]) {
        
        isAttention = @"1";
        [arr removeObject:@(-1)];
        self.groupIds = arr;
    }
    
    [[GroupOfMessageViewModel new] sendMessageWithContent:groupOfMessageView.textView.text
                                               reciveType:self.index
                                                   labels:self.groupIds
                                                     mids:self.userIds
                                              isAttention:isAttention
                                                 complete:^(id object)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[UIApplication sharedApplication].keyWindow makeToast:object];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)getCount {
    
    @weakify(self);
    [[GroupOfMessageViewModel new] getCountComplete:^(id object) {
     
        @strongify(self);
        NSString *sendString = [NSString stringWithFormat:@"发送消息（%@/%@）", object[@"count"], object[@"total"]];
        [self.sendMsgBtn setTitle:sendString forState:UIControlStateNormal];
        self.tipLabel.text = [NSString stringWithFormat:@"为了避免影响患者，每天仅限%@次", object[@"total"]];
        
        if ([object[@"count"] intValue] == [object[@"total"] intValue]) {
            
            self.sendMsgBtn.enabled = NO;
            [self.sendMsgBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
    }];
}

@end
