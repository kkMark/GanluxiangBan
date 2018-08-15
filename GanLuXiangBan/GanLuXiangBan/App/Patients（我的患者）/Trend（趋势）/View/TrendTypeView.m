//
//  TrendTypeView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/20.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "TrendTypeView.h"

@implementation TrendTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setTypes:(NSArray *)types {
    
    _types = types;
    
    // 线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = kLineColor;
    [self addSubview:lineView];
    
    // 展开按钮
    UIButton *unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unfoldBtn.frame = CGRectMake(ScreenWidth - 50, 5, 50, 45);
    unfoldBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [unfoldBtn setTitle:@"展开" forState:UIControlStateNormal];
    [unfoldBtn setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateNormal];
    [self addSubview:unfoldBtn];
    
    [[unfoldBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        UIButton *tempBtn = (UIButton *)x;
        tempBtn.selected = !tempBtn.selected;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.height = 55 + self.maxHeight * tempBtn.selected;
            lineView.y = self.height - 0.5;
        }];
    }];
    
    // 类型按钮
    CGFloat x = 15;
    CGFloat y = 15;
    UIButton *button;
    for (int i = 0; i < types.count; i++) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, 0, 25);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [[UIColor colorWithHexString:@"0xfeac37"] CGColor];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:types[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"0xfeac37"] forState:UIControlStateNormal];
        button.width = [button.titleLabel getTextWidth] + 15;
        [self addSubview:button];
        
        if (button.x + button.width > unfoldBtn.x - 5) {
        
            x = 15;
            y += (button.height + 15);
            button.x = x;
            button.y = y;
        }
        
        
        x += (button.width + 10);
        if (x > unfoldBtn.x - 5) {
            
            x = 10;
            y += (button.height + 15);
        }
    }
    
    self.maxHeight = button.y - 15;
}

@end
