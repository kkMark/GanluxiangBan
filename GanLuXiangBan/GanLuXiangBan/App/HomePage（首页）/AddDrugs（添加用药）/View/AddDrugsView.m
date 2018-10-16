//
//  AddDrugsView.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/7.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "AddDrugsView.h"

@implementation AddDrugsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        [self initUI];
        
        [self block];
        
    }
    
    return self;
    
}

-(void)setModel:(DrugDosageModel *)model{
    
    _model = model;
    
    self.drugNameLabel.text = model.drug_name;
    
    self.standardLabel.text = model.standard;
    
    if (model.use_num != nil) {
        
        self.use_numInteger = [model.use_num integerValue];
        
        self.use_numView.addLabel.text = [NSString stringWithFormat:@"%ld",self.use_numInteger];
        
    }
    
    if (model.day_use != nil) {
        
        self.day_useInteger = [model.day_use integerValue];
        
        self.day_useView.addLabel.text = [NSString stringWithFormat:@"%ld",self.day_useInteger];
        
    }
    
    if (model.day_use_num != nil) {

        self.day_use_numTextField.text = [NSString stringWithFormat:@"%@",model.day_use_num];
        
    }
    
    if (model.unit_name != nil) {
        self.unit_nameLabel.text = model.unit_name;
    }
    
    if (model.use_type) {
        self.use_typeLabel.text = model.use_type;
    }
    
    if (model.remark) {
        self.remarkTextView.text = model.remark;
    }

}

-(void)setType:(NSInteger)type{
    
    _type = type;
    
    if (type == 1) {
        [self.collectionButton setTitle:@"保存" forState:UIControlStateNormal];
    }else if (type == 2){
        
        [self.collectionButton setTitle:@"保存" forState:UIControlStateNormal];
        
        self.collectionButton.sd_resetLayout
        .topSpaceToView(self.remarkTextView, 15)
        .widthIs(ScreenWidth/2)
        .heightIs(50)
        .leftSpaceToView(self.deleteButton, 0);
        
        self.deleteButton.hidden = NO;
        
    } else{
        [self.collectionButton setTitle:@"添加" forState:UIControlStateNormal];
    }
    
}

-(void)initUI{
    
    UIView *backView = [UIView new];
    backView.backgroundColor = RGBA(51, 51, 51, 0.7);
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [backView addGestureRecognizer:backTap];
    [self addSubview:backView];
    
    backView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
    UIView *view = [UIView new];
    view.backgroundColor = RGB(237, 237, 237);
    [self addSubview:view];
    
    
    
    if (IS_iPhoneX) {
        
        view.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, ScreenHeight - 547)
        .heightIs(40);
        
    }else{
        
        view.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, ScreenHeight - 527)
        .heightIs(40);
        
    }
    
    self.drugNameLabel = [UILabel new];
    self.drugNameLabel.textColor = [UIColor lightGrayColor];
    self.drugNameLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.drugNameLabel];
    
    self.drugNameLabel.sd_layout
    .centerXEqualToView(view)
    .centerYEqualToView(view)
    .heightIs(16);
    [self.drugNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.scorllView = [UIScrollView new];
    self.scorllView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scorllView];
    
    self.scorllView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(view, 0)
    .bottomSpaceToView(self, 0);
    
    self.use_numInteger = 1;
    
    self.day_useInteger = 1;
    
    NSArray *titleArray = @[@"规格",@"数量",@"一日",@"一次",@"用法",@"备注"];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UILabel *label = [UILabel new];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [self.scorllView addSubview:label];
        
        label.sd_layout
        .leftSpaceToView(self.scorllView, 15)
        .topSpaceToView(self.scorllView, 25 + i * 44)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        if (i == 0) {
            
            self.standardLabel = [UILabel new];
            self.standardLabel.font = [UIFont systemFontOfSize:14];
            [self.scorllView addSubview:self.standardLabel];
            
            self.standardLabel.sd_layout
            .centerYEqualToView(label)
            .leftSpaceToView(label, 15)
            .heightIs(14);
            [self.standardLabel setSingleLineAutoResizeWithMaxWidth:200];
            
        }
        
        if (i == 1) {
            
            self.use_numView = [AddCountView new];
            self.use_numView.addCountString = [NSString stringWithFormat:@"%ld",self.use_numInteger];
            [self.scorllView addSubview:self.use_numView];
            
            self.use_numView.sd_layout
            .leftSpaceToView(label, 15)
            .centerYEqualToView(label)
            .widthIs(140)
            .heightIs(30);
            
        }
        if (i == 2) {
            
            self.day_useView = [AddCountView new];
            self.day_useView.addCountString = [NSString stringWithFormat:@"%ld",self.day_useInteger];
            [self.scorllView addSubview:self.day_useView];
            
            self.day_useView.sd_layout
            .leftSpaceToView(label, 15)
            .centerYEqualToView(label)
            .widthIs(140)
            .heightIs(30);
            
            UILabel *countLabel = [UILabel new];
            countLabel.text = @"次";
            countLabel.font = [UIFont systemFontOfSize:14];
            [self.scorllView addSubview:countLabel];
            
            countLabel.sd_layout
            .leftSpaceToView(self.day_useView, 15)
            .centerYEqualToView(self.day_useView)
            .heightIs(14);
            [countLabel setSingleLineAutoResizeWithMaxWidth:100];
            
        }
        
        if (i == 3) {
            
            self.day_use_numTextField = [BaseTextField textFieldWithPlaceHolder:@"" headerViewText:nil];
            self.day_use_numTextField.text = @"1";
            [self.scorllView addSubview:self.day_use_numTextField];
            
            self.day_use_numTextField.sd_layout
            .leftSpaceToView(label, 15)
            .centerYEqualToView(label)
            .widthIs(140)
            .heightIs(30);
            
            self.unitsArray = @[@"mg",@"g",@"丸",@"片",@"粒",@"mlg",@"LS",@"ml",@"袋",@"ug",@"μg",@"滴",@"克",@"支",@"次",@"枚",@"帖",@"包",@"瓶"];
            
            UIView *view = [UIView new];
            view.layer.borderWidth = 1;
            view.layer.borderColor = RGB(237, 237, 237).CGColor;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *unit_nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unit_name:)];
            [view addGestureRecognizer:unit_nameTap];
            [self.scorllView addSubview:view];
            
            view.sd_layout
            .leftSpaceToView(self.day_use_numTextField, 15)
            .centerYEqualToView(self.day_use_numTextField)
            .widthIs(60)
            .heightIs(30);
            
            self.unit_nameLabel = [UILabel new];
            self.unit_nameLabel.text = self.unitsArray[0];
            self.unit_nameLabel.font = [UIFont systemFontOfSize:14];
            [view addSubview:self.unit_nameLabel];
            
            self.unit_nameLabel.sd_layout
            .leftSpaceToView(view, 10)
            .centerYEqualToView(view)
            .heightIs(14);
            [self.unit_nameLabel setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"SubscriptImg"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageView];
            
            imageView.sd_layout
            .rightSpaceToView(view, 5)
            .centerYEqualToView(view)
            .widthIs(12)
            .heightEqualToWidth();
            
        }
        
        if (i == 4) {
            
            self.use_typeArray = @[@"口服",@"口服(吞服)",@"口服(嚼服)",@"口服(冲服、泡服)",@"口服(煎服)",@"含服、含化",@"舌下含服、舌下含化",@"管饲",@"皮下注射",@"皮内注射",@"肌肉注射",@"静脉注射",@"静脉滴射",@"动脉注射",@"直肠给药",@"阴道给药",@"泌尿道给药",@"外用",@"滴眼",@"滴鼻",@"滴耳",@"含漱",@"喷喉",@"吸入"];
            
            UIView *view = [UIView new];
            view.layer.borderWidth = 1;
            view.layer.borderColor = RGB(237, 237, 237).CGColor;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *use_typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(use_type:)];
            [view addGestureRecognizer:use_typeTap];
            [self.scorllView addSubview:view];
            
            view.sd_layout
            .leftSpaceToView(label, 15)
            .centerYEqualToView(label)
            .widthIs(190)
            .heightIs(30);
            
            self.use_typeLabel = [UILabel new];
            self.use_typeLabel.text = self.use_typeArray[0];
            self.use_typeLabel.font = [UIFont systemFontOfSize:14];
            [view addSubview:self.use_typeLabel];
            
            self.use_typeLabel.sd_layout
            .leftSpaceToView(view, 10)
            .centerYEqualToView(view)
            .heightIs(14);
            [self.use_typeLabel setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"SubscriptImg"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageView];
            
            imageView.sd_layout
            .rightSpaceToView(view, 5)
            .centerYEqualToView(view)
            .widthIs(12)
            .heightEqualToWidth();
            
        }
        
        if (i == 5) {
            
            self.remarkTextView = [CustomTextView new];
            self.remarkTextView.placeholder = @"如有补充内容，请在这里输入";
            self.remarkTextView.placeholderColor = [UIColor lightGrayColor];
            self.remarkTextView.tag = 1000;
            self.remarkTextView.textColor = [UIColor blackColor];
            self.remarkTextView.font = [UIFont systemFontOfSize:13];
            self.remarkTextView.delegate = self;
            self.remarkTextView.layer.borderWidth = 1;
            self.remarkTextView.layer.borderColor = RGB(237, 237, 237).CGColor;
            [self.scorllView addSubview:self.remarkTextView];
            
            self.remarkTextView.sd_layout
            .leftSpaceToView(self.scorllView, 15)
            .topSpaceToView(label, 15)
            .rightSpaceToView(self.scorllView, 15)
            .heightIs(150);
            
            self.residueLabel = [UILabel new];
            self.residueLabel.text = @"0/60";
            self.residueLabel.font = [UIFont systemFontOfSize:12];
            self.residueLabel.textColor = [UIColor lightGrayColor];
            [self.scorllView addSubview:self.residueLabel];
            
            self.residueLabel.sd_layout
            .rightSpaceToView(self.scorllView, 20)
            .topSpaceToView(self.remarkTextView, -18)
            .heightIs(12);
            [self.residueLabel setSingleLineAutoResizeWithMaxWidth:100];
            
        }
        
    }
    
    self.deleteButton = [UIButton new];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    self.deleteButton.hidden = YES;
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundColor: RGB(112, 112, 112)];
    [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.scorllView addSubview:self.deleteButton];
    
    self.deleteButton.sd_layout
    .topSpaceToView(self.remarkTextView, 15)
    .widthIs(ScreenWidth/2)
    .heightIs(50)
    .leftSpaceToView(self.scorllView, 0);
    
    self.collectionButton = [UIButton new];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.collectionButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.collectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionButton setBackgroundColor: [UIColor orangeColor]];
    [self.collectionButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self.scorllView addSubview:self.collectionButton];
    
    self.collectionButton.sd_layout
    .topSpaceToView(self.remarkTextView, 15)
    .widthIs(ScreenWidth)
    .heightIs(50)
    .centerXEqualToView(self.scorllView);
    
    
    WS(weakSelf);
    self.collectionButton.didFinishAutoLayoutBlock = ^(CGRect frame) {
        
        weakSelf.scorllView.contentSize = CGSizeMake(0, frame.origin.y + 50);
        
    };
    
}

-(void)block{
    WS(weakSelf)
    self.use_numView.addBlock = ^(NSString *add) {
        
        weakSelf.use_numInteger++;
        weakSelf.use_numView.addCountString = [NSString stringWithFormat:@"%ld",weakSelf.use_numInteger];
        
    };
    
    self.use_numView.subtractBlock = ^(NSString *subtract) {
        weakSelf.use_numInteger--;
        weakSelf.use_numView.addCountString = [NSString stringWithFormat:@"%ld",weakSelf.use_numInteger];
        
    };
    
    self.day_useView.addBlock = ^(NSString *add) {
        
        weakSelf.day_useInteger++;
        weakSelf.day_useView.addCountString = [NSString stringWithFormat:@"%ld",weakSelf.day_useInteger];
        
    };
    
    self.day_useView.subtractBlock = ^(NSString *subtract) {
        weakSelf.day_useInteger--;
        weakSelf.day_useView.addCountString = [NSString stringWithFormat:@"%ld",weakSelf.day_useInteger];
        
    };
    
}

-(void)unit_name:(UITapGestureRecognizer *)sender{
    
    WS(weakSelf);
    
    self.unit_nameListView = [[PickerListView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.unit_nameListView.dataSource = self.unitsArray;
    [self addSubview:self.unit_nameListView];
    
    [self.unit_nameListView setDidTextStringBlock:^(NSString *textString) {
        
        weakSelf.unit_nameLabel.text = textString;
        
    }];
    
}

-(void)use_type:(UITapGestureRecognizer *)sender{
    
    WS(weakSelf);
    
    self.use_typeListView = [[PickerListView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.use_typeListView.dataSource = self.use_typeArray;
    [self addSubview:self.use_typeListView];
    
    [self.use_typeListView setDidTextStringBlock:^(NSString *textString) {
        
        weakSelf.use_typeLabel.text = textString;
        
    }];
    
}

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    if (range.location >= 60){
        
        return NO;
        
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [self.residueLabel setText:[NSString stringWithFormat:@"%ld/60",self.remarkTextView.text.length]];
    
}

-(void)collection:(UIButton *)sender{
    
    self.model.use_num = [NSString stringWithFormat:@"%ld",self.use_numInteger];
    self.model.day_use = [NSString stringWithFormat:@"%ld",self.day_useInteger];
    self.model.day_use_num = self.day_use_numTextField.text;
    self.model.unit_name = self.unit_nameLabel.text;
    self.model.use_type = self.use_typeLabel.text;
    self.model.remark = self.remarkTextView.text;
    self.model.days = @"1";
    if (self.type == 1 || self.type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyDurgDosage" object:self.model];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDurgDosage" object:self.model];
    }

    if (self.addDurgDosageBlock) {
        self.addDurgDosageBlock(self.model);
    }
    
}

-(void)delete:(UIButton *)sender{
    
    self.model.use_num = [NSString stringWithFormat:@"%ld",self.use_numInteger];
    self.model.day_use = [NSString stringWithFormat:@"%ld",self.day_useInteger];
    self.model.day_use_num = self.day_use_numTextField.text;
    self.model.unit_name = self.unit_nameLabel.text;
    self.model.use_type = self.use_typeLabel.text;
    self.model.remark = self.remarkTextView.text;
    self.model.days = @"1";
    if (self.type == 1 || self.type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDurgDosage" object:self.model];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDurgDosage" object:self.model];
    }
    
    if (self.addDurgDosageBlock) {
        self.addDurgDosageBlock(self.model);
    }
    
}

-(void)back:(UITapGestureRecognizer *)sender{
    
    if (self.backBlock) {
        self.backBlock(@"关闭添加页面");
    }
    
}

@end
