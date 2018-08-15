//
//  RecDrugsViewController.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseViewController.h"
#import "RecDrugsModel.h"
#import "InitialRecipeInfoModel.h"

typedef void(^RecDrugsSaveBlock)(RecDrugsModel *recDrugsModel);

@interface RecDrugsViewController : BaseViewController

@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,retain) RecDrugsModel *model;

@property (nonatomic ,retain) InitialRecipeInfoModel *initialRecipeInfoModel;

@property (nonatomic ,copy) NSString *mid;

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *age;

@property (nonatomic ,copy) NSString *gender;

@property (nonatomic ,copy) NSString *serialNumber;

@property (nonatomic ,copy) NSString *dataString;

@property (nonatomic ,copy) RecDrugsSaveBlock recDrugsSaveBlock;

@end
