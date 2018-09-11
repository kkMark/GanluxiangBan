//
//  MessageRequest.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/14.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "MessageRequest.h"
#import "NSString+ToJSON.h"
@implementation MessageRequest

- (void)getInitiateChatMid:(NSString *)mid complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"InitiateChat"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@", self.urlString,mid];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postRestartMsgMid:(NSString *)mid complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"RestartMsg"]];
    self.parameters = mid;
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postCloseMsgMid:(NSString *)mid complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"CloseMsg"]];
    self.parameters = mid;
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getDetailMid:(NSString *)mid msg_source:(NSString *)msg_source complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"Detail"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@&msg_source=%@", self.urlString,mid,msg_source];
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getMoreMsgMid:(NSString *)mid Date:(NSString *)date complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"MoreMsg"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@&date=%@", self.urlString,mid,date];
    [self requestWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)getCurrentMsgIsClosedMid:(NSString *)mid complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"currentMsgIsClosed"]];
    self.urlString = [NSString stringWithFormat:@"%@?mid=%@", self.urlString,mid];
    [self requestNotHudWithIsGet:YES success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postSendImgMsgMid:(NSString *)mid file_path:(NSString *)file_path msg_flag:(NSString *)msg_flag complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"sendImgMsg"]];
    self.parameters = @{@"mid":mid,@"file_path":file_path,@"msg_flag":msg_flag};
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postsendTxtMsggMid:(NSString *)mid content:(NSString *)content msg_flag:(NSString *)msg_flag complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"sendTxtMsg"]];
    self.parameters = @{@"mid":mid,@"content":content,@"msg_flag":msg_flag};
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postSendVoiceMsgMid:(NSString *)mid content:(NSString *)content msg_flag:(NSString *)msg_flag complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"sendVoiceMsg"]];
    self.parameters = @{@"mid":mid,@"content":content,@"msg_flag":msg_flag};
    [self requestWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

- (void)postUploadAudio:(NSString *)filePath complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    NSURL * url = [NSURL URLWithString:filePath];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", @"application/x-javascript",@"application/octet-stream", nil];

    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    if (cookie != nil) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"MyCook"];
    }
    
    [manager POST:@"http://itf.6ewei.com/api/MasterData/uploadAudio" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";

        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", str];

        NSLog(@"上传文件路径-----   %@",url);

        NSData *fileData = [NSData dataWithContentsOfFile:filePath];

        [formData appendPartWithFileData:fileData name:@"video" fileName:fileName mimeType:@"application/octet-stream"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"上传进度-----   %f",progress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"上传成功 %@",responseObject);
        HttpGeneralBackModel *model = [HttpGeneralBackModel new];
        [model setValuesForKeysWithDictionary:responseObject];

        if (complete) {
            complete(model);
        }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HttpGeneralBackModel *model = [HttpGeneralBackModel new];
        model.error = error;
        model.retcode = 1;
        
        if (complete) {
            complete(model);
        }

    }];
    
}

-(void)postSaveMedicalRcd:(SaveMedicalRcdModel *)saveModel complete:(void (^)(HttpGeneralBackModel *genneralBackModel))complete{
    
    self.urlString = [self getRequestUrl:@[@"PatientMsg", @"saveMedicalRcd"]];
    self.parameters = [self getParametersWithClass:saveModel];
    
    [self requestSystemWithIsGet:NO success:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (complete) {
            complete(genneralBackModel);
        }
        
    } failure:^(NSError *error) {
        
        if (complete) {
            complete(nil);
        }
        
    }];
    
}

@end
