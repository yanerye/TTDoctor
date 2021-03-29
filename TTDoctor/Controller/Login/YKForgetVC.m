//
//  YKForgetVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/9.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKForgetVC.h"
#import "YKLoginCell.h"

@interface YKForgetVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;

@end

@implementation YKForgetVC

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"登录_手机",@"登录_手机",@"登录_手机",@"登录_密码"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"手机号码",@"图形码",@"验证码",@"密码"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请输入您的手机号",@"输入图形码",@"输入验证码",@"输入新密码"];
    }
    return _placeholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
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
        make.height.mas_equalTo(200);
    }];
 
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(26);
        make.left.right.mas_equalTo(self.tableView);
        make.height.mas_equalTo(32);
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
        _doneButton.backgroundColor = COMMONCOLOR;
        _doneButton.layer.cornerRadius = 8;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 1) {
        cell.graphicCodeImageView.hidden = NO;
    }else{
        cell.graphicCodeImageView.hidden = YES;
    }
    
    if (indexPath.row == 2) {
        cell.codeButton.hidden = NO;
    }else{
        cell.codeButton.hidden = YES;
    }
    
    cell.leftImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentTextField.placeholder = self.placeholderArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



#pragma mark - event


- (void)doneClick{
    
}


@end
