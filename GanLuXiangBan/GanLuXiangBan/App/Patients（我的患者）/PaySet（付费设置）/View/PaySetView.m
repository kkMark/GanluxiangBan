//
//  PaySetView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/11.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PaySetView.h"
#import "PaySetCell.h"
#import "TipCell.h"
#import "SelectPriceView.h"

@interface PaySetView ()

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) SelectPriceView *selectPriceView;

@end

@implementation PaySetView
@synthesize selectPriceView;

#pragma mark - lazy
- (SelectPriceView *)selectPriceView {
    
    if (!selectPriceView) {
        
        selectPriceView = [[SelectPriceView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self addSubview:selectPriceView];
        
        @weakify(self);
        [selectPriceView setDidTextStringBlock:^(NSString *textString) {
            
            @strongify(self);
            [self endEditing:NO];
            self.selectPriceView.isShowList = !self.selectPriceView.isShowList;
            
            PaySetModel *model = self.prices[self.row];
            if ([textString intValue] > 0) {
                
                model.pay_money = textString;
            }
            else if ([textString isEqualToString:@"自定义价格"]) {
                
                [self showTitleAlertWithMsg:@"请输入价格" isCancel:YES completeBlock:^(id object) {
                    
                    model.pay_money = object;
                    
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.prices];
                    [arr replaceObjectAtIndex:self.row withObject:model];
                    
                    self.prices = arr;
                    [self reloadData];
                }];
            }
            else {
                
                model.is_open = @"0";
                model.pay_money = @"-1";
            }
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.prices];
            [arr replaceObjectAtIndex:self.row withObject:model];
            
            self.prices = arr;
            [self reloadData];
        }];
    }
    
    return selectPriceView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSources.count == indexPath.row) {
        
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipCell"];
        if (cell == nil) {
            cell = [[TipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.tipContent = @"1、修改价格后，当前咨询不受影响，收费将在下次咨询生效。\n"
        "2、图文咨询设置收费后，患者须先付费才能发起咨询。\n"
        "3、图文咨询默认有效期为24小时，或经医患双方沟通由医生主动结束咨询。\n"
        "4、医生主动发起图文咨询，则患者无需付费。\n"
        "5、电话/线下咨询，由患者主动发起，并由客服与您确认咨询的时间(地点)后由患者付费成交";
        self.cellHeight = cell.tipCellHeight;
        return cell;
    }
    
    PaySetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaySetCell"];
    if (cell == nil) {
        cell = [[PaySetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaySetCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.dataSources[indexPath.row];
    cell.model = self.prices[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSources.count == indexPath.row) {
        return self.cellHeight;
    }
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (self.dataSources.count != indexPath.row) {
        
        self.row = indexPath.row;
        if (indexPath.row == 0) {
            self.selectPriceView.priceArr = @[@"0", @"19", @"29", @"39", @"自定义价格"];
        }
        else {
            self.selectPriceView.priceArr = @[@"29", @"39", @"49", @"59", @"自定义价格", @"未开通"];
        }
        
        [self endEditing:YES];
        self.selectPriceView.hidden = NO;
        self.selectPriceView.isShowList = !self.selectPriceView.isShowList;
    }
}

@end
