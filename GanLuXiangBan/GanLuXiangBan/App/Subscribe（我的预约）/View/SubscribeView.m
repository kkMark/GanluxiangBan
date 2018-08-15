//
//  SubscribeView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/17.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "SubscribeView.h"
#import "SubscribeCell.h"
#import "SubscribeDetailsViewController.h"

@interface SubscribeView ()

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation SubscribeView
@synthesize headerView;

#pragma mark - set
- (void)setModel:(SubscribeCountModel *)model {
    
    _model = model;
    self.tableHeaderView = self.headerView;
}


#pragma mark - lazy
- (UIView *)headerView {
    
    if (!headerView) {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"预约成功", @"待处理", @"预约失败"];
        for (int i = 0; i < titles.count; i++) {
            
            UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bgBtn.frame = CGRectMake(ScreenWidth / 3 * i, 0, ScreenWidth / 3, headerView.height);
            [headerView addSubview:bgBtn];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, bgBtn.width, 15)];
            titleLabel.text = titles[i];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [bgBtn addSubview:titleLabel];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 15, bgBtn.width, 25)];
            numberLabel.tag = i + 100;
            numberLabel.text = @"0";
            numberLabel.font = [UIFont boldSystemFontOfSize:20];
            numberLabel.textColor = kMainColor;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.height = [numberLabel getTextHeight];
            [bgBtn addSubview:numberLabel];
            
            @weakify(self);
            [[bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
               
                @strongify(self);
                if (self.selectTypeBlock) {
                    self.selectTypeBlock(i);
                }
                
                for (int i = 0; i < 3; i++) {
                    
                    UILabel *numberLabel = [self.headerView viewWithTag:i + 100];
                    numberLabel.textColor = kMainColor;
                }
                
                numberLabel.textColor = [UIColor redColor];
            }];
            
            headerView.height = bgBtn.height = CGRectGetMaxY(numberLabel.frame) + 15;
            
            if (i > 0) {
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 3 * i, 15, 0.5, bgBtn.height - 30)];
                lineView.backgroundColor = kLineColor;
                [headerView addSubview:lineView];
            }
        }
    }
    
    if (self.model != nil) {
        
        NSArray *numbers = @[self.model.success_num, self.model.pend_num, self.model.fail_num];
        for (int i = 0; i < 3; i++) {
            
            UILabel *numberLabel = [headerView viewWithTag:i + 100];
            numberLabel.text = numbers[i];
        }
    }
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[SubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.model = self.dataSources[indexPath.row];
    self.cellHeight = cell.cellHeight;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    SubscribeModel *model = self.dataSources[indexPath.row];
    
    SubscribeDetailsViewController *vc = [SubscribeDetailsViewController new];
    vc.idString = model.pkid;
    self.goViewController(vc);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

@end
