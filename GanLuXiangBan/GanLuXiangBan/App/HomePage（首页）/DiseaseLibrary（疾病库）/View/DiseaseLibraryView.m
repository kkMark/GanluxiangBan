//
//  DiseaseLibraryView.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/4.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "DiseaseLibraryView.h"
#import "DiseaseLibraryTableViewCell.h"

@implementation DiseaseLibraryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataSource = [NSMutableArray array];
        
        [self initUI];
        
    }
    
    return self;
    
}

-(void)addData:(NSArray *)array{
    
    [self.dataSource addObjectsFromArray:array];
    
    [self.myTable reloadData];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.myTable.frame = self.bounds;
    
}

-(void)setTypeInteger:(NSInteger)typeInteger{
    
    _typeInteger = typeInteger;
    
    [self.myTable reloadData];
    
}

-(void)initUI{
    
    self.myTable = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];/**< 初始化_tableView*/
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.myTable];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiseaseLibraryModel *model = self.dataSource[indexPath.row];
    // 获取cell高度
    return [self.myTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DiseaseLibraryTableViewCell class]  contentViewWidth:[self cellContentViewWith]];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"DiseaseLibraryTableViewCell";

    DiseaseLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell)
    {
        cell = [[DiseaseLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.type = self.typeInteger;
    cell.model = self.dataSource[indexPath.row];
    cell.collectButton.tag = indexPath.row;
    [cell.collectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectImage.tag = indexPath.row;
    cell.collectImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *collectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectTap:)];
    [cell.collectImage addGestureRecognizer:collectTap];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.typeInteger == 1) {
        
        DiseaseLibraryModel *model = self.dataSource[indexPath.row];
        
        if (self.collectBlock) {
            self.collectBlock(model);
        }
        
    }

}

-(void)collect:(UIButton *)sender{
    
    DiseaseLibraryModel *model = self.dataSource[sender.tag];
    
    if (model.disease_id == 0) {
        
        if (self.collectBlock) {
            self.collectBlock(model);
        }
        
    }
    
}

-(void)collectTap:(UITapGestureRecognizer *)sender{
 
    DiseaseLibraryModel *model = self.dataSource[sender.view.tag];
    
    if (self.collecDeleteBlock) {
        self.collecDeleteBlock(model);
    }
    
}

@end
