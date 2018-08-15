//
//  PaySetViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/11.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PaySetViewModel.h"

@implementation PaySetViewModel

- (void)getPatientVisit:(NSString *)mid complete:(void (^)(id object))complete {
    
    self.urlString = [self getRequestUrl:@[@"Visit", @"patientVisit"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@", self.urlString, mid];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in genneralBackModel.data) {
         
            PaySetModel *model = [PaySetModel new];
            [model setValuesForKeysWithDictionary:dict];
            [arr addObject:model];
        }
        
        if (complete) {
            complete(arr);
        }
        
    } failure:nil];
}

- (void)saveVisitDetailWithModel:(PaySetModel *)model ids:(NSArray *)ids complete:(void (^)(id object))complete {
    
    NSDictionary *dict = @{@"visit_type" : model.visit_type, @"pay_money" : model.pay_money, @"mids" : ids};
    
    self.urlString = [self getRequestUrl:@[@"Visit", @"saveVisitForPatients"]];
    self.parameters = dict;
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        complete(genneralBackModel.retcode == 0 ? @"保存成功" : genneralBackModel.retmsg);
        
    } failure:nil];
}

@end
