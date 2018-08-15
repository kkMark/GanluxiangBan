//
//  HomeMessgeModel.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/12.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseModel.h"

@interface HomeMessgeModel : BaseModel
///mid
@property (nonatomic ,copy) NSString *mid;
///msg_id
@property (nonatomic ,copy) NSString *msg_id;
///名字
@property (nonatomic ,copy) NSString *name;
///内容
@property (nonatomic ,copy) NSString *content;
///头像
@property (nonatomic ,copy) NSString *logo;
///消息时间
@property (nonatomic ,copy) NSString *create_time;
///消息类型
@property (nonatomic ,copy) NSString *msg_type;
///消息来源
@property (nonatomic ,copy) NSString *msg_source;
///未读
@property (nonatomic ,copy) NSString *unread;

@end
