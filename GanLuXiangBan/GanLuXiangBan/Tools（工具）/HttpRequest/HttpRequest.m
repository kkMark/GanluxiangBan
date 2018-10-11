//
//  HttpRequest.m
//  GanLuXiangBan
//
//  Created by M on 2018/5/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "HttpRequest.h"
#import "XmlParsing.h"
#import "RootViewController.h"
#import <objc/runtime.h>
#import <MBProgressHUD.h>
#import "NSString+ToJSON.h"

@interface HttpRequest ()

@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation HttpRequest

- (NSDictionary *)getParametersWithClass:(id)object {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    objc_property_t *properList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properList[i];
        
        NSString *keyString = [NSString stringWithUTF8String:property_getName(property)];
        
        if ([[object valueForKey:keyString] isKindOfClass:[NSArray class]]) {
            
            NSArray *valueArray = [object valueForKey:keyString];
//            valueString = valueString.length == 0 ? @"" : valueString;

            [parameters setValue:valueArray forKey:keyString];
            
        }else if ([[object valueForKey:keyString] isKindOfClass:[NSNumber class]]){

            NSString *valueString = [NSString stringWithFormat:@"%@",[object valueForKey:keyString]];
            
            [parameters setValue:valueString forKey:keyString];
            
        }
        else{
            
            NSString *valueString = [object valueForKey:keyString];
            valueString = valueString.length == 0 ? @"" : valueString;
            [parameters setValue:valueString forKey:keyString];
            
        }

    }
    
    free(properList);
    return parameters;
}

- (NSString *)getRequestUrl:(NSArray *)parArr {
    
#if 1
    NSString *tempStr = @"http://itf.6ewei.com/api";
#else
    NSString *tempStr = @"http://120.76.42.106/yyjkApiBeta/api";
#endif
    
    for (int i = 0; i < parArr.count; i++) {
        tempStr = [NSString stringWithFormat:@"%@/%@",tempStr,parArr[i]];
    }
    
    return tempStr;
}

- (void)requestWithIsGet:(BOOL)isGet success:(void (^)(HttpGeneralBackModel *genneralBackModel))success failure:(void (^)(NSError *error))failure {
    
    if ([NavController isKindOfClass:[RootViewController class]]) {
        
        RootViewController *rootVC = (RootViewController *)NavController;
        RTRootNavigationController *navVC = rootVC.selectedViewController;
        if (navVC.visibleViewController) {
            [self showHudAnimated:YES viewController:rootVC];
        }
    }
    
    NSDictionary *parameters = self.parameters;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/xml", nil];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    if (cookie != nil) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
 
    self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (isGet) {
        
        [manager GET:self.urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HttpGeneralBackModel *model = [HttpGeneralBackModel new];
            [model setValuesForKeysWithDictionary:responseObject];
            model.responseObject = responseObject;
            
            DebugLog(@"urlString = %@\n\n  %@  retcode = %ld  \n\n", self.urlString, model.data,model.retcode);
            
            if (success) {
                success(model);
            }
            
            // 获取cookie方法3
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            NSString *ASPString;
            
            NSString *MyCookString;
            
            for(NSHTTPCookie *cookie in [cookieJar cookies])
            {
                NSString *string = [NSString stringWithFormat:@"%@=%@",cookie.name,cookie.value];
                if (cookie.isHTTPOnly == YES) {
                    ASPString = string;
                }else{
                    MyCookString = string;
                }
            }
            
            NSString *cookie = [NSString stringWithFormat:@"%@;%@",ASPString,MyCookString];
            [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"Set-Cookie"];
            
            [self hideHudAnimatedWithViewController:NavController];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DebugLog(@"error = %@\n\n  %@  \n\n", self.urlString, error);
            
            if (error.code == -1001) {
                NSLog(@"请求超时");
            }
            
            if (failure) {
                failure(error);
            }
            
            [self hideHudAnimatedWithViewController:NavController];
        }];
    }
    else {
        
        DebugLog(@"urlString = %@\n\n  %@", self.urlString,parameters);
        
        [manager POST:self.urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HttpGeneralBackModel *model = [HttpGeneralBackModel new];
            [model setValuesForKeysWithDictionary:responseObject];
            
            DebugLog(@"urlString = %@\n\n  %@  retcode = %ld  \n\n", self.urlString, model.data,model.retcode);
            
            if (success) {
                success(model);
            }
            
            [self hideHudAnimatedWithViewController:NavController];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DebugLog(@"error = %@\n\n  %@  \n\n", self.urlString, error);
            
            if (error.code == -1001) {
                NSLog(@"请求超时");
            }
            
            if (failure) {
                failure(error);
            }
            
            [self hideHudAnimatedWithViewController:NavController];
            
        }];
    }
}

- (void)requestNotHudWithIsGet:(BOOL)isGet success:(void (^)(HttpGeneralBackModel *genneralBackModel))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = self.parameters;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/xml", nil];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    if (cookie != nil) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (isGet) {
        
        DebugLog(@"urlString = %@\n\n  %@", self.urlString,parameters);
        
        [manager GET:self.urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HttpGeneralBackModel *model = [HttpGeneralBackModel new];
            [model setValuesForKeysWithDictionary:responseObject];
            model.responseObject = responseObject;
            
            DebugLog(@"urlString = %@\n\n  %@  retcode = %ld  \n\n", self.urlString, model.data,model.retcode);
            
            if (success) {
                success(model);
            }
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
            NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
            if (setCookie != nil) {
                
                NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"Set-Cookie"];
                
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DebugLog(@"error = %@\n\n  %@  \n\n", self.urlString, error);
            
            if (error.code == -1001) {
                NSLog(@"请求超时");
            }
            
            if (failure) {
                failure(error);
            }
            
        }];
    }
    else {
        
        DebugLog(@"urlString = %@\n\n  %@", self.urlString,parameters);
        
        [manager POST:self.urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            HttpGeneralBackModel *model = [HttpGeneralBackModel new];
            [model setValuesForKeysWithDictionary:responseObject];

            DebugLog(@"urlString = %@\n\n  %@  retcode = %ld  \n\n", self.urlString, model.data,model.retcode);

            if (success) {
                success(model);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            DebugLog(@"error = %@\n\n  %@  \n\n", self.urlString, error);

            if (error.code == -1001) {
                NSLog(@"请求超时");
            }

            if (failure) {
                failure(error);
            }

        }];
    }
    
}

#pragma mark - 加载
- (void)showHudAnimated:(BOOL)animated viewController:(UIViewController *)viewController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView *subview in viewController.view.subviews) {
            
            if ([subview isKindOfClass:[MBProgressHUD class]]) {
                return ;
            }
        }
        
        self.hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:animated];
        self.hud.label.text = @"加载中...";
    });
    
}

- (void)requestSystemWithIsGet:(BOOL)isGet success:(void (^)(HttpGeneralBackModel *genneralBackModel))success failure:(void (^)(NSError *error))failure{
    
    if (!isGet) {
        
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"text/json" forHTTPHeaderField:@"Accept"];
        // 如果已有Cookie, 则把你的cookie符上
        NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
        if (cookie != nil) {
            [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        }
        NSString *jsonString = [NSString dictionaryToJSONString:self.parameters];
        NSRange range = {0, jsonString.length};

        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0, mutStr.length};
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        request.HTTPBody = [mutStr dataUsingEncoding:NSUTF8StringEncoding];
        
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //判断statusCode
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if (!(res.statusCode == 200 || error)) {
                NSLog(@"失败！！！");
                return;
            }
            NSLog(@"从服务器获取到数据");
            if (error) {
                NSLog(@"error:%@",error.description);
                return ;
            }
            
            NSError *newError;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&newError];
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *response = (NSDictionary *)object;
                
                HttpGeneralBackModel *model = [HttpGeneralBackModel new];
                [model setValuesForKeysWithDictionary:response];
                
                if (success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        success(model);
                    });
                }
            }
        }];

        [sessionDataTask resume];
    }
    
}

- (void)hideHudAnimatedWithViewController:(UIViewController *)viewController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
    });
    
}

@end
