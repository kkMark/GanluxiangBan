//
//  TrendView.h
//  GanLuXiangBan
//
//  Created by M on 2018/6/20.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"

@interface TrendView : UIView

@property (nonatomic, strong) TrendModel *model;
@property (nonatomic, strong) NSArray *allTypes;

@end
