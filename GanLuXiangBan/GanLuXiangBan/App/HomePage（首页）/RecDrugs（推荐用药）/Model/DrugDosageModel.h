//
//  DrugDosageModel.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/6.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseModel.h"

@interface DrugDosageModel : BaseModel

///药品ID
@property (nonatomic ,copy) NSString *drugid;
///数量
@property (nonatomic ,copy) NSString *use_num;
///用法
@property (nonatomic ,copy) NSString *use_type;
///未知
@property (nonatomic ,copy) NSString *days;
///一次
@property (nonatomic ,copy) NSString *day_use;
///一天几次
@property (nonatomic ,copy) NSString *day_use_num;
///备注
@property (nonatomic ,copy) NSString *remark;
///药品code
@property (nonatomic ,copy) NSString *drug_code;
///药品名称
@property (nonatomic ,copy) NSString *drug_name;
///规格
@property (nonatomic ,copy) NSString *standard;
///单位名称
@property (nonatomic ,copy) NSString *unit_name;

@end
