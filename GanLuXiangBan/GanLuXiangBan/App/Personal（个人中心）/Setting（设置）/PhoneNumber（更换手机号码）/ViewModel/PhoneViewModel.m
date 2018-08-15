//
//  PhoneViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/8.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PhoneViewModel.h"

@implementation PhoneViewModel

// 获取验证码
- (void)getMobileCodeWithPhone:(NSString *)phone complete:(void (^)(id))complete {
    
    self.urlString = [self getRequestUrl:@[@"MasterData", @"GetMobileCode"]];
    self.parameters = @{ @"mobileno" : phone, @"type" : @"3" };
    [self requestSystemWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel.retcode == 0 ? @"发送验证码成功" : genneralBackModel.retmsg);
        }
        
    } failure:nil];
}

- (void)updateWithMobileno:(NSString *)mobileno code:(NSString *)code  complete:(void (^)(id))complete {
    
    self.urlString = [self getRequestUrl:@[@"user", @"updateMobile"]];
    self.parameters = @{ @"mobileno" : mobileno, @"code" : code };
    [self requestSystemWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel.retcode == 0 ? @"修改成功" : genneralBackModel.retmsg);
        }
        
    } failure:nil];
}

@end
