//
//  RootViewController.m
//  MizheDemo
//
//  Created by Kai on 15/6/25.
//  Copyright (c) 2015年 Kai. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LogInRequest.h"

@interface RootViewController ()

@property (nonatomic ,retain) LogInRequest *logInRequest;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initViewController];

    [self request];
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = kMainColor;
}

#pragma mark - 初始化
- (void)initViewController {
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];

    // 控制器名字
    NSArray *viewControllerNames = @[@"HomeViewController", @"PatientsViewController", @"PersonalViewController"];
    
    // 标题
    NSArray *titles = @[@"首页", @"患者", @"个人中心"];
    
    // 图标
    NSArray *imgs = @[@"tabbar_home", @"tabbar_patients", @"tabbar_me"];
    
    // 选中图片
    NSArray *selectImgs = @[@"tabbar_home_select", @"tabbar_patients_select", @"tabbar_me_select"];
    
    for (int i = 0; i < viewControllerNames.count; i++) {
        
        RTRootNavigationController *nav = [self NavigationControllerWithControllerName:viewControllerNames[i]];
        nav.tabBarItem.image = [[UIImage imageNamed:imgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.title = titles[i];
        [viewControllers addObject:nav];
    }
    
    self.viewControllers = viewControllers;
}

- (void)request {
    
    self.logInRequest = [LogInRequest new];
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [self.logInRequest postSaveClientCid:identifierForVendor device_type:@"2" complete:^(LogInModel *model) {
        
    }];
    
    [[LogInRequest new] getVersionUpdateInfoComplete:^(HttpGeneralBackModel *model) {
       
        if ([model.data objectForKey:@"version"]) {
            SetUserDefault(UserVersion, [model.data objectForKey:@"version"]);
        }
        
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    
}

-(void)action{
    
    [[LogInRequest new] getClientInfoComplete:^(HttpGeneralBackModel *generalBackModel) {
        
//        if ([generalBackModel isEqual:[NSNull null]] || generalBackModel == nil) {
//
//            [self.timer invalidate];
//            self.timer = nil;
//
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserID];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserName];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPhone];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserGender];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHospital];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIntroduction];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserRemark];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHead];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserCheck_status];
//
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            [GLAppDelegate initLogIn];
//
//        }
        
        if ([generalBackModel.data objectForKey:@"cid"]) {
            
            if ([[generalBackModel.data objectForKey:@"cid"] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]) {
                
            }else{
                
                [self.timer invalidate];
                self.timer = nil;
                
                NSString *messageString;

                if ([[generalBackModel.data objectForKey:@"device_type"] integerValue] == 1) {
                    messageString = @"你的账号在另一台安卓设备上登录";
                }else{
                    messageString = @"你的账号在另一台苹果设备上登录";
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserID];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserName];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPhone];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserGender];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHospital];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIntroduction];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserRemark];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserHead];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserCheck_status];

                    [[NSUserDefaults standardUserDefaults] synchronize];

                    [GLAppDelegate initLogIn];

                }];

                [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];

                //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    //开启定时器
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];

                    [[LogInRequest new] postSaveClientCid:[[[UIDevice currentDevice] identifierForVendor] UUIDString] device_type:@"2" complete:^(LogInModel *model) {

                    }];

                }];

                [alert addAction:cancel];//添加取消按钮

//                [alert addAction:ok];//添加确认按钮

                //以modal的形式
                [NavController presentViewController:alert animated:YES completion:nil];

            }
            
        }
        
    }];
    
}

// 创建导航控制器
- (RTRootNavigationController *)NavigationControllerWithControllerName:(NSString *)controllerName {
    
    Class cls = NSClassFromString(controllerName);
    
    UIViewController *vc = [[cls alloc] init];
    
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    return nav;
    
}

@end
