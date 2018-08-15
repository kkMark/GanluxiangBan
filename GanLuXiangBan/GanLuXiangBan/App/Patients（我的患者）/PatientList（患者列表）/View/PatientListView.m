//
//  PatientListView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PatientListView.h"
#import "PatientsModel.h"
#import "PatientListCell.h"

@interface PatientListView ()

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSArray *keys;

@end

@implementation PatientListView

#pragma mark - set
- (void)setDictDataSource:(NSDictionary *)dictDataSource {
    
    _dictDataSource = dictDataSource;
    self.defaultImgView.hidden = [dictDataSource count] > 0 ? YES : NO;
    self.keys = [dictDataSource.allKeys sortedArrayUsingSelector:@selector(compare:)];
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictDataSource[self.keys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[PatientListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    cell.model = self.dictDataSource[self.keys[indexPath.section]][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dictDataSource];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:dict[self.keys[indexPath.section]]];
    
    PatientsModel *model = arr[indexPath.row];
    model.isSelect = !model.isSelect;
    [arr replaceObjectAtIndex:indexPath.row withObject:model];
    [dict setObject:arr forKey:self.keys[indexPath.section]];
    
    self.dictDataSource = dict;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
    }
    headerView.textLabel.text = self.keys[section];
    headerView.textLabel.font = [UIFont systemFontOfSize:16];
    return headerView;
}

@end
