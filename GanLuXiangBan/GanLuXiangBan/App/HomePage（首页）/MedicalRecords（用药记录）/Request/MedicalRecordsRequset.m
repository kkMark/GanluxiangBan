//
//  MedicalRecordsRequset.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/5/27.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "MedicalRecordsRequset.h"
#import "XmlDrugRequest.h"
@implementation MedicalRecordsRequset

- (void)getMedicationRecordsKey:(NSString *)key page:(NSInteger)page complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"medicationRecords"]];
    self.urlString = [NSString stringWithFormat:@"%@?key=%@&pageindex=%ld", self.urlString, key,page];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

- (void)getMedicatinDetailRecipe_id:(NSInteger)recipe_id status:(NSString *)status complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"medicatinDetail"]];
    if ([status isEqualToString:@"-1"]){
        
        self.urlString = [NSString stringWithFormat:@"%@?recipe_id=%ld&status=2", self.urlString, recipe_id];
        
    }else if (status != nil && ![status isEqualToString:@"null"]) {
        
        self.urlString = [NSString stringWithFormat:@"%@?recipe_id=%ld&status=1", self.urlString, recipe_id];
        
    }else{
        
        self.urlString = [NSString stringWithFormat:@"%@?recipe_id=%ld&status=0", self.urlString, recipe_id];
        
    }
    
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

@end
