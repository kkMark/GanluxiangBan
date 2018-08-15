//
//  HomeMessgeView.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/7.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "BaseView.h"
#import "HomeMessgeModel.h"

typedef void(^PushBlock)(HomeMessgeModel *model);

@interface HomeMessgeView : BaseView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *myTable;

@property (nonatomic ,retain) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic ,copy) PushBlock pushBlock;

-(void)addData:(NSArray *)array;

@end
