//
//  RecDrugsTableViewCell.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "RecDrugsTableViewCell.h"

@implementation RecDrugsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

-(void)setModel:(DrugDosageModel *)model{
    
    _model = model;
    
    self.drugNameLabel.text = model.drug_name;
    
    self.usageLabel.text = [NSString stringWithFormat:@"一天%@次， 一次%@%@，%@",model.day_use,model.day_use_num,model.unit_name,model.use_type];
    
    self.remarksLabel.text = model.remark;
    
    self.amountLabel.text = [NSString stringWithFormat:@"X%@",model.use_num];
    
    if (model.remark == nil) {
        
        [self setupAutoHeightWithBottomView:self.usageLabel bottomMargin:10];
        
    }else{
        
        [self setupAutoHeightWithBottomView:self.remarksLabel bottomMargin:10];
        
    }
    
}

-(void)setupUI{
    
    self.compileLabel = [UILabel new];
    self.compileLabel.textColor = [UIColor orangeColor];
    self.compileLabel.font = [UIFont systemFontOfSize:14];
    self.compileLabel.text = @"编辑";
    self.compileLabel.textAlignment = NSTextAlignmentCenter;
    self.compileLabel.layer.borderWidth = 1;
    self.compileLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.contentView addSubview:self.compileLabel];
    
    self.compileLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(60)
    .heightIs(20);
    
    self.drugNameLabel = [UILabel new];
    self.drugNameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.drugNameLabel];
    
    self.drugNameLabel.sd_layout
    .leftSpaceToView(self.compileLabel, 15)
    .topSpaceToView(self.contentView, 15)
    .heightIs(16);
    [self.drugNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.usageLabel = [UILabel new];
    self.usageLabel.font = [UIFont systemFontOfSize:14];
//    self.usageLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.usageLabel];
    
    self.usageLabel.sd_layout
    .leftSpaceToView(self.compileLabel, 15)
    .topSpaceToView(self.drugNameLabel, 10)
    .heightIs(14);
    [self.usageLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.remarksLabel = [UILabel new];
    self.remarksLabel.font = [UIFont systemFontOfSize:14];
    self.remarksLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.remarksLabel];
    
    self.remarksLabel.sd_layout
    .leftSpaceToView(self.compileLabel, 15)
    .topSpaceToView(self.usageLabel, 10)
    .widthRatioToView(self.contentView, 0.7)
    .heightIs(14);
    
    self.amountLabel = [UILabel new];
    self.amountLabel.textColor = [UIColor lightGrayColor];
    self.amountLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.amountLabel];
    
    self.amountLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .heightIs(14);
    [self.amountLabel setSingleLineAutoResizeWithMaxWidth:100];
    
}

@end
