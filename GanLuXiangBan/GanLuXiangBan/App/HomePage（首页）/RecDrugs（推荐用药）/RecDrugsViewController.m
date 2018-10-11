//
//  RecDrugsViewController.m
//  GanLuXiangBan
//
//  Created by 尚洋 on 2018/6/5.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "RecDrugsViewController.h"
#import "RecDrugsRequest.h"
#import "RecDrugsModel.h"
#import "RecDrugsView.h"
#import "AddDrugsViewController.h"
#import "DrugDosageModel.h"
#import "MedicationDetailsViewController.h"
#import "SearchView.h"
#import "DiseaseLibraryView.h"
#import "DiseasesRequest.h"
#import "ContinueModel.h"
#import "ChatDrugsModel.h"

@interface RecDrugsViewController ()

@property (nonatomic ,strong) RecDrugsView *recDrugsView;

@property (nonatomic ,strong) UIButton *collectionButton;

@property (nonatomic ,retain) NSMutableArray *dataArray;

@property (nonatomic ,strong) AddDrugsViewController *addDrugsView;

#pragma mark  ------- 临床诊断 ----------

@property (nonatomic ,strong) UIView *clinicalDiagnosisView;

@property (nonatomic ,retain) DiseasesRequest *diseasesRequest;

@property (nonatomic ,strong) SearchView *searchView;

@property (nonatomic ,strong) DiseaseLibraryView *diseaseLibraryView;

@property (nonatomic ,copy) NSString *keyString;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic ,assign) NSUInteger pagesize;

@property (nonatomic ,copy) NSString *check_id;

@property (nonatomic ,copy) NSString *recipelist_id;

@end

@implementation RecDrugsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐用药";
    
    self.pagesize = 50;
    
    self.model = [RecDrugsModel new];
    
    [self initUI];
    
    if (self.type != 1) {
        
        [self requst];
        
    }
    
    if (self.initialRecipeInfoModel != nil) {
        [self requst:self.initialRecipeInfoModel];
    }
    
    [self block];
    
    self.dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDurgDosage:) name:@"AddDurgDosage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyDurgDosage:) name:@"ModifyDurgDosage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDurgDosage:) name:@"DeleteDurgDosage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ContinuePrescription:) name:@"ContinuePrescription" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeRecDrug:) name:@"CloseRecDrug" object:nil];
    
}

-(void)initUI{
    
    self.recDrugsView = [RecDrugsView new];
    self.recDrugsView.type = self.type;
    [self.view addSubview:self.recDrugsView];
    
    self.recDrugsView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 50);
    
    self.collectionButton = [UIButton new];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    
    if (self.type != 0) {
        [self.collectionButton setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        [self.collectionButton setTitle:@"保存并生成二维码" forState:UIControlStateNormal];
    }
    [self.collectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionButton setBackgroundColor: [UIColor orangeColor]];
    [self.collectionButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionButton];
    
    self.collectionButton.sd_layout
    .centerYEqualToView(self.view)
    .widthIs(ScreenWidth)
    .heightIs(50)
    .bottomSpaceToView(self.view, 0);
    
}

-(void)requst{
    
    WS(weakSelf)
        
    [[RecDrugsRequest new] getInitialTmpRecipecomplete:^(HttpGeneralBackModel *genneralBackModel) {
        
        if (genneralBackModel.retcode == 0) {
            
            [weakSelf.model setValuesForKeysWithDictionary:genneralBackModel.data];
            weakSelf.model.age = weakSelf.age;
            weakSelf.model.gender = weakSelf.gender;
            weakSelf.model.patient_name = weakSelf.name;
            
            weakSelf.recDrugsView.model = weakSelf.model;
            
            weakSelf.serialNumber = weakSelf.model.code;
            weakSelf.dataString = weakSelf.model.createtime;
            
        }
        
    }];

}

-(void)requst:(InitialRecipeInfoModel *)model{
    WS(weakSelf);
    
    [[RecDrugsRequest new] postInitialRecipeInfo:model :^(HttpGeneralBackModel *genneralBackModel) {
        
        if (genneralBackModel.retcode == 0) {
            
            [weakSelf.model setValuesForKeysWithDictionary:genneralBackModel.data];
            
            if (weakSelf.name != nil) {
             
                weakSelf.model.age = weakSelf.age;
                weakSelf.model.gender = weakSelf.gender;
                weakSelf.model.patient_name = weakSelf.name;
                
            }
            
            if ([genneralBackModel.data objectForKey:@"current_check_id"]) {
                weakSelf.model.check_id = [genneralBackModel.data objectForKey:@"current_check_id"];
            }
            
            if ([genneralBackModel.data objectForKey:@"name"]) {
                weakSelf.model.patient_name = [genneralBackModel.data objectForKey:@"name"];
            }
            
            if ([genneralBackModel.data objectForKey:@"current_check_result"]) {
                weakSelf.model.check_result = [genneralBackModel.data objectForKey:@"current_check_result"];
            }
            
            if ([genneralBackModel.data objectForKey:@"druguses"]) {
                weakSelf.model.druguse_items = [genneralBackModel.data objectForKey:@"druguses"];
            }
            if ([genneralBackModel.data objectForKey:@"code"]) {
                weakSelf.model.code = [genneralBackModel.data objectForKey:@"code"];
            }
            
            if ([genneralBackModel.data objectForKey:@"createtime"]) {
                weakSelf.model.createtime = [genneralBackModel.data objectForKey:@"createtime"];
            }
            
            weakSelf.recDrugsView.model = weakSelf.model;
            
            if (weakSelf.model.druguse_items.count != 0) {
                
                [self.dataArray removeAllObjects];
                
                for (NSDictionary *dict in weakSelf.model.druguse_items) {
                    
                    DrugDosageModel *drugDosageModel = [DrugDosageModel new];
                    [drugDosageModel setValuesForKeysWithDictionary:dict];
                    
                    [self.dataArray addObject:drugDosageModel];
                    
                }
                
                self.recDrugsView.dataSource = self.dataArray;
                
                NSMutableArray *drugArray = [NSMutableArray array];
                
                for (DrugDosageModel *drugDosageModel in self.dataArray) {
                    
                    [drugArray addObject:drugDosageModel.drugid];
                    
                }
                
                self.addDrugsView.array = drugArray;
                
            }

            
        }
        
    }];
    
}

-(void)block{
    WS(weakSelf)
    
    self.recDrugsView.pushBlock = ^(NSArray *pushVC) {
        
        NSMutableArray *drugArray = [NSMutableArray array];
        
        for (DrugDosageModel *model in pushVC) {
            
            [drugArray addObject:model.drugid];
            
        }
        
        weakSelf.addDrugsView = [[AddDrugsViewController alloc] init];
        weakSelf.addDrugsView.array = drugArray;
        [weakSelf.navigationController pushViewController:weakSelf.addDrugsView animated:YES];
        
    };
    
    self.recDrugsView.openBlock = ^(NSString *openString) {
      
        if ([openString isEqualToString:@"临床诊断"]) {
            
            weakSelf.clinicalDiagnosisView = [UIView new];
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.clinicalDiagnosisView];
            
            weakSelf.clinicalDiagnosisView.sd_layout
            .xIs(0)
            .yIs(0)
            .widthIs(ScreenWidth)
            .heightIs(ScreenHeight);
            
            [weakSelf openClinicalDiagnosis];
            
        }
        
    };
    
    self.recDrugsView.requestBlock = ^(NSString *check_id, NSString *recipelist_id) {
        
        [[RecDrugsRequest new] getRecipeDruguseCheck_id:weakSelf.mid Recipelist_id:check_id :^(HttpGeneralBackModel *genneralBackModel) {
           
            NSArray *array = genneralBackModel.data;
            
            if (array.count > 0) {
                
                [weakSelf.dataArray removeAllObjects];
                
                for (NSDictionary *dict in array) {
                    
                    DrugDosageModel *drugDosageModel = [DrugDosageModel new];
                    [drugDosageModel setValuesForKeysWithDictionary:dict];
                    
                    [weakSelf.dataArray addObject:drugDosageModel];
                    
                }
                
                weakSelf.recDrugsView.dataSource = weakSelf.dataArray;
                
                NSMutableArray *drugArray = [NSMutableArray array];
                
                for (DrugDosageModel *drugDosageModel in weakSelf.dataArray) {
                    
                    [drugArray addObject:drugDosageModel.drugid];
                    
                }
                
                weakSelf.addDrugsView.array = drugArray;
                
            }

        }];
        
    };
    
}

-(void)addDurgDosage:(NSNotification *)sender{
    
    DrugDosageModel *model = sender.object;
    
    [self.dataArray addObject:model];
    
    self.recDrugsView.dataSource = self.dataArray;
    
    NSMutableArray *drugArray = [NSMutableArray array];
    
    for (DrugDosageModel *model in self.dataArray) {
        
        [drugArray addObject:model.drugid];
        
    }
    
    self.addDrugsView.array = drugArray;
    
}

-(void)modifyDurgDosage:(NSNotification *)sender{
    
    DrugDosageModel *drugDosageModel = sender.object;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        DrugDosageModel *model = self.dataArray[i];
        
        if ([model.drugid isEqualToString:drugDosageModel.drugid]) {
            
            [self.dataArray replaceObjectAtIndex:i withObject:drugDosageModel];
            
        }
        
    }
    
    self.recDrugsView.dataSource = self.dataArray;
    
    NSMutableArray *drugArray = [NSMutableArray array];
    
    for (DrugDosageModel *model in self.dataArray) {
        
        [drugArray addObject:model.drugid];
        
    }
    
    self.addDrugsView.array = drugArray;
    
}

-(void)deleteDurgDosage:(NSNotification *)sender{
    
    DrugDosageModel *drugDosageModel = sender.object;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        DrugDosageModel *model = self.dataArray[i];
        
        if ([model.drugid isEqualToString:drugDosageModel.drugid]) {
            [self.dataArray removeObjectAtIndex:i];
        }
        
    }
    
    self.recDrugsView.dataSource = self.dataArray;
    
    NSMutableArray *drugArray = [NSMutableArray array];
    
    for (DrugDosageModel *model in self.dataArray) {
        
        [drugArray addObject:model.drugid];
        
    }
    
    self.addDrugsView.array = drugArray;
    
}

-(void)ContinuePrescription:(NSNotification *)sender{
    
    [self.recDrugsView.dataSource removeAllObjects];
    
    [self.dataArray removeAllObjects];
    
    ContinueModel *model = sender.object;
    
    self.initialRecipeInfoModel = [InitialRecipeInfoModel new];
    self.initialRecipeInfoModel.mid = model.mid;
    self.initialRecipeInfoModel.medical_id = model.medical_id;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in model.items) {
        
        NSString *string = [NSString stringWithFormat:@"%ld",[[dict objectForKey:@"qty"] integerValue]];
        
        [array addObject:@{@"drug_code":dict[@"drug_code"],@"qty":string}];
        
    }
    
    self.initialRecipeInfoModel.drugs = array;
    
    [self requst:self.initialRecipeInfoModel];
    
}

-(void)setInitialRecipeInfoModel:(InitialRecipeInfoModel *)initialRecipeInfoModel{
    
    _initialRecipeInfoModel = initialRecipeInfoModel;

}

-(void)collection:(UIButton *)button{
    
    if (self.recDrugsView.model.patient_name == nil) {
        [self.view makeToast:@"名字为必填项"];
        return;
    }
    if (self.recDrugsView.model.check_result == nil) {
        [self.view makeToast:@"临床诊断为必填项"];
        return;
    }
    if (self.recDrugsView.model.gender == nil) {
        [self.view makeToast:@"性别为必填项"];
        return;
    }
    if (self.recDrugsView.model.age == nil) {
        [self.view makeToast:@"年龄为必填项"];
        return;
    }

    NSMutableArray *array = [NSMutableArray array];
    
    for (DrugDosageModel *model in self.dataArray) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        unsigned int count = 0;
        objc_property_t *properList = class_copyPropertyList([model class], &count);
        
        for (int i = 0; i < count; i++) {
            
            objc_property_t property = properList[i];
            
            NSString *keyString = [NSString stringWithUTF8String:property_getName(property)];
            NSString *valueString = [model valueForKey:keyString];
            valueString = valueString.length == 0 ? @"" : valueString;
            [parameters setValue:valueString forKey:keyString];
            
        }
        
        free(properList);
        
        [array addObject:parameters];
        
    }
    
    self.recDrugsView.model.druguse_items = array;
    
    if (self.recDrugsView.model.druguse_items.count == 0) {
        [self.view makeToast:@"您还没添加药品"];
        return;
    }
    
    self.collectionButton.userInteractionEnabled = NO;
    
    WS(weakSelf);
    
    if ([button.titleLabel.text isEqualToString:@"保存并生成二维码"]) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *DateTime = [formatter stringFromDate:date];
        
        self.recDrugsView.model.createtime = DateTime;
        
        [[RecDrugsRequest new] postSaveTmpRecipe:self.recDrugsView.model :^(HttpGeneralBackModel *genneralBackModel) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MedicationDetailsViewController *medicationDetailsView = [[MedicationDetailsViewController alloc] init];
                MedicalRecordsModel *medicalModel = [MedicalRecordsModel new];
                medicalModel.recipe_id = [genneralBackModel.data integerValue];
                medicalModel.status = @"-1";
                medicationDetailsView.model = medicalModel;
                [weakSelf.navigationController pushViewController:medicationDetailsView animated:YES];
                
            });
            
        }];
        
    }else{
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveRecDrugs" object:self.recDrugsView.model];

        if (self.recDrugsSaveBlock) {
            self.recDrugsSaveBlock(self.recDrugsView.model);
        }
        
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
 
}

-(void)openClinicalDiagnosis{
    
    UIView *bgView = [UIView new];
    bgView .backgroundColor = RGBA(51, 51, 51, 0.7);
    bgView .userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [bgView  addGestureRecognizer:backTap];
    [self.clinicalDiagnosisView addSubview:bgView];
    
    bgView.sd_layout
    .leftSpaceToView(self.clinicalDiagnosisView, 0)
    .rightSpaceToView(self.clinicalDiagnosisView, 0)
    .topSpaceToView(self.clinicalDiagnosisView, 0)
    .bottomSpaceToView(self.clinicalDiagnosisView, 0);
    
    self.searchView = [SearchView new];
    [self.searchView.searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.searchView.textField addTarget:self action:@selector(searchViewTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.clinicalDiagnosisView addSubview:self.searchView];
    
    self.searchView.sd_layout
    .leftSpaceToView(self.clinicalDiagnosisView, 0)
    .rightSpaceToView(self.clinicalDiagnosisView, 0)
    .topSpaceToView(self.clinicalDiagnosisView, 150)
    .heightIs(50);
    
    self.diseaseLibraryView = [DiseaseLibraryView new];
    self.diseaseLibraryView.typeInteger = 1;
    [self.clinicalDiagnosisView addSubview:self.diseaseLibraryView];
    
    self.diseaseLibraryView.sd_layout
    .leftSpaceToView(self.clinicalDiagnosisView, 0)
    .rightSpaceToView(self.clinicalDiagnosisView, 0)
    .topSpaceToView(self.searchView, 0)
    .bottomSpaceToView(self.clinicalDiagnosisView, 0);
    
    self.keyString = @"";
    
    self.page = 1;
    
    [self request:self.keyString page:self.page];
    
    [self refresh];
    
    WS(weakSelf);
    [self.searchView setSearchBlock:^(NSString *searchTextString) {
        
        weakSelf.model.check_result = weakSelf.searchView.textField.text;
        
        weakSelf.recDrugsView.model = weakSelf.model;
        
        [[RecDrugsRequest new] getRecipeDruguseCheck_id:weakSelf.check_id Recipelist_id:weakSelf.recipelist_id :^(HttpGeneralBackModel *genneralBackModel) {
            
            NSArray *array = genneralBackModel.data;
            
            if (array.count > 0) {
                
//                [weakSelf.dataArray removeAllObjects];
                
                for (NSDictionary *dict in array) {
                    
                    DrugDosageModel *drugDosageModel = [DrugDosageModel new];
                    [drugDosageModel setValuesForKeysWithDictionary:dict];
                    
                    [weakSelf.dataArray addObject:drugDosageModel];
                    
                }
                
                weakSelf.recDrugsView.dataSource = weakSelf.dataArray;
                
                NSMutableArray *drugArray = [NSMutableArray array];
                
                for (DrugDosageModel *drugDosageModel in weakSelf.dataArray) {
                    
                    [drugArray addObject:drugDosageModel.drugid];
                    
                }
                
                weakSelf.addDrugsView.array = drugArray;
                
            }
            
        }];
        
        [weakSelf back];
        
    }];
    
    self.diseaseLibraryView.collectBlock = ^(DiseaseLibraryModel *model) {
        
        weakSelf.searchView.textField.text = model.name;
        
        weakSelf.check_id = [NSString stringWithFormat:@"%ld",model.id];
        
        weakSelf.recipelist_id = [NSString stringWithFormat:@"%ld",model.pkid];
        
//        weakSelf.model.check_id = [NSString stringWithFormat:@"%ld",model.pkid];
        
    };
    
}

-(void)searchViewTextFieldDidChange:(UITextField *)textField{
    
    [self.diseaseLibraryView.dataSource removeAllObjects];
    
    self.keyString = textField.text;
    
    [self request:self.keyString page:self.page];
    
}

-(void)closeRecDrug:(NSNotification *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)request:(NSString *)key page:(NSInteger)page{
    
    self.diseasesRequest = [DiseasesRequest new];
    
    WS(weakSelf)
    [self.diseasesRequest getdrDiseaseLstKey:key pageindex:page pagesize:self.pagesize complete:^(HttpGeneralBackModel *genneralBackModel) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dict in genneralBackModel.data) {
            
            DiseaseLibraryModel *model = [DiseaseLibraryModel new];
            [model setValuesForKeysWithDictionary:dict];
            
            [dataArray addObject:model];
            
        }
        
        [weakSelf.diseaseLibraryView addData:dataArray];
        
        [weakSelf.diseaseLibraryView.myTable.mj_header endRefreshing];
        [weakSelf.diseaseLibraryView.myTable.mj_footer endRefreshing];
        
    }];
    
}

-(void)refresh{
    
    WS(weakSelf)
    self.diseaseLibraryView.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.diseaseLibraryView.dataSource removeAllObjects];
        [weakSelf request:weakSelf.keyString page:weakSelf.page];
        
    }];
    
    self.diseaseLibraryView.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        weakSelf.pagesize = weakSelf.pagesize + 30;
        [weakSelf request:weakSelf.keyString page:weakSelf.page];
        
    }];
}

-(void)back{
    
    [self.clinicalDiagnosisView removeFromSuperview];
    
}

@end
