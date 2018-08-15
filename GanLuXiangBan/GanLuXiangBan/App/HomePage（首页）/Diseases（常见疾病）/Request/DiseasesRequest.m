//
//  DiseasesRequest.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/4.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "DiseasesRequest.h"

@implementation DiseasesRequest

-(void)getSearchMedicalDiseaseKey:(NSString *)key pageindex:(NSInteger)pageindex complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"MasterData", @"searchMedicalDisease"]];
    self.urlString = [NSString stringWithFormat:@"%@?key=%@&type=1&pagesize=30&pageindex=%ld", self.urlString,key,pageindex];
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

- (void)getdrDiseaseLstKey:(NSString *)key pageindex:(NSInteger)pageindex pagesize:(NSInteger)pagesize complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"drDiseaseLst"]];
    self.urlString = [NSString stringWithFormat:@"%@?key=%@&pageindex=%ld&pagesize=%ld", self.urlString, key,pageindex,pagesize];
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

-(void)postCollectDiseaseId:(DiseaseLibraryModel *)model complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"collectDisease"]];

//    NSNumber * idString =  [NSNumber numberWithInt:(int)model.pkid];
    
    self.parameters = [NSString stringWithFormat:@"%ld",model.pkid];
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *generalBackModel) {

        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

-(void)postDelDrDisease:(DiseaseLibraryModel *)model complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"delDrDisease"]];
     self.parameters = [NSString stringWithFormat:@"%ld",model.id];
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *generalBackModel) {
        
        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

@end
