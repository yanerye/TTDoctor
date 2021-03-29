//
//  YKSelfInfoVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/23.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKSelfInfoVC.h"

@interface YKSelfInfoVC ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation YKSelfInfoVC
{
    YKDoctor *_doctor;
    NSString *_contentString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    _doctor = [YKDoctorHelper shareDoctor];
    [self layoutAllSubviews];
    [self createRightButtonItems];

}

- (void)layoutAllSubviews{
    [self.view addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(2);
        make.right.mas_equalTo(self.view).offset(-2);
        make.height.mas_equalTo(150);
    }];
    
}

- (void)createRightButtonItems {

    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = right2;
}

#pragma mark - init

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        _contentTextView.layer.cornerRadius = 8;
        _contentTextView.layer.borderColor = COMMONCOLOR.CGColor;
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.font = [UIFont systemFontOfSize:16];
        
        _contentTextView.delegate = self;
        
        if ([self.titleString isEqualToString:@"自我介绍"]) {
            _contentTextView.text = _doctor.selfInfo;
            _contentString = _doctor.selfInfo;
        }else if ([self.titleString isEqualToString:@"诊所公告"]){
            _contentTextView.text = _doctor.sign;
            _contentString = _doctor.sign;
        }else if ([self.titleString isEqualToString:@"修改快捷回复"]){
            _contentTextView.text = self.replyDict[@"content"];
            _contentString = self.replyDict[@"content"];
        }
    }
    return _contentTextView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _contentString = textView.text;
}

#pragma mark - event

- (void)doneClick{
    if ([self.titleString isEqualToString:@"自我介绍"]) {
        [YKHUDHelper showHUDInView:self.view];
        [[YKApiService service] updateDoctorSelfIntroduceWithContent:_contentString completion:^(id responseObject, NSError *error) {
            if (!error) {
                [YKHUDHelper hideHUDInView:self.view];
                _doctor.selfInfo = _contentString;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [YKHUDHelper hideHUDInView:self.view];
                [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            }
        }];
    }else if ([self.titleString isEqualToString:@"诊所公告"]){
        [YKHUDHelper showHUDInView:self.view];
        [[YKApiService service] updateClinicNoticeWithContent:_contentString completion:^(id responseObject, NSError *error) {
            if (!error) {
                [YKHUDHelper hideHUDInView:self.view];
                _doctor.sign = _contentString;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [YKHUDHelper hideHUDInView:self.view];
                [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            }
        }];
    }else if ([self.titleString isEqualToString:@"添加快捷回复"]){
        if ((_contentString == NULL) || [_contentString empty]) {
            [YKAlertHelper showErrorMessage:@"请输入回复内容" inView:self.view];
            return;
        }
        [YKHUDHelper showHUDInView:self.view];
        [[YKApiService service] addQuickReplyWithContent:_contentString completion:^(id responseObject, NSError *error) {
            if (!error) {
                [YKHUDHelper hideHUDInView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [YKHUDHelper hideHUDInView:self.view];
                [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            }
        }];
    }else if ([self.titleString isEqualToString:@"修改快捷回复"]){
        if ((_contentString == NULL) || [_contentString empty]) {
            [YKAlertHelper showErrorMessage:@"请输入回复内容" inView:self.view];
            return;
        }
        [YKHUDHelper showHUDInView:self.view];
        
        [[YKApiService service] updateQuickReplyWithReplyID:self.replyDict[@"id"] content:_contentString completion:^(id responseObject, NSError *error) {
            if (!error) {
                [YKHUDHelper hideHUDInView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [YKHUDHelper hideHUDInView:self.view];
                [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            }
        }];
    }
}

@end
