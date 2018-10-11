//
//  SubscribeDetailsViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/17.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "SubscribeDetailsViewController.h"
#import "PatientsDetailsViewController.h"
#import "HelpWebViewController.h"
#import "SubscribeDetailsView.h"
#import "SubscribeDetailsViewModel.h"
#import "DeleteTipView.h"
#import "RecDrugsViewController.h"
#import "SaveMedicalRcdModel.h"
#import "MessageRequest.h"
#import "RefusedView.h"
#import "ThroughView.h"
#import "PrescriptionDetailsViewController.h"

@interface SubscribeDetailsViewController ()

@property (nonatomic, strong) SubscribeDetailsView *subscribeDetailsView;
@property (nonatomic, strong) NSString *helpString;

@end

@implementation SubscribeDetailsViewController
@synthesize subscribeDetailsView;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"预约详情";
    
    [self getDataSource];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveRecDrugs:) name:@"SaveRecDrugs" object:nil];
    
}

- (void)goViewController {
    
    if (self.subscribeDetailsView.model.medical_id > 0) {
        
        PrescriptionDetailsViewController *vc = [[PrescriptionDetailsViewController alloc] init];
        vc.idString = [NSString stringWithFormat:@"%ld",self.subscribeDetailsView.model.medical_id];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        PatientsDetailsViewController *vc = [PatientsDetailsViewController new];
        vc.midString = self.subscribeDetailsView.model.mid;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)addTypeView:(NSInteger)state {
    
    int type = [self.subscribeDetailsView.model.pre_type intValue];
    if (state == 4) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 40);
        button.backgroundColor = kMainColor;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:@"查看诊疗记录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    else if (state == 1 || (state == 2 && type == 3)) {
        
        NSString *titleString = @"等待用户付款";
        NSString *buttonTitleString = @"客服";
        
        UIColor *textColor = [UIColor colorWithHexString:@"0x333333"];
        UIColor *titleBgColor = [UIColor whiteColor];
        UIColor *btnBgColor = [UIColor colorWithHexString:@"0xff9500"];
        if (state == 2) {
            
            titleString = @"结束咨询";
            buttonTitleString = @"地址";
            textColor = [UIColor whiteColor];
            titleBgColor = kMainColor;
            btnBgColor = [UIColor colorWithHexString:@"0x48d6a1"];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth / 3 * 2, 40)];
        titleLabel.text = titleString;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = textColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = titleBgColor;
        titleLabel.userInteractionEnabled = YES;
        [self.view addSubview:titleLabel];
        
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            
            if (state == 2) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DeleteTipView *deleteTipView = [[DeleteTipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    @weakify(deleteTipView);
                    [deleteTipView setGoViewController:^{
                     
                        @strongify(deleteTipView);
                        [deleteTipView removeFromSuperview];
                        
                        RecDrugsViewController *recDrugsView = [RecDrugsViewController new];
                        recDrugsView.mid = self.subscribeDetailsView.model.mid;
                        recDrugsView.name = self.subscribeDetailsView.model.patient_name;
                        recDrugsView.age = self.subscribeDetailsView.model.age;
                        recDrugsView.gender = self.subscribeDetailsView.model.gender;
                        recDrugsView.type = 2;
                        [self.navigationController pushViewController:recDrugsView animated:YES];
                        
                        recDrugsView.recDrugsSaveBlock = ^(RecDrugsModel *recDrugsModel) {
                            
                            SaveMedicalRcdModel *saveModel = [SaveMedicalRcdModel new];
                            saveModel.patient_name = recDrugsModel.patient_name;
                            saveModel.mid = self.subscribeDetailsView.model.mid;
                            saveModel.patient_age = recDrugsModel.age;
                            saveModel.patient_gender = recDrugsModel.gender;
                            saveModel.code = [NSString stringWithFormat:@"%ld",[recDrugsModel.code integerValue]];
                            saveModel.check_id = [NSString stringWithFormat:@"%ld",[recDrugsModel.check_id integerValue]];
                            saveModel.rcd_result = recDrugsModel.check_result;
                            saveModel.druguse_items = recDrugsModel.druguse_items;
                            saveModel.msg_flag = @"0";
                            saveModel.msg_id = @"0";
                            saveModel.msg_id = @"0";
                            saveModel.visit_id = @"0";
                            saveModel.allergy_codes = @"";
                            saveModel.allergy_names = @"";
                            saveModel.analysis_result = @"";
                            saveModel.analysis_suggestion = @"";
                            [[MessageRequest new] postSaveMedicalRcd:saveModel complete:^(HttpGeneralBackModel *genneralBackModel) {
                                
                                if (genneralBackModel.retcode == 0) {
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRecDrug" object:nil];
                                    
                                    [self.view makeToast:@"保存成功"];
                                    
                                }else{
                                    
                                    [self.view makeToast:genneralBackModel.retmsg];
                                    
                                }
                                
                            }];
                            
                        };
                        
                    }];
                    
                    
                    [deleteTipView setExitBlock:^{
                        [self endConsultation];
                    }];
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:deleteTipView];
                });
            }
        }];
        [titleLabel addGestureRecognizer:tap];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth / 3 * 2, titleLabel.y, ScreenWidth / 3, 40);
        button.backgroundColor = btnBgColor;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:buttonTitleString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        if (state == 1) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 15)];
            imgView.x = (button.width - imgView.width) / 2;
            imgView.image = [UIImage imageNamed:@"service"];
            [button addSubview:imgView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, button.width, 15)];
            titleLabel.text = buttonTitleString;
            titleLabel.font = [UIFont systemFontOfSize:11];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:titleLabel];
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           
            if (state == 1) {
                
                NSString *titleString = @"助理上班时间：7 * 8小时\n(09:00 - 18:00)";
                [self alertWithTitle:titleString msg:@"020-81978876" isShowCancel:YES complete:^{
                    
                    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"020-81978876"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }];

            }
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 0.5)];
        lineView.backgroundColor = kLineColor;
        [self.view addSubview:lineView];
    }
    else if (state == 3) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth / 3 * 2, 15)];
        titleLabel.text = @"预约已关闭";
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth / 3 * 2, 11)];
        timeLabel.text = [NSString stringWithFormat:@"关闭时间: %@", self.subscribeDetailsView.model.close_time];;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor colorWithHexString:@"0xce3935"];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:timeLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth / 3 * 2, 0, ScreenWidth / 3, 40);
        button.backgroundColor = timeLabel.textColor;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"查看原因" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookWhy) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 0.5)];
        lineView.backgroundColor = kLineColor;
        [self.view addSubview:lineView];
    }
    else if (state == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        if (type == 2) {

            NSArray *titles = @[@"呼出", @"结束咨询"];
            NSArray *colors = @[[UIColor colorWithHexString:@"0xf09b37"], kMainColor];
            for (int i = 0; i < 2; i++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, bgView.height);
                button.backgroundColor = colors[i];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button setTitle:titles[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [bgView addSubview:button];
                
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    
                    if (i == 0) {
                        
                        [self alertWithTitle:@"呼出" msg:@"是否播打给患者" isShowCancel:YES complete:^{
                           
                            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.subscribeDetailsView.model.mobile];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                        }];
                    }
                    else {
                        
                        [self endConsultation];
                    }
                }];
            }
        }
    }
    else if (state == 0 && type == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.subscribeDetailsView.frame), ScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        NSArray *titles = @[@"通过", @"拒绝", @"客服"];
        NSArray *colors = @[kMainColor, [UIColor colorWithHexString:@"0xbd4542"], [UIColor colorWithHexString:@"0xf09b37"]];
        for (int i = 0; i < 3; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ScreenWidth / 3 * i, 0, ScreenWidth / 3, bgView.height);
            button.backgroundColor = colors[i];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bgView addSubview:button];
            
            if (i == 2) {
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 15)];
                imgView.x = (button.width - imgView.width) / 2;
                imgView.image = [UIImage imageNamed:@"service"];
                [button addSubview:imgView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, button.width, 15)];
                titleLabel.text = titles[i];
                titleLabel.font = [UIFont systemFontOfSize:11];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [button addSubview:titleLabel];
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                
                if (i == 0) {
                    
                    [self through];
                }
                else if (i == 1) {
                    
                    [self refused];
                }
                else {
                    
                    NSString *titleString = @"助理上班时间：7 * 8小时\n(09:00 - 18:00)";
                    [self alertWithTitle:titleString msg:@"020-81978876" isShowCancel:YES complete:^{
                        
                        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"020-81978876"];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }];
                }
            }];
        }
    }
}

// 结束咨询
- (void)endConsultation {
    
    [[SubscribeDetailsViewModel new] closeVisit:self.idString complete:^(id object) {

        [self getDataSource];
    }];
}

// 通过
- (void)through {
    
    NSString *typeString = @"图文咨询";
    if ([self.subscribeDetailsView.model.pre_type intValue] == 2) {
        typeString = @"电话咨询";
    }
    else if ([self.subscribeDetailsView.model.pre_type intValue] == 3) {
        typeString = @"线下咨询";
    }
    
    ThroughView *throughView = [[ThroughView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    throughView.typeString = typeString;
    [throughView setTextBlock:^(NSString *text) {
        [self request:@"true" reason:@"" pre_date:text];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:throughView];
}

// 拒绝
- (void)refused {
    
    RefusedView *refusedView = [[RefusedView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [refusedView setTextBlock:^(NSString *text) {
        [self request:@"flase" reason:text pre_date:@""];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:refusedView];
}

- (void)request:(NSString *)isCheck reason:(NSString *)reason pre_date:(NSString *)preDate {
    
    preDate = preDate.length == 0 ? self.subscribeDetailsView.model.pre_date : preDate;
    [[SubscribeDetailsViewModel new] checkVisit:self.idString pre_type:self.subscribeDetailsView.model.pre_type is_check:isCheck reason:reason pre_date:preDate location:@"" complete:^(id object)
     {
         [self getDataSource];
     }];
}

-(void)lookWhy{
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.subscribeDetailsView.model.closing_reason dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    UILabel *label = [UILabel new];
    [label setAttributedText:attrStr];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:label.text preferredStyle:UIAlertControllerStyleAlert];
    
    //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:ok];//添加确认按钮
    
    //以modal的形式
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - lazy
- (SubscribeDetailsView *)subscribeDetailsView {
    
    if (!subscribeDetailsView) {
        
        subscribeDetailsView = [[SubscribeDetailsView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight - 40) style:UITableViewStyleGrouped];
        [self.view addSubview:subscribeDetailsView];
        
        @weakify(self);
        [subscribeDetailsView setGoViewController:^() {
           
            @strongify(self);
            [self goViewController];
        }];
    }
    
    return subscribeDetailsView;
}


#pragma mark - request
- (void)getDataSource {
    
    [[SubscribeDetailsViewModel new] getPreOrderDetail:self.idString complete:^(id object) {
        
        self.subscribeDetailsView.model = object;
        [self addTypeView:[self.subscribeDetailsView.model.status integerValue]];
        
        if ([self.subscribeDetailsView.model.status intValue] == 4) {
            
            @weakify(self);
            [self getHelp];
            [self addNavRightTitle:@"帮助" complete:^{
               
                @strongify(self);
                HelpWebViewController *vc = [HelpWebViewController new];
                vc.bodyString = self.helpString;
                vc.title = @"帮助";
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
}

- (void)getHelp {
    
    [[SubscribeDetailsViewModel new] getHelpComplete:^(id object) {
        self.helpString = object;
    }];
}

-(void)saveRecDrugs:(NSNotification *)sender{
    
    RecDrugsModel *recDrugsModel = sender.object;
    
    SaveMedicalRcdModel *saveModel = [SaveMedicalRcdModel new];
    saveModel.patient_name = recDrugsModel.patient_name;
    saveModel.mid = self.subscribeDetailsView.model.mid;
    saveModel.patient_age = recDrugsModel.age;
    saveModel.patient_gender = recDrugsModel.gender;
    saveModel.code = [NSString stringWithFormat:@"%ld",[recDrugsModel.code integerValue]];
    saveModel.check_id = [NSString stringWithFormat:@"%ld",[recDrugsModel.check_id integerValue]];
    saveModel.rcd_result = recDrugsModel.check_result;
    saveModel.druguse_items = recDrugsModel.druguse_items;
    saveModel.msg_flag = @"0";
    saveModel.msg_id = @"0";
    saveModel.msg_id = @"0";
    saveModel.visit_id = @"0";
    saveModel.allergy_codes = @"";
    saveModel.allergy_names = @"";
    saveModel.analysis_result = @"";
    saveModel.analysis_suggestion = @"";
    [[MessageRequest new] postSaveMedicalRcd:saveModel complete:^(HttpGeneralBackModel *genneralBackModel) {
        
    }];
    
}

@end
