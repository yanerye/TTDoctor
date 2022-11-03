//
//  YKPatientDetailVC.m
//  TTDoctor
//
//  Created by YK on 2021/9/22.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKPatientDetailVC.h"
#import "BFCButton.h"

@interface YKPatientDetailVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *tagLabel;


@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) NSDictionary *infoDict;


@end

@implementation YKPatientDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(239, 238, 242);
    self.title = @"患者详情";
    [self layoutAllSubviews];
    [self getPatientInfo];
}
- (void)layoutAllSubviews{

    [self.view addSubview:self.headerView];
    [self.view addSubview:self.infoView];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];

    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(285);
    }];

}

- (void)getPatientInfo{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getpatientDetailWithPatientId:self.patientId completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            self.infoDict = responseObject;
            [self fillData];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}


#pragma mark - init

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = COMMONCOLOR;

        UIView *nameView = [UIView new];
        nameView.backgroundColor = RGBACOLOR(239, 238, 242);
        nameView.layer.cornerRadius = 50;
        nameView.layer.borderColor = [UIColor whiteColor].CGColor;
        nameView.layer.borderWidth = 4.0;
        [_headerView addSubview:nameView];
        
        self.firstNameLabel = [UILabel new];
        self.firstNameLabel.font = [UIFont boldSystemFontOfSize:40];
        self.firstNameLabel.textColor = RGBACOLOR(143, 142, 146);
        [nameView addSubview:self.firstNameLabel];
        
        [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView).offset(20);
            make.centerX.mas_equalTo(_headerView);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(nameView);
        }];
        
        self.infoLabel = [UILabel new];
        self.infoLabel.font = [UIFont systemFontOfSize:16];
        self.infoLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:self.infoLabel];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameView.mas_bottom).offset(15);
            make.centerX.mas_equalTo(_headerView);
        }];
        
        self.tagLabel = [UILabel new];
        self.tagLabel.font = [UIFont systemFontOfSize:13];
        self.tagLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:self.tagLabel];

        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(15);
            make.centerX.mas_equalTo(_headerView);
        }];
        
    }
    return _headerView;
}

- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [UIView new];
        
        int k = 0;
        
        for (int i = 0; i < 3; i ++) {
            for (int j = 0; j < 3 ; j ++) {
                if (k < 7) {
                    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 3 * j, 95 * i, KWIDTH / 3, 95)];
                    tempView.backgroundColor = [UIColor whiteColor];
                    [_infoView addSubview:tempView];
                    
                    BFCButton *collectBtn = [BFCButton buttonWithType:UIButtonTypeCustom];
                    collectBtn.tag = k;
                    [collectBtn addTarget:self action:@selector(onButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
                    collectBtn.alignType = BFCButtonAlignTypeTextBottom;
                    collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [collectBtn setTitleColor:RGBACOLOR(51, 51, 51) forState:UIControlStateNormal];
                    [tempView addSubview:collectBtn];
                    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(tempView);
                        make.height.mas_equalTo(65);
                    }];
                    
                    if (k == 0) {
                        [collectBtn setImage:[UIImage imageNamed:@"patient_baseInfo"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"基本信息" forState:UIControlStateNormal];
                        
                        UIView *rightView = [UIView new];
                        rightView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:rightView];

                        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.bottom.right.mas_equalTo(tempView);
                            make.width.mas_equalTo(1);
                        }];
                        
                        UIView *bottomView = [UIView new];
                        bottomView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:bottomView];

                        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.bottom.right.mas_equalTo(tempView);
                            make.height.mas_equalTo(1);
                        }];

                    }else if (k == 1){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_disease"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"病程管理" forState:UIControlStateNormal];
                        
                        UIView *rightView = [UIView new];
                        rightView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:rightView];

                        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.bottom.right.mas_equalTo(tempView);
                            make.width.mas_equalTo(1);
                        }];
                        
                        UIView *bottomView = [UIView new];
                        bottomView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:bottomView];

                        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.bottom.right.mas_equalTo(tempView);
                            make.height.mas_equalTo(1);
                        }];
                        
                    }else if (k == 2){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_plan"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"随访方案" forState:UIControlStateNormal];
                        
                        UIView *bottomView = [UIView new];
                        bottomView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:bottomView];

                        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.bottom.right.mas_equalTo(tempView);
                            make.height.mas_equalTo(1);
                        }];
                        
                    }else if (k == 3){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_project"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"课题项目" forState:UIControlStateNormal];
                        
                        UIView *rightView = [UIView new];
                        rightView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:rightView];

                        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.bottom.right.mas_equalTo(tempView);
                            make.width.mas_equalTo(1);
                        }];
                        
                        UIView *bottomView = [UIView new];
                        bottomView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:bottomView];

                        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.bottom.right.mas_equalTo(tempView);
                            make.height.mas_equalTo(1);
                        }];
                        
                    }else if (k == 4){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_chat"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"在线交流" forState:UIControlStateNormal];
                        
                        UIView *rightView = [UIView new];
                        rightView.backgroundColor = RGBACOLOR(235, 235, 235);
                        [tempView addSubview:rightView];

                        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.bottom.right.mas_equalTo(tempView);
                            make.width.mas_equalTo(1);
                        }];
                    }else if (k == 5){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_healthRecord"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"健康档案" forState:UIControlStateNormal];
                    }else if (k == 6){
                        [collectBtn setImage:[UIImage imageNamed:@"patient_riskAssess"] forState:UIControlStateNormal];
                        [collectBtn setTitle:@"风险评估" forState:UIControlStateNormal];
                    }
                    
                }
                
                k ++;
            }
        }
        
    }
    return _infoView;
}

- (void)onButtonsAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}


#pragma mark - 处理数据

- (void)fillData{
    self.firstNameLabel.text = [[NSString stringWithFormat:@"%@",self.infoDict[@"patientName"]] substringToIndex:1];
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@   %@岁", self.infoDict[@"patientName"], self.infoDict[@"sex"], self.infoDict[@"age"]];
    NSString *tagStr = [NSString stringWithFormat:@"%@",self.infoDict[@"tags"]];
    if ([tagStr isEqualToString:@"(null)"]) {
        self.tagLabel.text = @"未设置标签";
    }else{
        self.tagLabel.text = tagStr;
    }
}


@end
