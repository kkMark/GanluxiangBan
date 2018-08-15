//
//  PatientsDetailsView.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/10.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseTableView.h"
#import "PatientsDetailsModel.h"
#import "PatientInfoViewController.h"
#import "SelectGroupViewController.h"
#import "CheckListViewController.h"
#import "PrescriptionDetailsViewController.h"
#import "TreatmentViewController.h"

@interface PatientsDetailsView : BaseTableView

@property (nonatomic, strong) PatientsDetailsModel *model;
@property (nonatomic, strong) void (^goViewControlleBlock)(UIViewController *viewController);

@end
