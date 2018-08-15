//
//  HomeRequest.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/5/15.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HomeRequest.h"


@implementation HomeRequest

- (void)getBanner:(void (^)(HttpGeneralBackModel *model))complete{
    
    self.urlString = [self getRequestUrl:@[@"MasterData", @"banner"]];

    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *generalBackModel) {

        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
    }];
    
}

- (void)getIndexInfo:(void (^)(HomeModel *model))complete{
    
    self.urlString = [self getRequestUrl:@[@"Msg", @"IndexInfo"]];
    
    HomeModel *model = [HomeModel new];
    
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *generalBackModel) {
        
        [model setValuesForKeysWithDictionary:generalBackModel.data];
        
        if (complete) {
            complete(model);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(model);
        }
        
    }];
    
}

- (void)postUpdateDrHeadUrl:(NSString *)urlString :(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"user", @"updateDrHead"]];
    self.parameters = urlString;
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

- (void)getMsgListLoad_type:(NSString *)Load_type :(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Msg", @"MsgList"]];
    self.urlString = [NSString stringWithFormat:@"%@?load_type=%@&pageindex=1&pagesize=10", self.urlString,Load_type];
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getIsSign:(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"isSign"]];

    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *generalBackModel) {

        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getUnreadForMyPatient:(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Doctor", @"unreadForMyPatient"]];
    
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *generalBackModel) {
        
        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getNoticeList:(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"Msg", @"NoticeList"]];
    
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *generalBackModel) {
        
        if (complete) {
            complete(generalBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getZeroPushNum:(NSString *)client_id :(void (^)(HttpGeneralBackModel *generalBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"MasterData", @"zeroPushNum"]];
    self.urlString = [NSString stringWithFormat:@"%@?client_id=%@", self.urlString,client_id];
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
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
