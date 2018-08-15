//
//  MedicationDetailsModel.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/3.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseModel.h"

@interface MedicationDetailsModel : BaseModel

///医生名字
@property (nonatomic ,copy) NSString *docter_name;
///药品数组
@property (nonatomic ,copy) NSArray *drug_items;
///头像
@property (nonatomic ,copy) NSString *head;
///日志
@property (nonatomic ,copy) NSArray *logs;
///年龄
@property (nonatomic ,assign) NSInteger patient_age;
///性别
@property (nonatomic ,copy) NSString *patient_gender;
///名字
@property (nonatomic ,copy) NSString *patient_name;
///医生二维码
@property (nonatomic ,copy) NSString *cf_qrcode;
///推荐时间
@property (nonatomic ,copy) NSString *recommend_time;
///总价
@property (nonatomic ,copy) NSString *total_price;
///购买状态
@property (nonatomic ,copy) NSString *status;

@end
