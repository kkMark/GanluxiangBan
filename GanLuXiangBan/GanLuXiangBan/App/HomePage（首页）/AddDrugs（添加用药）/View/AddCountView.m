//
//  AddCountView.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "AddCountView.h"

@implementation AddCountView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    
    return self;
    
}

-(void)initUI{
    
    self.layer.borderColor = RGB(237, 237, 237).CGColor;
    self.layer.borderWidth = 1;
    
    UIButton *subtractButton = [UIButton new];
    [subtractButton setTitle:@"-" forState:UIControlStateNormal];
    [subtractButton setBackgroundColor:RGB(237, 237, 237)];
    [subtractButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subtractButton addTarget:self action:@selector(subtract:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:subtractButton];
    
    subtractButton.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .widthIs(40)
    .heightIs(30);
    
    self.addLabel = [UILabel new];
    self.addLabel.font = [UIFont systemFontOfSize:14];
    self.addLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.addLabel];
    
    self.addLabel.sd_layout
    .leftSpaceToView(subtractButton, 0)
    .centerYEqualToView(self)
    .widthIs(60)
    .heightIs(14);
    
    UIButton *addButton = [UIButton new];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setBackgroundColor:RGB(237, 237, 237)];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    
    addButton.sd_layout
    .leftSpaceToView(self.addLabel, 0)
    .topSpaceToView(self, 0)
    .widthIs(40)
    .heightIs(30);
    
}

-(void)setAddCountString:(NSString *)addCountString{
    
    _addCountString = addCountString;
    
    self.addLabel.text = addCountString;
    
}

-(void)add:(UIButton *)sender{
    
    if (self.addBlock) {
        self.addBlock(self.addLabel.text);
    }
    
}

-(void)subtract:(UIButton *)sender{
    
    if (self.subtractBlock) {
        self.subtractBlock(self.addLabel.text);
    }
    
}

@end
