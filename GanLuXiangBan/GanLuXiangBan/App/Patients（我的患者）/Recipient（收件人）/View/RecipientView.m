//
//  RecipientView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/10.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "RecipientView.h"
#import "RecipientCell.h"
#import "RecipientListCell.h"
#import "GroupEditorModel.h"
#import "PatientListViewController.h"

@interface RecipientView ()

@property (nonatomic, assign) CGFloat selectSectionIndex;
@property (nonatomic, assign) CGFloat selectRowIndex;

@end

@implementation RecipientView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.contents = [NSMutableArray array];
        self.userInfos = [NSMutableArray array];
        self.rowHeight = 60;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (self.selectSectionIndex == section) {
        return 2 + self.dataSources.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 60 - 1, ScreenWidth, 1)];
            lineView.backgroundColor = kPageBgColor;
            [cell addSubview:lineView];
            
            UIImage *img = [UIImage imageNamed:@"Home_DownTriangle"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            imgView.size = img.size;
            cell.accessoryView = imgView;
        }
        
        if (self.selectSectionIndex == indexPath.section) cell.imageView.image = [UIImage imageNamed:@"SelectRecipient"];
        else cell.imageView.image = [UIImage imageNamed:@"NoSelectPatients"];
        
        NSArray *titles = @[@"所有患者", @"部分收到", @"部分不可见"];
        NSArray *detailTexts = @[@"", @"选中的分组/个人可收到", @"选中的分组/个人不可收到"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = titles[indexPath.section];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
        cell.detailTextLabel.text = detailTexts[indexPath.section];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0x919191"];
        return cell;
    }
    else if (indexPath.row == self.dataSources.count + 1) {
        
        RecipientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientListCell"];
        if (cell == nil) {
            cell = [[RecipientListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipientListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.idInfos = self.userInfos;
        return cell;
    }
    else {
        
        RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientCell"];
        if (cell == nil) {
            cell = [[RecipientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipientCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GroupEditorModel *model = self.dataSources[indexPath.row - 1];
        cell.titleLabel.text = model.name;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == self.dataSources.count + 1) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (GroupAddModel *model in self.userInfos) {
            [arr addObject:model.mid];
        }
        
        PatientListViewController *viewController = [PatientListViewController new];
        viewController.selectIdArray = arr;
        [viewController setCompleteBlock:^(id object) {
            [self.userInfos removeAllObjects];
            [self.userInfos addObjectsFromArray:object];
            [self reloadData];
        }];
        self.goViewControllerBlock(viewController);
    }
    else if (indexPath.row == 0) {
        
        [self.contents removeAllObjects];
        [self.userInfos removeAllObjects];
        self.currentIndex = indexPath.section;
        
        for (int i = 0; i < self.dataSources.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:self.selectSectionIndex];
            RecipientCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.isSelect = NO;
            
            [self.contents removeAllObjects];
        }
    }
    else {
        
        RecipientCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect = !cell.isSelect;
        
        GroupEditorModel *model = self.dataSources[indexPath.row - 1];
        if (cell.isSelect) {
            [self.contents addObject:model];
        }
        else [self.contents removeObject:model];
    }

    self.selectSectionIndex = indexPath.section;
    self.selectRowIndex = indexPath.row;
    
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 60;
    }
    else if (indexPath.row == self.dataSources.count + 1 && self.userInfos.count > 0) {
        return 65;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
