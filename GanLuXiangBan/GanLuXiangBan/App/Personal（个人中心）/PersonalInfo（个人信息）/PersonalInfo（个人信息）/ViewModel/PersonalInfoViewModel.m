//
//  PersonalInfoViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PersonalInfoViewModel.h"

@implementation PersonalInfoViewModel

// 上传用户信息
- (void)uploadUserInfoWithModel:(PersonalInfoModel *)model complete:(void (^)(id))complete {
    
    self.urlString = [self getRequestUrl:@[@"user", @"updateDoctor"]];
    self.parameters = [self getParametersWithClass:model];
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(@"");
        }
        
    } failure:^(NSError *error) {
    
        if (complete) {
            complete(error);
        }
    }];
}

// 获取医生个人信息
- (void)getDoctorInfoWithId:(NSString *)idString complete:(void (^)(PersonalInfoModel *))complete {

    self.urlString = [self getRequestUrl:@[@"user", @"DoctorInfo"]];
    self.urlString = [NSString stringWithFormat:@"%@?id=%@", self.urlString, idString];
    
    PersonalInfoModel *model = [PersonalInfoModel new];
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        [model setValuesForKeysWithDictionary:genneralBackModel.data];
        if (complete) {
            complete(model);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(model);
        }
    }];
}

// 身份认证信息
- (void)getDoctorFilesInfoWithId:(NSString *)idString complete:(void (^)(PersonalInfoModel *))complete {
    
    self.urlString = [self getRequestUrl:@[@"user", @"doctorFiles"]];
    self.urlString = [NSString stringWithFormat:@"%@?drid=%@", self.urlString, idString];
    
    PersonalInfoModel *model = [PersonalInfoModel new];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        [model setValuesForKeysWithDictionary:genneralBackModel.data];
        if (complete) {
            complete(model);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(model);
        }
    }];
}

@end
