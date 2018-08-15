//
//  PatientListCell.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PatientListCell.h"

@interface PatientListCell ()

/// 头像
@property (nonatomic, strong) UIImageView *imgView;
/// 昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
/// 信息
@property (nonatomic, strong) UILabel *infoLabel;
/// 分组
@property (nonatomic, strong) UILabel *groupNameLabel;

@end

@implementation PatientListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    
    // 头像
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.imgView.layer.cornerRadius = self.imgView.height / 2;
    self.imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imgView];
    
    // 昵称
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10, 15, ScreenWidth / 2, 15)];
    self.nickNameLabel.text = @"测试";
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    self.nickNameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:self.nickNameLabel];

    // 信息
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10, CGRectGetMaxY(self.nickNameLabel.frame) + 10, ScreenWidth / 2, 15)];
    self.infoLabel.text = @"测试";
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    self.infoLabel.textColor = [UIColor colorWithHexString:@"0x919191"];
    [self.contentView addSubview:self.infoLabel];
 
    // 分组昵称
    self.groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 2, 15)];
    self.groupNameLabel.x = ScreenWidth - ScreenWidth / 2 - 15;
    self.groupNameLabel.centerY = self.nickNameLabel.centerY;
    self.groupNameLabel.font = [UIFont systemFontOfSize:14];
    self.groupNameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    self.groupNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.groupNameLabel];

    // 选中
    UIImage *img = [UIImage imageNamed:@"SelectPatients"];
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.size = CGSizeMake(15, 15);
    self.selectBtn.centerY = self.infoLabel.centerY;
    self.selectBtn.x = ScreenWidth - self.selectBtn.width - 15;
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"NoSelectPatients"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:img forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
}

- (void)setModel:(PatientsModel *)model {
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.head]];
    self.nickNameLabel.text = model.membername;
    self.groupNameLabel.text = model.label_name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@岁", model.gender, model.age];
    self.selectBtn.selected = model.isSelect;
}

@end
