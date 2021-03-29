//
//  YKQRCodeVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/18.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKQRCodeVC.h"

#define HOSPITALFONT [UIFont systemFontOfSize:14]
#define NAMEFONT [UIFont systemFontOfSize:15]

@interface YKQRCodeVC ()

@property (nonatomic, strong) UIView *QRCodeView;
@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;
@property (nonatomic, strong) UIImageView *QRCodeImageView;


@end

@implementation YKQRCodeVC
{
    YKDoctor * _doctor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.view.backgroundColor = RGBACOLOR(66, 66, 66);
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _doctor = [YKDoctorHelper shareDoctor];
    [self fillData];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.QRCodeView];
    [self.view addSubview:self.userImageView];
    
    [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(60);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.view).offset(-40);
    }];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.QRCodeView.mas_top);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(92, 92));
    }];
}

- (void)fillData{
    NSString *doctorImageStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_doctor.picUrl];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:doctorImageStr] placeholderImage:[UIImage imageNamed:@"我的_医生默认"]];
    [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:_doctor.qrUrl]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",_doctor.familyname,_doctor.professionalRanksName];
    self.hospitalLabel.text = [NSString stringWithFormat:@"%@ %@",_doctor.hospitalName,_doctor.deptName];
}

#pragma mark - init

- (UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [UIImageView new];
        _userImageView.backgroundColor = [UIColor whiteColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 46;
        _userImageView.layer.borderWidth = 5;
        _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _userImageView;
}

- (UIView *)QRCodeView{
    if (!_QRCodeView) {
        _QRCodeView = [UIView new];
        _QRCodeView.layer.cornerRadius = 8;
        _QRCodeView.backgroundColor = [UIColor whiteColor];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.font = NAMEFONT;
        self.nameLabel.textColor = RGBACOLOR(66, 66, 66);
        [_QRCodeView addSubview:self.nameLabel];
        
        self.hospitalLabel = [UILabel new];
        self.hospitalLabel.font = HOSPITALFONT;
        self.hospitalLabel.textColor = RGBACOLOR(169, 169, 169);
        [_QRCodeView addSubview:self.hospitalLabel];
        
        self.QRCodeImageView = [UIImageView new];
        self.QRCodeImageView.backgroundColor = [UIColor lightGrayColor];
        [_QRCodeView addSubview:self.QRCodeImageView];
        
        UILabel *scanLabel = [UILabel new];
        scanLabel.font = NAMEFONT;
        scanLabel.text = @"扫一扫";
        scanLabel.textColor = RGBACOLOR(66, 66, 66);
        [_QRCodeView addSubview:scanLabel];
        
        UILabel *addLabel = [UILabel new];
        addLabel.font = HOSPITALFONT;
        addLabel.text = @"让患者使用微信扫一扫加我";
        addLabel.textColor = RGBACOLOR(169, 169, 169);
        [_QRCodeView addSubview:addLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_QRCodeView);
            make.top.mas_equalTo(_QRCodeView).offset(60);
        }];
        
        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_QRCodeView);
            make.top.mas_equalTo(_QRCodeView).offset(93);
        }];
        
        [self.QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_QRCodeView);
            make.top.mas_equalTo(self.hospitalLabel.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(152, 152));
        }];
        
        [scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_QRCodeView);
            make.top.mas_equalTo(self.QRCodeImageView.mas_bottom).offset(20);
        }];
        
        [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_QRCodeView);
            make.top.mas_equalTo(scanLabel.mas_bottom).offset(20);
        }];
    }
    return _QRCodeView;
}

@end
