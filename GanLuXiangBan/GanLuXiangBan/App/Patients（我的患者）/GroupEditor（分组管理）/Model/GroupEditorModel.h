//
//  GroupEditorModel.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/8.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseModel.h"

@interface GroupEditorModel : BaseModel

@property (nonatomic, strong) NSString *label;
/// 名字
@property (nonatomic, strong) NSString *name;
/// 数量
@property (nonatomic, strong) NSString *count;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@end
