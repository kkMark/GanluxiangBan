//
//  PersonalView.m
//  GanLuXiangBan
//
//  Created by M on 2018/4/30.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PersonalView.h"
#import "VisitsRelatedCell.h"

#define HeaderHeight 200

@interface PersonalView ()

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) UIButton *headBgView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *headImgView;

@end

@implementation PersonalView
@synthesize headBgView;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self registerClass:[VisitsRelatedCell class] forCellReuseIdentifier:@"VisitsRelatedCell"];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self insertSubview:self.headBgView atIndex:0];
        
        self.imgs = @[@"PersonalSubscribeImg", @"PersonalBankCard", @"PersonalIntegral", @"PersonAlassistant", @"PersonSetting"];
        self.dataSources = @[@"我的预约", @"我的银行卡", @"我的积分", @"医生助理", @"设置"];
    }
    
    return self;
}

- (void)setModel:(PersonalInfoModel *)model {
    
    _model = model;
    
    self.userNameLabel.text = model.Name;
    self.positionLabel.text = [NSString stringWithFormat:@"%@ %@", model.CustName, model.Title];

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.Head] placeholderImage:[UIImage imageNamed:@"Home_HeadDefault"]];
    [self reloadData];
}

#pragma mark - lazy
- (UIView *)headBgView {
    
    if (!headBgView) {
        
        headBgView = [UIButton buttonWithType:UIButtonTypeCustom];
        headBgView.frame = CGRectMake(0, -HeaderHeight, ScreenWidth, HeaderHeight);
        headBgView.backgroundColor = kMainColor;
        
        @weakify(self);
        [[headBgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           
            @strongify(self);
            if (self.goViewControllerBlock) {
                self.goViewControllerBlock([NSClassFromString(@"PersonalInfoViewController") new]);
            }
        }];
        
        // 用户属性
        self.positionLabel = [UILabel new];
        self.positionLabel.font = [UIFont systemFontOfSize:13];
        self.positionLabel.textAlignment = NSTextAlignmentCenter;
        self.positionLabel.textColor = RGBA(255, 255, 255, 0.6);
        [headBgView addSubview:self.positionLabel];
        
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headBgView);
            make.bottom.equalTo(@-25);
            make.height.equalTo(@15);
        }];
        
        // 用户昵称
        self.userNameLabel = [UILabel new];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        self.userNameLabel.textColor = [UIColor whiteColor];
        self.userNameLabel.text = GetUserDefault(UserName);
        [headBgView addSubview:self.userNameLabel];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headBgView);
            make.bottom.equalTo(self.positionLabel.mas_top).equalTo(@-10);
            make.height.equalTo(@15);
        }];
        
        // 用户头像
        self.headImgView = [UIImageView new];
        self.headImgView.image = [UIImage imageNamed:@"Home_HeadDefault"];
        self.headImgView.layer.cornerRadius = 40;
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.userInteractionEnabled = NO;
        [headBgView addSubview:self.headImgView];
        
        [self.headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headBgView);
            make.height.width.equalTo(@80);
            make.bottom.equalTo(self.userNameLabel.mas_top).equalTo(@-15);
        }];
        
        self.contentInset = UIEdgeInsetsMake(HeaderHeight, 0, 0, 0);
    }
    
    return headBgView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    if (point.y < -HeaderHeight) {
        CGRect rect = headBgView.frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        headBgView.frame = rect;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        VisitsRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisitsRelatedCell"];
        [cell setGoViewControllerBlock:^(UIViewController *viewController) {
            self.goViewControllerBlock(viewController);
        }];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.dataSources[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:self.imgs[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section != 0) {
        
        NSArray *viewControllers = @[@"SubscribeViewController", @"MyCardViewController", @"MyPointsViewController", @"AssistantViewController", @"SettingViewController"];
        
        BaseViewController *viewController = [NSClassFromString(viewControllers[indexPath.row]) new];
        viewController.title = self.dataSources[indexPath.row];
        self.goViewControllerBlock(viewController);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return VisitsRelatedCellHeight;
    }
    
    return 45;
}

@end
