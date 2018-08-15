//
//  GroupOfMessageViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "GroupOfMessageViewModel.h"

@implementation GroupOfMessageViewModel

- (void)sendMessageWithContent:(NSString *)content
                    reciveType:(NSString *)reciveType
                        labels:(NSArray *)labels
                          mids:(NSArray *)mids
                   isAttention:(NSString *)isAttention
                      complete:(void (^)(id))complete
{
    if (labels.count == 0) {
        labels = @[@"0"];
        mids = @[@"0"];
    }
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"SendDrNotice"]];
    
    if ([isAttention integerValue] == 1) {
        
        self.parameters = @{ @"content" : content,
                             @"recive_type" : reciveType,
                             @"label" : labels,
                             @"mids" : mids,
                             @"is_attention" : @"true"};
        
    }else{
        
        self.parameters = @{ @"content" : content,
                             @"recive_type" : reciveType,
                             @"label" : labels,
                             @"mids" : mids,
                             @"is_attention" : @"false"};
        
    }
    
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel.retcode == 0 ? @"发送消息成功" : genneralBackModel.retmsg);
        }
        
    } failure:nil];
}

- (void)getCountComplete:(void (^)(id))complete {
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"DrNoticeSendCount"]];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSDictionary *dict = @{@"count" : genneralBackModel.data[@"send_count"], @"total" : genneralBackModel.data[@"total"]};
        if (complete) {
            complete(dict);
        }
        
    } failure:nil];
}

@end
