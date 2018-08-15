//
//  MyPointsViewModel.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/2.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HttpRequest.h"

@interface MyPointsViewModel : HttpRequest


/**
     获取积分

     @param page 页数 - 默认传1
     @param recordType 记录类型 - 0、所有 1、收入 -1、支出
     @param pointDate 积分时间 - 本月传0、前N个月传-N
     @param complete 成功回调
 */
- (void)getPointWithPage:(NSInteger)page
              recordType:(NSString *)recordType
               pointDate:(NSString *)pointDate
                complete:(void (^)(id object))complete;



/**
     提取积分

     @param bankId 银行卡ID
     @param pointNumber 积分数量
     @param complete 成功回调
 */
- (void)pointExchangeWithBankId:(NSString *)bankId
                       pointNum:(NSString *)pointNumber
                       complete:(void (^)(id object))complete;

@end
