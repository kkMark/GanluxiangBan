//
//  AppMacro.h
//  DingBell
//
//  Created by M on 2018/4/8.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//
//  App的相关宏定义

#import "HttpMacro.pch"
#import "NotiMacro.h"
#import "VendorMacro.h"
#import "UserDefaultsMacro.h"

#ifndef AppMacro_h
#define AppMacro_h

/*** 常用 ***/
/** app主色调 */
#define kMainColor [UIColor colorWithHexString:@"0x4671f3"]
/** 页面背景色 */
#define kPageBgColor [UIColor colorWithHexString:@"0xF5F5F5"]
/** 线条的颜色 */
#define kLineColor [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1];

/*** 日志 ***/
#ifdef DEBUG
#define KLog(...) NSLog(@"%s 第%d行 %@",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define KLog(...)
#endif

// 沙盒路径
#define kDocumentPath   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

// 系统版本
#define System_Version          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IsHigherIOS(version)    [[[UIDevice currentDevice]systemVersion]floatValue] > version

// App信息
#define App_Name                ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
#define App_Version             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define App_BundleID            ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

// UserDefaults
#define GetUserDefault(key)         [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define SetUserDefault(key,value)   [[NSUserDefaults standardUserDefaults] setObject:(value) forKey:(key)]

// 颜色
#define RGB(r,g,b)      [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1]
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:(double)a]

// 宽高
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define NavHeight       self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height

#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define  kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)

// Cell右间距
#define kCellSpacing ScreenWidth == 320 ? 15 : 20

// 弱引用
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self;
// 当前导航控制器
#define NavController   (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController)
//全局AppDelegate
#define GLAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
// 判断是否空字符串
#define NullString(str) ((str && [str isKindOfClass:[NSString class]] && [value length]) ? str : @"")

#endif /* AppMacro_h */
