//
//  FillInDataRequestModel.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/5/14.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseModel.h"

@interface FillInDataRequestModel : BaseModel
///userid
@property (nonatomic ,copy) NSString *pkid;
///名字
@property (nonatomic ,copy) NSString *Name;
///性别
@property (nonatomic ,copy) NSString *Gender;
///科室号
@property (nonatomic ,copy) NSString *HispitalId;
///医院名字
@property (nonatomic ,copy) NSString *HispitalName;
///科室
@property (nonatomic ,copy) NSString *CustName;
///职称
@property (nonatomic ,copy) NSString *Title;
///简介
@property (nonatomic ,copy) NSString *Introduction;
///擅长
@property (nonatomic ,copy) NSString *Remark;

@end
