//
//  GroupOfMessageViewModel.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HttpRequest.h"

@interface GroupOfMessageViewModel : HttpRequest

- (void)sendMessageWithContent:(NSString *)content
                    reciveType:(NSString *)reciveType
                        labels:(NSArray *)labels
                          mids:(NSArray *)mids
                   isAttention:(NSString *)isAttention
                      complete:(void (^)(id object))complete;

- (void)getCountComplete:(void (^)(id object))complete;;

@end
