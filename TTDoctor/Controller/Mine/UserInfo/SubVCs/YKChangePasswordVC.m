//
//  YKChangePasswordVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/19.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChangePasswordVC.h"
#import "YKLoginCell.h"


@interface YKChangePasswordVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;

@end

@implementation YKChangePasswordVC
{
    NSString *_oldPassword;
    NSString *_newPassword;

}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"原密码",@"新密码"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请输入旧密码",@"请输入新密码"];
    }
    return _placeholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换密码";
    self.view.backgroundColor = RGBACOLOR(239, 239, 241);
    [self layoutAllSubviews];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.doneButton];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(30);
        make.left.mas_equalTo(self.tableView);
        make.right.mas_equalTo(self.tableView);
        make.height.mas_equalTo(40);
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

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton new];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = COMMONCOLOR;
        _doneButton.layer.cornerRadius = 8;
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
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
        _oldPassword = textfield.text;
    }else if (textfield.tag == 1){
        _newPassword = textfield.text;
    }
}

- (void)doneClick{
    if ((_oldPassword == NULL) || [_oldPassword empty]) {
        [YKAlertHelper showErrorMessage:@"请输入旧密码" inView:self.view];
        return;
    }else if ((_newPassword == NULL) || [_newPassword empty]) {
        [YKAlertHelper showErrorMessage:@"请输入新密码" inView:self.view];
        return;
    }else if ([_oldPassword isEqualToString:_newPassword]) {
        [YKAlertHelper showErrorMessage:@"旧密码新密码一致" inView:self.view];
        return;
    }
    
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] updatePasswordWithOldPassword:_oldPassword newPassword:_newPassword completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:@"修改成功" inView:self.view];
            
            //存下登陆的新的密码
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:_newPassword forKey:@"passWord"];
            
            //延时返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
    
}

@end
