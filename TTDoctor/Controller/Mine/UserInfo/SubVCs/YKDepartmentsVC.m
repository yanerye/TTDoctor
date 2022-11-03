//
//  YKDepartmentsVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKDepartmentsVC.h"

@interface YKDepartmentsVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKDepartmentsVC
{
    NSString *_departNameStr;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"科室";
    self.view.backgroundColor = [UIColor whiteColor];
    _departNameStr = @"";
    [self layoutAllSubviews];
    [self getData];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.tableView];

    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(5);
         make.left.mas_equalTo(self.view);
         make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
     }];
    

}

- (void)getData{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getDepartMentListWithDeptName:_departNameStr completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            [self.dataArray removeAllObjects];
            NSArray *tempArray = responseObject;
            for (NSDictionary *dict in tempArray) {
                [self.dataArray addObject:dict];
            }
            [self.tableView reloadData];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}

#pragma mark - init

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [UITextField new];
        _searchTextField.layer.cornerRadius = 20;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.layer.borderColor = RGBACOLOR(241, 241, 241).CGColor;
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入科室名字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153)}];
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;

        UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 40)];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 16, 16)];
        leftImageView.image = [UIImage imageNamed:@"随访_搜索"];
        [leftView addSubview:leftImageView];

        _searchTextField.leftView=leftView;
        _searchTextField.leftViewMode=UITextFieldViewModeAlways;

        [_searchTextField addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc]init];

    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"deptName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *departmentlDic = [NSDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
    if (_departmentBlock) {
        _departmentBlock(departmentlDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self getData];
    return YES;;
}

#pragma mark - Event

- (void)onTextChange:(UITextField *)textfield{
    _departNameStr = textfield.text;
}

@end
