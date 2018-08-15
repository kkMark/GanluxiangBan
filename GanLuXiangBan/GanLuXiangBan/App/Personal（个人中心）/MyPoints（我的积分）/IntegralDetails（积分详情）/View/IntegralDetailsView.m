//
//  IntegralDetailsView.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/14.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "IntegralDetailsView.h"
#import "MyPointDetailsModel.h"

@implementation IntegralDetailsView

- (void)setDictDataSource:(NSDictionary *)dictDataSource {
    
    _dictDataSource = dictDataSource;
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dictDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictDataSource[self.keys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
        numberLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.textColor = [UIColor colorWithHexString:@"0x4bd6a"];
        numberLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = numberLabel;
    }
    
    NSArray *dataSource = self.dictDataSource[self.keys[indexPath.section]];
    MyPointDetailsModel *model = dataSource[indexPath.row];

    UILabel *numberLabel = (UILabel *)cell.accessoryView;
    numberLabel.text = model.integral_number;
    numberLabel.textColor = [UIColor colorWithHexString:@"0x4bd6a"];
    if ([numberLabel.text containsString:@"-"]) {
        numberLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = model.detail_description;
    cell.detailTextLabel.text = model.integral_date;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0xc6c6c6"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self.keys count] > 0) {
        
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
        }
        headerView.textLabel.text = self.keys[section];
        headerView.textLabel.font = [UIFont systemFontOfSize:16];
        return headerView;
    }
    
    return nil;
}

@end
