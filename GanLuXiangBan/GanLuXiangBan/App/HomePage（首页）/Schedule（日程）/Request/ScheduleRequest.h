//
//  ScheduleRequest.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/12.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HttpRequest.h"

@interface ScheduleRequest : HttpRequest

/**
 日程列表
 
 */
-(void)getPreOrderListPageindex:(NSInteger)pageindex :(void (^)(HttpGeneralBackModel *genneralBackModel))complete;

@end
