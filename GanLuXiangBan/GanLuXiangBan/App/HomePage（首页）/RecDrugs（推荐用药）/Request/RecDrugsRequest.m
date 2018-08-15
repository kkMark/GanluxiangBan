//
//  RecDrugsRequest.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "RecDrugsRequest.h"
#import "NSString+ToJSON.h"
@implementation RecDrugsRequest


-(void)getInitialTmpRecipecomplete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"initialTmpRecipe"]];
    
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

-(void)getInitialRecipeInfo:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Patient", @"InitialRecipeInfo"]];
    
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

-(void)getXufangItemsMid:(NSString *)mid :(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"xufangItems"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@&pageindex=1&pagesize=100", self.urlString,@"0"];
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

-(void)postSaveTmpRecipe:(RecDrugsModel *)model :(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"saveTmpRecipe"]];
    self.parameters = [self getParametersWithClass:model];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict addEntriesFromDictionary:self.parameters];
    
    NSArray *array = [self.parameters allKeys];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *string = array[i];
        
        if ([string isEqualToString:@"druguse_items"]) {
            
            [dict setObject:model.druguse_items forKey:@"druguse_items"];
            
        }
        
    }
    
    self.parameters = dict;
    
    [self requestSystemWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

-(void)postInitialRecipeInfo:(InitialRecipeInfoModel *)model :(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Patient", @"InitialRecipeInfo"]];
    self.parameters = [self getParametersWithClass:model];
//    self.parameters = @{@"mid":@"3391",@"medical_id":@"62306",@"drugs":@[@{@"drug_code":@"1002107",@"qty":@"1"}]};
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

-(void)getRecipeDruguseCheck_id:(NSString *)check_id Recipelist_id:(NSString *)recipelist_id :(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Patient", @"recipeDruguse"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@&check_id=%@", self.urlString,check_id,recipelist_id];
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
