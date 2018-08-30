//
//  QRCodeViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/5/17.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "QRCodeViewController.h"
#import "NinaPagerView.h"
#import "QRPatientViewController.h"
#import "QRDoctorViewController.h"
#import <WXApi.h>

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请医患";
    
    [self initNav];

}

-(void)initNav{
    
    UIImage *selectedImage=[UIImage imageNamed: @"Home_Share"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBar:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

-(void)rightBar:(UIBarButtonItem *)sender{
    
    [self alert];
    
}

-(void)setModel:(HomeModel *)model{
    
    _model = model;
    
    [self addChildViewController];
    
    [self initUI];
    
}

-(void)addChildViewController{
    
    QRPatientViewController *qrPatientView = [[QRPatientViewController alloc] init];
    qrPatientView.model = self.model;
    [self addChildViewController:qrPatientView];
    
    QRDoctorViewController *qrDoctorView = [[QRDoctorViewController alloc] init];
    qrDoctorView.model = self.model;
    [self addChildViewController:qrDoctorView];
    
}

-(void)initUI{
    
    NSArray *titleArray = @[@"邀请患者",@"邀请医生"];
    
    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) WithTitles:titleArray WithVCs:self.childViewControllers];
    ninaPagerView.ninaPagerStyles = 0;
    ninaPagerView.nina_navigationBarHidden = NO;
    ninaPagerView.selectTitleColor = kMainColor;
    ninaPagerView.unSelectTitleColor = [UIColor blackColor];
    ninaPagerView.underlineColor = kMainColor;
    ninaPagerView.selectBottomLinePer = 0.8;
    [self.view addSubview:ninaPagerView];
    
}

-(void)alert{
    
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"请选择分享方式"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                         }];
    [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"分享到微信朋友圈" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             WXMediaMessage *message = [WXMediaMessage message];
                                                             message.title = [NSString stringWithFormat:@"我是%@医生，欢迎关注我的六医卫公众账号，以便于为...",GetUserDefault(UserName)];
                                                             
                                                             WXWebpageObject *webpageObject = [WXWebpageObject object];
                                                             webpageObject.webpageUrl = [NSString stringWithFormat:@"http://pay.6ewei.com/yy/views/scan.html#/?drid=%@",GetUserDefault(UserID)];
                                                             message.mediaObject = webpageObject;
                                                             
                                                             SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                                                             req.bText = NO;
                                                             req.message = message;
                                                             req.scene = WXSceneTimeline;
                                                             
                                                             [WXApi sendReq:req];
                                                             
                                                         }];
    [deleteAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"发送给微信好友" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           WXMediaMessage *message = [WXMediaMessage message];
                                                           message.title = [NSString stringWithFormat:@"我是%@医生，欢迎关注我的六医卫公众账号，以便于为...",GetUserDefault(UserName)];
                                                           
                                                           WXWebpageObject *webpageObject = [WXWebpageObject object];
                                                           webpageObject.webpageUrl = [NSString stringWithFormat:@"http://pay.6ewei.com/yy/views/scan.html#/?drid=%@&type=0",GetUserDefault(UserID)];
                                                           message.mediaObject = webpageObject;
                                                           
                                                           SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                                                           req.bText = NO;
                                                           req.message = message;
                                                           req.scene = WXSceneSession;
                                                           
                                                           [WXApi sendReq:req];
                                                           
                                                       }];
    [saveAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
