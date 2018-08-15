//
//  TrendView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/20.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "TrendView.h"
#import "TrendTypeView.h"
#import "TrendLineChart.h"

@interface TrendView ()

@property (nonatomic, strong) TrendTypeView *trendTypeView;
@property (nonatomic, strong) TrendLineChart *trendLineChart;

@end

@implementation TrendView
@synthesize trendTypeView;
@synthesize trendLineChart;

#pragma mark - set
- (void)setModel:(TrendModel *)model {
    
    _model = model;
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *charts = [NSMutableArray array];
    for (TrendItemsModel *itemModel in model.items) {
        
        [arr addObject:itemModel.chk_demo_name];
        
        NSMutableArray *numbers = [NSMutableArray array];
        for (NSString *number in itemModel.chk_values) {
            [numbers addObject:[NSNumber numberWithInt:[number intValue]]];
        }
        
        [charts addObject:AAObject(AASeriesElement).nameSet(itemModel.chk_demo_name).dataSet(numbers)];
    }
    
    if (self.allTypes.count == 0) {
        self.allTypes = arr;
    }
    
    self.trendLineChart.dates = self.model.dates;
    self.trendLineChart.charts = charts;
    self.trendTypeView.types = arr;
}


#pragma mark - lazy
- (TrendTypeView *)trendTypeView {
    
    if (!trendTypeView) {
        
        trendTypeView = [[TrendTypeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [self addSubview:trendTypeView];
    }
    
    return trendTypeView;
}

- (TrendLineChart *)trendLineChart {
    
    if (!trendLineChart) {
        
        trendLineChart = [[TrendLineChart alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight - 70)];
        trendLineChart.backgroundColor = [UIColor whiteColor];
        [self addSubview:trendLineChart];
    }
    
    return trendLineChart;
}

@end
