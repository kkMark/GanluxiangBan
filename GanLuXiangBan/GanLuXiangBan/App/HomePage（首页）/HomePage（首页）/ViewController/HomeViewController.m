//
//  HomeViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/4/30.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeRequest.h"
#import "SDCycleScrollView.h"
#import "QRCodeViewController.h"
#import "ScheduleViewController.h"
#import "MyStudioViewController.h"
#import "HomeMessgeView.h"
#import "EvaluationViewController.h"
#import "CertificationViewModel.h"
#import "HomeMessgeModel.h"
#import "MessageViewController.h"
#import "SignViewController.h"
#import "LogInRequest.h"
#import "AppDelegate.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic ,retain) HomeRequest *homeRequest;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic ,strong) UIImageView *doctorView;

@property (nonatomic ,strong) UIView *toolView;
///头像
@property (nonatomic ,strong) UIImageView *headImageView;
///患者数
@property (nonatomic ,strong) UILabel *patientLabel;
///评价数
@property (nonatomic ,strong) UILabel *evaluateLabel;

@property (nonatomic ,retain) BannerModel *bannerModel;

@property (nonatomic ,retain) HomeModel *homeModel;

@property (nonatomic ,strong) HomeMessgeView *homeMessgeView;

@property (nonatomic ,strong) UIView *signView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HomeViewController

@synthesize bannerView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.homeModel = [HomeModel new];
    
    [self request];
    
    [self initUI];

    [self refresh];
    
    [self block];
    
}

-(void)action{
    [self request];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.timer invalidate];
    self.timer = nil;
    
}

-(void)initUI{
    
    [self bannerView];
    
    [self initDoctorView];
    
    [self initToolView];
    
    self.homeMessgeView = [HomeMessgeView new];
    [self.view addSubview:self.homeMessgeView];
    
    self.homeMessgeView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.toolView, 10)
    .bottomSpaceToView(self.view, 0);
    
}

- (void)request {

    self.bannerModel = [BannerModel new];
    
    self.homeRequest = [HomeRequest new];
    WS(weakSelf)
    [self.homeRequest getIndexInfo:^(HomeModel *model) {
        
        weakSelf.patientLabel.text = [NSString stringWithFormat:@"（%ld）",model.patientNum];
        weakSelf.evaluateLabel.text = [NSString stringWithFormat:@"（%ld）",model.evaluateNum];
        
        weakSelf.homeModel = model;
        
        if (!GetUserDefault(UserHead)) {
            weakSelf.headImageView.image = [UIImage imageNamed:@"Home_HeadDefault"];
        }else{
            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:GetUserDefault(UserHead)]];
        }
        
        if (model.indexUnread > 0) {
            
            UITabBarItem *firstItem = weakSelf.tabBarController.tabBar.items[model.indexUnread-1];
            firstItem.badgeCenterOffset = CGPointMake(0, 0);
            [firstItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
            
        }else{
            
            UITabBarItem *firstItem = weakSelf.tabBarController.tabBar.items[0];
            [firstItem clearBadge];

        }
        
        UIImageView *imageView = [self.view viewWithTag:101];
        
        if (model.orderUnread > 0) {

            [imageView showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
            
        }else{
            
            [imageView clearBadge];
            
        }
        
    }];
    
    [self.homeRequest getUnreadForMyPatient:^(HttpGeneralBackModel *generalBackModel) {
        
        if ([generalBackModel.data isEqualToString:@"0"]) {
            
            UITabBarItem *firstItem = weakSelf.tabBarController.tabBar.items[1];
            [firstItem clearBadge];
            
        }else{
            
            UITabBarItem *firstItem = weakSelf.tabBarController.tabBar.items[1];
            firstItem.badgeCenterOffset = CGPointMake(0, 0);
            [firstItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
            
        }
        
    }];
    
    [self.homeRequest getMsgListLoad_type:@"reload" :^(HttpGeneralBackModel *generalBackModel) {
        
        [weakSelf.homeMessgeView.dataSource removeAllObjects];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in generalBackModel.data) {
            
            HomeMessgeModel *model = [HomeMessgeModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
            
        }
        
        [weakSelf.homeMessgeView addData:array];
        
        if (array.count != 0) {
            
            [weakSelf.homeMessgeView.NoMessageView removeFromSuperview];
            
        }
        
        [weakSelf.homeMessgeView.myTable.mj_header endRefreshing];
        [weakSelf.homeMessgeView.myTable.mj_footer endRefreshing];
        
    }];
    
    [self.homeRequest getIsSign:^(HttpGeneralBackModel *generalBackModel) {
        
        NSInteger signInteger = [generalBackModel.data integerValue];
        
        if (signInteger == 0) {
            
            [weakSelf Sign];
            
        }else{
            
        }
        
        
    }];
    
    [[HomeRequest new] getNoticeList:^(HttpGeneralBackModel *generalBackModel) {

    }];
    
//    [[LogInRequest new] getClientInfoComplete:^(HttpGeneralBackModel *generalBackModel) {
//       
//        if ([generalBackModel.data objectForKey:@"cid"]) {
//            
//            if ([[generalBackModel.data objectForKey:@"cid"] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]) {
//                
//            }else{
//                
//                [self.timer invalidate];
//                self.timer = nil;
//                
//                NSString *messageString;
//                
//                if ([[generalBackModel.data objectForKey:@"device_type"] integerValue] == 1) {
//                    messageString = @"你的账号在另一台安卓设备上登录";
//                }else{
//                    messageString = @"你的账号在另一台苹果设备上登录";
//                }
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserID];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserName];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPhone];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserGender];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHospital];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIntroduction];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserRemark];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHead];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserCheck_status];
//                    
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [GLAppDelegate initLogIn];
//                    
//                }];
//                
//                [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
//                
//                //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
//                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    
//                    //开启定时器
//                    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
//                    
//                    [[LogInRequest new] postSaveClientCid:[[[UIDevice currentDevice] identifierForVendor] UUIDString] device_type:@"2" complete:^(LogInModel *model) {
//                        
//                    }];
//                    
//                }];
//                
//                [alert addAction:cancel];//添加取消按钮
//                
//                [alert addAction:ok];//添加确认按钮
//                
//                //以modal的形式
//                [NavController presentViewController:alert animated:YES completion:nil];
//                
//            }
//            
//        }
//        
//    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.homeMessgeView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakSelf.homeMessgeView.dataSource removeAllObjects];
        [weakSelf request];
        
    }];
    
    self.homeMessgeView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [weakSelf request];
        
    }];
}

-(void)block{
    
    WS(weakSelf);
    self.homeMessgeView.pushBlock = ^(HomeMessgeModel *model) {
        
        [[HomeRequest new] getZeroPushNum:model.mid :^(HttpGeneralBackModel *generalBackModel) {
            
        }];
        
        MessageViewController *messageView = [[MessageViewController alloc] init];
        messageView.mid = model.mid;
        messageView.patientName = model.name;
        messageView.msg_flag = model.msg_source;
        messageView.msgId = @"1";
//        messageView.patientGender = model.
        messageView.title = model.name;
        messageView.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:messageView animated:YES];
        
    };
    
}

- (SDCycleScrollView *)bannerView {
    
    if (!bannerView) {
        
        bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight * 0.214, ScreenWidth, ScreenWidth / 2.5)];
        bannerView.delegate = self;
        bannerView.autoScrollTimeInterval = 5;
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.backgroundColor = RGB(233, 233, 233);
        [self.view addSubview:bannerView];
        
        //获取轮播图
        self.homeRequest = [HomeRequest new];
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithArray:@[@"APPShow"]];
        
        self.bannerView.localizationImageNamesGroup = imageArray;
        
//        WS(weakSelf)
//        [self.homeRequest getBanner:^(HttpGeneralBackModel *model) {
//
//            NSArray *array = model.data;
//
//            for (NSDictionary *dict in array) {
//
//                [imageArray addObject:[dict objectForKey:@"file_path"]];
//
//            }
//
//            weakSelf.bannerView.imageURLStringsGroup = imageArray;
//
//        }];
        
    }
    
    return bannerView;
}

-(void)initDoctorView{
    
    self.doctorView = [UIImageView new];
    self.doctorView.image = [UIImage imageNamed:@"HomeBG"];
    self.doctorView.contentMode = UIViewContentModeScaleAspectFill;
    self.doctorView.userInteractionEnabled = YES;
    [self.view addSubview:self.doctorView];
    
    if (IS_iPhoneX) {
        
        self.doctorView.sd_layout
        .topSpaceToView(self.view, -20)
        .centerXEqualToView(self.view)
        .widthIs(ScreenWidth)
        .heightIs(ScreenHeight * 0.214);
        
    }else{
     
        self.doctorView.sd_layout
        .topSpaceToView(self.view, 0)
        .centerXEqualToView(self.view)
        .widthIs(ScreenWidth)
        .heightIs(ScreenHeight * 0.214);
        
    }
    
    UILabel *label = [UILabel new];
    label.text = @"首页";
    label.font = [UIFont systemFontOfSize:24];
    label.textColor = [UIColor whiteColor];
    [self.doctorView addSubview:label];
    
    if (IS_iPhoneX) {
        
        label.sd_layout
        .centerXEqualToView(self.doctorView)
        .topSpaceToView(self.doctorView, 70)
        .heightIs(18);
        [label setSingleLineAutoResizeWithMaxWidth:200];

    }else{
       
        label.sd_layout
        .centerXEqualToView(self.doctorView)
        .topSpaceToView(self.doctorView, 30)
        .heightIs(18);
        [label setSingleLineAutoResizeWithMaxWidth:200];

    }
    
    self.headImageView = [UIImageView new];
    if (!GetUserDefault(UserHead)) {
        self.headImageView.image = [UIImage imageNamed:@"Home_HeadDefault"];
    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:GetUserDefault(UserHead)]];
    }
    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView.layer setCornerRadius:ScreenWidth*0.08];
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(head:)];
    [self.headImageView addGestureRecognizer:headTap];
    
    [self.doctorView addSubview:self.headImageView];
    
    self.headImageView.sd_layout
    .leftSpaceToView(self.doctorView, ScreenWidth*0.05)
    .bottomSpaceToView(self.doctorView, 10)
    .widthIs(ScreenWidth * 0.16)
    .heightEqualToWidth();
    
    NSArray *imageArray = @[@"Home_Patient",@"Home_Comment"];
    NSArray *titleArray = @[@"患者",@"评价"];
    
    for (int i = 0; i < imageArray.count; i++) {

        UIImageView *iconView = [UIImageView new];
//        iconView.image = [UIImage imageNamed:imageArray[i]];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.userInteractionEnabled = YES;
        iconView.tag = i + 200;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doctor:)];
        [iconView addGestureRecognizer:tap];
        [self.doctorView addSubview:iconView];

        iconView.sd_layout
        .leftSpaceToView(self.headImageView, 30 + i * ScreenWidth * 0.3)
        .centerYEqualToView(self.headImageView)
        .widthIs(100)
        .heightIs(30);
        
        UILabel *label = [UILabel new];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [self.doctorView addSubview:label];
        
        label.sd_layout
        .centerYEqualToView(self.headImageView)
        .leftSpaceToView(self.headImageView, 30 + i * ScreenWidth * 0.3)
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        if (i == 0) {
            
            self.patientLabel = [UILabel new];
            self.patientLabel.textColor = [UIColor whiteColor];
            self.patientLabel.font = [UIFont systemFontOfSize:14];
            [self.doctorView addSubview:self.patientLabel];
            
            self.patientLabel.sd_layout
            .leftSpaceToView(label, 5)
            .centerYEqualToView(self.headImageView)
            .heightIs(14);
            [self.patientLabel setSingleLineAutoResizeWithMaxWidth:100];
            
//            UIView *lineView = [UIView new];
//            lineView.backgroundColor = RGB(235, 235, 235);
//            [self.doctorView addSubview:lineView];
//
//            lineView.sd_layout
//            .leftSpaceToView(self.patientLabel, ScreenWidth * 0.1)
//            .topSpaceToView(self.doctorView, 5)
//            .bottomSpaceToView(self.doctorView, 5)
//            .widthIs(0.5);
            
        }else{
            
            self.evaluateLabel = [UILabel new];
            self.evaluateLabel.textColor = [UIColor whiteColor];
            self.evaluateLabel.font = [UIFont systemFontOfSize:14];
            [self.doctorView addSubview:self.evaluateLabel];
            
            self.evaluateLabel.sd_layout
            .leftSpaceToView(label, 5)
            .centerYEqualToView(self.headImageView)
            .heightIs(14);
            [self.evaluateLabel setSingleLineAutoResizeWithMaxWidth:100];
            
        }
        
    }
    
}

-(void)doctor:(UITapGestureRecognizer *)sender{
    
    if (sender.view.tag - 200 == 0) {
        
        [self.tabBarController setSelectedIndex:1];
        
    }else{
        
        EvaluationViewController *evaluationView = [[EvaluationViewController alloc] init];
        evaluationView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:evaluationView animated:YES];
        
    }
    
}

-(void)initToolView{
    
    self.toolView = [UIView new];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    
    self.toolView.sd_layout
    .topSpaceToView(self.bannerView, 13)
    .centerXEqualToView(self.view)
    .heightIs(ScreenHeight * 0.164)
    .widthIs(ScreenWidth);
    
    NSArray *imageArray = @[@"Home_Invitation",@"Home_Schedule",@"Home_Studio"];
    
    NSArray *titleArray = @[@"邀请医患",@"我的日程",@"我的工作室"];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.tag = i + 100;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tool:)];
        [imageView addGestureRecognizer:tap];
        [self.toolView addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self.toolView, ScreenWidth*0.101 + i * ScreenWidth * 0.315)
        .topSpaceToView(self.toolView, ScreenHeight*0.02)
        .widthIs(ScreenWidth *0.17)
        .heightEqualToWidth();
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.toolView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .centerXEqualToView(imageView)
        .topSpaceToView(imageView, 10)
        .heightIs(14);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    
}

-(void)tool:(UITapGestureRecognizer *)sender{
    
    if (sender.view.tag - 100 == 0) {
        
        QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
        qrCodeVC.model = self.homeModel;
        qrCodeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrCodeVC animated:YES];
        
    }
    
    if (sender.view.tag - 100 == 1) {
        
        ScheduleViewController *scheduleView = [[ScheduleViewController alloc] init];
        scheduleView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scheduleView animated:YES];
        
    }
    
    if (sender.view.tag - 100 == 2) {
        
        MyStudioViewController *mySudioView = [[MyStudioViewController alloc] init];
        mySudioView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mySudioView animated:YES];
        
    }
    
}

-(void)head:(UITapGestureRecognizer *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotos = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
                //拍照
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        }
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        
    }];

    //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"从相册选取一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            //相册
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        
    }];

    //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [alert addAction:takePhotos];

    [alert addAction:ok];//添加确认按钮
    
    [alert addAction:cancel];//添加取消按钮
    
    //以modal的形式
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.headImageView.image = image;
        
        NSData *imageData = UIImageJPEGRepresentation(self.headImageView.image, 0.3);
        
        [[CertificationViewModel new] uploadImageWithImgs:imageData complete:^(id object) {
            
            SetUserDefault(UserHead, object);
            
            [[HomeRequest new] postUpdateDrHeadUrl:object :^(HttpGeneralBackModel *generalBackModel) {
                
            }];
            
        }];
        
        
        
    });
}

-(void)Sign{
    
    if (!self.signView) {
     
        self.signView = [UIView new];
        self.signView.backgroundColor = RGBA(137, 137, 137, 0.7);
        self.signView.userInteractionEnabled = YES;
        self.signView.layer.cornerRadius = 5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signTap:)];
        [self.signView addGestureRecognizer:tap];
        [self.view addSubview:self.signView];
        
        self.signView.sd_layout
        .rightSpaceToView(self.view, -10)
        .topSpaceToView(self.view, 40)
        .widthIs(100)
        .heightIs(40);
        
        UIImageView *signImageView = [UIImageView new];
        signImageView.image = [UIImage imageNamed:@"Home_Sign"];
        signImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.signView addSubview:signImageView];
        
        signImageView.sd_layout
        .leftSpaceToView(self.signView, 10)
        .centerYEqualToView(self.signView)
        .widthIs(30)
        .heightEqualToWidth();
        
        UILabel *signLabel = [UILabel new];
        signLabel.textColor = [UIColor whiteColor];
        signLabel.text = @"签到";
        signLabel.font = [UIFont systemFontOfSize:16];
        [self.signView addSubview:signLabel];
        
        signLabel.sd_layout
        .rightSpaceToView(self.signView, 20)
        .centerYEqualToView(self.signView)
        .heightIs(16);
        [signLabel setSingleLineAutoResizeWithMaxWidth:60];
        
    }
    
}

-(void)signTap:(UITapGestureRecognizer *)sender{
    
    [self.signView removeFromSuperview];
    
    SignViewController *signView = [[SignViewController alloc] init];
    signView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signView animated:YES];
    
}

@end
