//
//  AppDelegate.m
//  GanLuXiangBan
//
//  Created by M on 2018/4/30.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LogInViewController.h"
#import "FillInDataViewController.h"
#import "CertificationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (!GetUserDefault(UserPhone)) {
        [self initLogIn];
        SetUserDefault(UserCheck_status, @"3");
    }else if ([GetUserDefault(UserCheck_status) integerValue] == 0  && GetUserDefault(UserCheck_status) != nil){
        [self initMainController];
    }else if ([GetUserDefault(UserCheck_status) integerValue] == 1){
        [self initFillInData];
        SetUserDefault(UserCheck_status, @"3");
    }else if ([GetUserDefault(UserCheck_status) integerValue] == 2){
        [self initCertification];
        SetUserDefault(UserCheck_status, @"3");
    } else {
        [self initLogIn];
        SetUserDefault(UserCheck_status, @"3");
    }
    
    [WXApi registerApp:WeiXin_AppID];
    
#if DEBUG
    // for iOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    // for tvOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle"] load];
    // for masOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle"] load];
#endif
    
    return YES;
}

#pragma mark - 登录界面初始化
- (void)initLogIn{
    
    LogInViewController *loginView = [[LogInViewController alloc] init];
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:loginView];
    self.window.rootViewController = nav;
    
}

- (void)initMainController {
    self.window.rootViewController = [RootViewController new];
}

-(void)initFillInData{
    
    FillInDataViewController *fillInDataView = [[FillInDataViewController alloc] init];
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:fillInDataView];
    self.window.rootViewController = nav;
    
}

-(void)initCertification{
    
    CertificationViewController *certificationView = [[CertificationViewController alloc] init];
    certificationView.title = @"资格认证";
    certificationView.type = 1;
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:certificationView];
    self.window.rootViewController = nav;
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
