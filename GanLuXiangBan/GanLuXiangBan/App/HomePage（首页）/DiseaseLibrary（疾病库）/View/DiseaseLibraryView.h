//
//  DiseaseLibraryView.h
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/4.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiseaseLibraryModel.h"

typedef void(^CollectBlock)(DiseaseLibraryModel *model);

typedef void(^CollectDeleteBlock)(DiseaseLibraryModel *model);

@interface DiseaseLibraryView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *myTable;

@property (nonatomic ,retain) NSMutableArray *dataSource;

@property (nonatomic ,assign) NSInteger typeInteger;

@property (nonatomic ,copy) CollectBlock collectBlock;

@property (nonatomic ,copy) CollectDeleteBlock collecDeleteBlock;

-(void)addData:(NSArray *)array;

@end
