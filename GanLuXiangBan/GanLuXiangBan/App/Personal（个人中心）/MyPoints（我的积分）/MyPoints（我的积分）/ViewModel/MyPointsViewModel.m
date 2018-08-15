//
//  MyPointsViewModel.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/2.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "MyPointsViewModel.h"
#import "MyPointModel.h"
#import "MyPointDetailsModel.h"

@implementation MyPointsViewModel

- (void)getPointWithPage:(NSInteger)page
              recordType:(NSString *)recordType
               pointDate:(NSString *)pointDate
                complete:(void (^)(id))complete
{
    self.urlString = [self getRequestUrl:@[@"Doctor", @"myPoints"]];
    self.parameters = @{ @"pageindex" : [NSNumber numberWithInteger:page],
                         @"pagesize": @10,
                         @"record_type" : recordType,
                         @"point_date" : pointDate };

    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dict = genneralBackModel.data;
        NSDictionary *pageInfoDict = (NSDictionary *)genneralBackModel.pageinfo;
        
        MyPointModel *model = [MyPointModel new];
        [model setValuesForKeysWithDictionary:dict];
        [model setValuesForKeysWithDictionary:pageInfoDict];
        
        NSMutableArray *details = [NSMutableArray array];
        for (NSDictionary *detailDict in dict[@"details"]) {
            
            for (NSDictionary *itemsDict in detailDict[@"items"]) {
                
                MyPointDetailsModel *detailsModel = [MyPointDetailsModel new];
                detailsModel.year_month = [detailDict valueForKey:@"year_month"];
                [detailsModel setValuesForKeysWithDictionary:itemsDict];
                [details addObject:detailsModel];
            }
        }
        
        model.detailList = details;
        [arr addObject:model];

        if (complete) {
            complete(arr);
        }
        
    } failure:nil];
}

- (void)pointExchangeWithBankId:(NSString *)bankId
                       pointNum:(NSString *)pointNumber
                       complete:(void (^)(id object))complete
{
    self.urlString = [self getRequestUrl:@[@"Doctor", @"pointExchange"]];
    self.parameters = @{ @"bank_id" : bankId, @"point_num": pointNumber };
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel.retcode == 0 ? @"兑换成功" : genneralBackModel.retmsg);
        }

    } failure:nil];
}

@end
