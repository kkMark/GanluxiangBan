//
//  HelpWebViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/9.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HelpWebViewController.h"

@interface HelpWebViewController ()

@end

@implementation HelpWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    webView.backgroundColor = self.view.backgroundColor;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [webView loadHTMLString:self.bodyString baseURL:nil];
    });
    [self.view addSubview:webView];
    
}

@end
