//
//  HospitalView.h
//  GanLuXiangBan
//
//  Created by M on 2018/5/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseTableView.h"
#import "CitySelectView.h"

@interface HospitalView : BaseTableView

@property (nonatomic ,strong) CitySelectView *citySelectView;
/// 省字段
@property (nonatomic, strong) NSString *provinceString;
/// 城市字段
@property (nonatomic, strong) NSString *cityString;

@property (nonatomic, strong) void (^didSelectBlock)(NSString *string);

@end
