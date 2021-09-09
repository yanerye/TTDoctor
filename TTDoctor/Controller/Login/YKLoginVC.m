//
//  YKLoginVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKLoginVC.h"
#import "YKForgetVC.h"
#import "YKLoginCell.h"
#import "YKRegisterVC.h"
#import "YKDoctor.h"
#import "YKTabBarVC.h"

#define textFont 14
#define buttonFont 15
#define buttonRadius 5

@interface YKLoginVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;

@end

@implementation YKLoginVC
{
    NSString *_phoneString;
    NSString *_passwordString;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"登录_手机",@"登录_密码"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"手机号码",@"密码"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请输入手机号",@"请输入密码"];
    }
    return _placeholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = RGBACOLOR(239, 239, 241);
    [self layoutAllSubviews];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.loginButton];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(13);
        make.left.mas_equalTo(self.tableView);
    }];
   
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(56);
        make.left.mas_equalTo(self.tableView);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_centerX).offset(-12);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerButton);
        make.right.mas_equalTo(self.tableView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_centerX).offset(12);
    }];
}

#pragma mark - init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.borderColor = RGBACOLOR(145, 145, 145).CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.cornerRadius = 8;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton new];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:textFont];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:RGBACOLOR(113, 113, 113) forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton new];
        _registerButton.backgroundColor = COMMONCOLOR;
        _registerButton.layer.cornerRadius = buttonRadius;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.backgroundColor = COMMONCOLOR;
        _loginButton.layer.cornerRadius = buttonRadius;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.graphicCodeImageView.hidden = YES;
    cell.codeButton.hidden = YES;
    cell.leftImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentTextField.placeholder = self.placeholderArray[indexPath.row];
    cell.contentTextField.tag = indexPath.row;
    [cell.contentTextField addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - event

- (void)onTextChange:(UITextField *)textfield{
    if (textfield.tag == 0) {
        _phoneString = textfield.text;
    }else if (textfield.tag == 1){
        _passwordString = textfield.text;
    }
}

- (void)forgetClick{
    YKForgetVC *forgetVC = [[YKForgetVC alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)registerClick{
    YKRegisterVC *registerVC = [[YKRegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginClick{
    if ((_phoneString == NULL) || [_phoneString empty]) {
        [YKAlertHelper showErrorMessage:@"请输入手机号" inView:self.view];
        return;
    }else if (![_phoneString isTelephone]){
        [YKAlertHelper showErrorMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }else if ((_passwordString == NULL) || [_passwordString empty]){
        [YKAlertHelper showErrorMessage:@"请输入密码" inView:self.view];
        return;
    }
    
    [YKHUDHelper showHUDInView:self.view];
    
    //保存token
    NSString *accessPath = [NSString stringWithFormat:@"%@/app/auth/v2.0/login",TOKEN_SERVER];
    NSDictionary *params = @{@"client":@"2",@"mobile":_phoneString,@"password":_passwordString};
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:accessPath parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *tempDict = responseObject[@"data"];
        if (!error) {
            if ([tempDict isKindOfClass:[NSNull class]] || [tempDict isEqual:[NSNull null]]) {
                
            }else{
                //保存token
                NSString *accessToken = tempDict[@"accessToken"];
                [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"accessToken"];
//                //保存别名
//                NSString *alias = tempDict[@"alias"];
//                [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"alias"];

//                [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//                } seq:0];
            }
        } else {
            
        }
                    
    }];
    [task resume];
    
    [[YKApiService service] loginWithTelephone:_phoneString passwprd:_passwordString completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            NSDictionary *dict = responseObject[@"doctor"];
            [YKDoctorHelper saveShareDoctorForNet:dict];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:_phoneString forKey:@"phoneNumber"];
            [userDefaults setValue:_passwordString forKey:@"passWord"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                YKTabBarVC *tabBarVC = [[YKTabBarVC alloc] init];
                UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
                keyWindow.rootViewController = tabBarVC;
            });
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}

@end
