//
//  MessageListViewModel.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/10.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HttpRequest.h"
#import "MessageListModel.h"

@interface MessageListViewModel : HttpRequest

- (void)getDrNoticeListWithPage:(NSString *)page complete:(void (^)(id object))complete;

@end
