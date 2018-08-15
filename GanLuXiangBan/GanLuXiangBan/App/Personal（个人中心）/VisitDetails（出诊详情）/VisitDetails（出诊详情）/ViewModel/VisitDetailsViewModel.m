//
//  VisitDetailsViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/2.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "VisitDetailsViewModel.h"

@implementation VisitDetailsViewModel

- (void)getWeekScheduleComplete:(void (^)(id))complete {
    
    self.urlString = [self getRequestUrl:@[@"DrSchedule", @"WeekSchedule"]];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *weekDict in genneralBackModel.data) {
            
            VisitDetailsModel *model = [VisitDetailsModel new];
            [model setDict:weekDict];
            [arr addObject:model];
        }
        
        if (complete) {
            complete(arr);
        }
        
    } failure:nil];
}

- (void)saveWeekScheduleWithModel:(NSArray *)details Complete:(void (^)(id))complete {
    
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < [details[0] count]; i++) {
        
        VisitDetailsModel *model = details[0][i];
        NSDictionary *amDict = @{ @"week" : model.week,
                                  @"time" : @"上午",
                                  @"clinic_type" : model.amType,
                                  @"location" : model.amHospital };
        
        NSDictionary *pmDict = @{ @"week" : model.week,
                                  @"time" : @"下午",
                                  @"clinic_type" : model.pmType,
                                  @"location" : model.pmHospital };
        
        [values addObjectsFromArray:@[amDict, pmDict]];
    }
    
    self.urlString = [self getRequestUrl:@[@"DrSchedule", @"SaveSchedule"]];
    self.parameters = values;
    [self requestSystemWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            
            complete(genneralBackModel.retcode == 0 ? @"保存成功" : genneralBackModel.retmsg);
        }
        
    } failure:nil];
}

- (void)getHelpComplete:(void (^)(id object))complete {
    
    self.urlString = [self getRequestUrl:@[@"MasterData", @"scheduleHelp"]];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {

        if (complete) {
            complete(genneralBackModel.data);
        }
        
    } failure:nil];
}

@end
