//
//  MedicalRecordsTableViewCell.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/3.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "MedicalRecordsTableViewCell.h"

@implementation MedicalRecordsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

-(void)setModel:(MedicalRecordsModel *)model{
    
    _model = model;
    
    self.recipeLabel.text = [NSString stringWithFormat:@"%ld",model.recipe_id];
    
    if ([model.status isEqualToString:@"0001"]) {
        self.statusLabel.text = @"已支付";
        self.statusLabel.textColor = kMainColor;
    }else if ([model.status isEqualToString:@"0000"]){
        self.statusLabel.text = @"未支付";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([model.status isEqualToString:@"-1"]){
        self.statusLabel.text = @"未生效";
        self.statusLabel.textColor = [UIColor blackColor];
    }else if ([model.status isEqualToString:@"0004"]){
        self.statusLabel.text = @"已取消";
        self.statusLabel.textColor = [UIColor blackColor];
    }else if ([model.status isEqualToString:@"0009"]){
        self.statusLabel.text = @"已配货";
    }else if ([model.status isEqualToString:@"0005"]){
        self.statusLabel.text = @"已发货";
    }else if ([model.status isEqualToString:@"0006"]){
        self.statusLabel.text = @"已收货";
    }else{
        self.statusLabel.text = @"未购买";
        self.statusLabel.textColor = [UIColor redColor];
    }

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"Home_HeadDefault"]];
    
    self.patient_nameLabel.text = model.patient_name;
    
    self.patient_genderLebl.text = model.patient_gender;
    
    self.patient_ageLabel.text = [NSString stringWithFormat:@"%ld岁",model.patient_age];
    
    self.drug_namesLabel.text = model.drug_names;
    
    self.createtimeLabel.text = model.createtime;
    
}

-(void)setupUI{
    
    UIView *view = [UIView new];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:5.0];
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGB(237, 237, 237).CGColor;
    [self.contentView addSubview:view];
    
    view.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10);
    
    self.recipeLabel = [UILabel new];
    self.recipeLabel.font = [UIFont systemFontOfSize:14];
    self.recipeLabel.textColor = [UIColor lightGrayColor];
    [view addSubview:self.recipeLabel];
    
    self.recipeLabel.sd_layout
    .leftSpaceToView(view, 15)
    .topSpaceToView(view, 18)
    .heightIs(14);
    [self.recipeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = [UIImage imageNamed:@"Home_RightArrow"];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:rightImageView];
    
    rightImageView.sd_layout
    .rightSpaceToView(view, 15)
    .centerYEqualToView(self.recipeLabel)
    .widthIs(14)
    .heightEqualToWidth();
    
    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = kMainColor;
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.statusLabel];
    
    self.statusLabel.sd_layout
    .rightSpaceToView(rightImageView, 15)
    .centerYEqualToView(self.recipeLabel)
    .heightIs(16);
    [self.statusLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGB(237, 237, 237);
    [view addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(view, 15)
    .rightSpaceToView(view, 15)
    .topSpaceToView(self.recipeLabel, 18)
    .heightIs(1);
    
    self.headImageView = [UIImageView new];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView.layer setCornerRadius:20.0];
    [view addSubview:self.headImageView];
    
    self.headImageView.sd_layout
    .leftSpaceToView(view, 15)
    .topSpaceToView(lineView, 10)
    .widthIs(40)
    .heightEqualToWidth();
    
    UIView *line1View = [UIView new];
    line1View.backgroundColor = RGB(237, 237, 237);
    [view addSubview:line1View];
    
    line1View.sd_layout
    .leftSpaceToView(view, 15)
    .rightSpaceToView(view, 15)
    .topSpaceToView(self.headImageView, 10)
    .heightIs(1);
    
    self.patient_nameLabel = [UILabel new];
    self.patient_nameLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.patient_nameLabel];
    
    self.patient_nameLabel.sd_layout
    .leftSpaceToView(self.headImageView, 15)
    .topSpaceToView(lineView, 10)
    .heightIs(16);
    [self.patient_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.patient_genderLebl = [UILabel new];
    self.patient_genderLebl.textColor = [UIColor lightGrayColor];
    self.patient_genderLebl.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.patient_genderLebl];
    
    self.patient_genderLebl.sd_layout
    .leftSpaceToView(self.headImageView, 15)
    .bottomSpaceToView(line1View, 10)
    .heightIs(14);
    [self.patient_genderLebl setSingleLineAutoResizeWithMaxWidth:200];
    
    self.patient_ageLabel = [UILabel new];
    self.patient_ageLabel.textColor = [UIColor lightGrayColor];
    self.patient_ageLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.patient_ageLabel];
    
    self.patient_ageLabel.sd_layout
    .leftSpaceToView(self.patient_genderLebl, 15)
    .centerYEqualToView(self.patient_genderLebl)
    .heightIs(14);
    [self.patient_ageLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.drug_namesLabel = [UILabel new];
    self.drug_namesLabel.font = [UIFont systemFontOfSize:16];
    self.drug_namesLabel.textColor = [UIColor lightGrayColor];
    [view addSubview:self.drug_namesLabel];
    
    self.drug_namesLabel.sd_layout
    .leftSpaceToView(view, 15)
    .topSpaceToView(line1View, 10)
    .heightIs(16);
    [self.drug_namesLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.createtimeLabel = [UILabel new];
    self.createtimeLabel.textColor = [UIColor lightGrayColor];
    self.createtimeLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.createtimeLabel];
    
    self.createtimeLabel.sd_layout
    .rightSpaceToView(view, 15)
    .topSpaceToView(self.drug_namesLabel, 10)
    .heightIs(14);
    [self.createtimeLabel setSingleLineAutoResizeWithMaxWidth:200];

}
@end
