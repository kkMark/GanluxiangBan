//
//  DruguseCell.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/18.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "DruguseCell.h"

@interface DruguseCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation DruguseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubview];
    }
    
    return self;
}


#pragma mark - lazy
- (void)setupSubview {
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpacing + 15, 15, ScreenWidth / 2, 15)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:self.nameLabel];
    
    self.introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpacing + 15, CGRectGetMaxY(self.nameLabel.frame) + 10, ScreenWidth / 2, 15)];
    self.introduceLabel.font = [UIFont boldSystemFontOfSize:13];
    self.introduceLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:self.introduceLabel];
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpacing + 15, CGRectGetMaxY(self.introduceLabel.frame) + 10, 0, 15)];
    self.noteLabel.width = ScreenWidth - self.noteLabel.x - 15;
    self.noteLabel.font = [UIFont boldSystemFontOfSize:13];
    self.noteLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    self.noteLabel.numberOfLines = 0;
    [self.contentView addSubview:self.noteLabel];
    
    self.cellHeight = CGRectGetMaxY(self.introduceLabel.frame) + 15;
}

- (void)setModel:(DruguseModel *)model {
    
    self.noteLabel.hidden = YES;
    self.nameLabel.text = model.drug_name;
    self.introduceLabel.text = model.dosage;
    self.cellHeight = CGRectGetMaxY(self.introduceLabel.frame) + 15;

    if (model.remark.length > 0) {
        
        self.noteLabel.hidden = NO;
        self.noteLabel.text = model.remark;
        self.noteLabel.height = [self.noteLabel getTextHeight];
        self.cellHeight += self.noteLabel.height + 15;
    }
}

@end
