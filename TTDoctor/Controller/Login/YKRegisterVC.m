//
//  YKRegisterVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/9.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKRegisterVC.h"
#import "YKLoginCell.h"

@interface YKRegisterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;

@end

@implementation YKRegisterVC


- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"姓名",@"手机号",@"图形码",@"验证码",@"医院",@"科室",@"病区",@"职称",@"密码",@"邮箱",@"微信号"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请输入姓名",@"请输入手机号",@"请输入图形码",@"请输入验证码",@"请输入所在医院",@"请选择医院所在科室",@"请选择病区",@"请输入您的职称",@"请输入密码",@"请输入邮箱",@"请输入微信号"];
    }
    return _placeholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutAllSubviews];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];

}

#pragma mark - init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.leftImageView.hidden = YES;
    if (indexPath.row == 2) {
        cell.graphicCodeImageView.hidden = NO;
    }else{
        cell.graphicCodeImageView.hidden = YES;
    }
    
    if (indexPath.row == 3) {
        cell.codeButton.hidden = NO;
    }else{
        cell.codeButton.hidden = YES;
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentTextField.placeholder = self.placeholderArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - event


@end
