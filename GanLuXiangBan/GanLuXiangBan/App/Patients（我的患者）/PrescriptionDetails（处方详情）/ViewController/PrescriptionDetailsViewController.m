//
//  PrescriptionDetailsViewController.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/17.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "PrescriptionDetailsViewController.h"
#import "PrescriptionDetailsViewModel.h"
#import "PrescriptionDetailsView.h"

@interface PrescriptionDetailsViewController ()

@property (nonatomic, strong) PrescriptionDetailsView *prescriptionDetailsView;
@property (nonatomic, strong) UIView *infoView;
    
@end

@implementation PrescriptionDetailsViewController
@synthesize prescriptionDetailsView;
@synthesize infoView;
    
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getDataSource];
    
}


#pragma mark - lazy
- (PrescriptionDetailsView *)prescriptionDetailsView {
    
    if (!prescriptionDetailsView) {
        
        prescriptionDetailsView = [[PrescriptionDetailsView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.navHeight - 70) style:UITableViewStyleGrouped];
        prescriptionDetailsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:prescriptionDetailsView];
    }
    
    return prescriptionDetailsView;
}


- (UIView *)infoView {
    
    if (!infoView) {
        
        infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(prescriptionDetailsView.frame), ScreenWidth, 70)];
        [self.view addSubview:infoView];
        
        CGFloat width = (ScreenWidth - 40) / 2;
        NSArray *titles = @[@"医       师: ", @"调配药师/士: ", @"审核药师: ", @"核对、发药药师: "];
        NSArray *contents = @[@"", @"", @"", @""];
        
        PrescriptionDetailsModel *model = self.prescriptionDetailsView.model;
        if (model != nil) {
            contents = @[[self isNull:model.recipe_drname],
                         [self isNull:model.allocate_drname],
                         [self isNull:model.check_drname],
                         [self isNull:model.medicine_drname]];
        }
        
        for (int i = 0; i < titles.count; i++) {
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (width + 10) * (i % 2), 15 + 23 * (i / 2), width, 14)];
            titleLabel.tag = i + 1000;
            titleLabel.text = [NSString stringWithFormat:@"%@ %@", titles[i], contents[i]];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
            [infoView addSubview:titleLabel];
        }
    }
    
    return infoView;
}

#pragma mark - request
- (void)getDataSource {
    
    [[PrescriptionDetailsViewModel new] getElectronRecipeDetail:self.idString complete:^(id object) {
        self.prescriptionDetailsView.model = object;
        self.infoView.backgroundColor = [UIColor whiteColor];
        
        if ([self.prescriptionDetailsView.model.channel integerValue] == 0) {
            self.title = @"遵义汇川快问互联网医院电子处方单";
        }else{
            self.title = @"广州东泰医疗门诊部电子处方单";
        }
        
    }];
}

// 是否为空
- (NSString *)isNull:(NSString *)string {
    
    if (!string) {
        return @"";
    }

    if ([string isKindOfClass:[NSString class]]) {
        
        if ([string isEqualToString:@"<null>"] ||
            [string isEqualToString:@"[null]"] ||
            [string isEqualToString:@"(null)"])
        {
            return @"";
        }
        else return string;
    }
    
    return @"";
}

@end
