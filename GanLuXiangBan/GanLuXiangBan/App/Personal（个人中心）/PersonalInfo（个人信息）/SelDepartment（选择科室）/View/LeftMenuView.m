//
//  LeftMenuView.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/22.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "LeftMenuView.h"

@implementation LeftMenuView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self setupSubviews];
    }
    
    return self;
}

- (UITextField *)textField {
    
    UITextField *textField = [UITextField new];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = @"其他科室";
    textField.textColor = kMainColor;
    [textField setValue:[UIColor colorWithHexString:@"0x333333"] forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}

- (void)setupSubviews {
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setDataSources:(NSArray *)dataSources {
    
    [super setDataSources:dataSources];
    if (self.didSelectBlock) {
        self.didSelectBlock(0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rowHeight - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = CurrentLineColor;
        [cell addSubview:lineView];
    }
    
    if (indexPath.row == self.selectIndex) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = kMainColor;
    }
    else {
        cell.backgroundColor = self.backgroundColor;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    }
    
    if (self.dataSources.count > 0) {
        
        DrugModel *model = self.dataSources[indexPath.row];
        cell.textLabel.text = model.name;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DrugModel *model = self.dataSources[indexPath.row];
    if (![model.name isEqualToString:@"其他科室"]) {
        
        self.selectIndex = (int)indexPath.row;
        [self reloadData];
        
        if (self.didSelectBlock) {
            self.didSelectBlock(indexPath.row);
        }
    }
    else {
        
        [self showTitleAlertWithMsg:@"请填写其他科室" isCancel:YES completeBlock:^(id object) {
            
            if (self.backBlock) {
                self.backBlock(object);
            }
        }];
    }
}

@end
