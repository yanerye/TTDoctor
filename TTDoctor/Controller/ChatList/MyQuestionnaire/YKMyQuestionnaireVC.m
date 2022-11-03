//
//  YKMyQuestionnaireVC.m
//  TTDoctor
//
//  Created by YK on 2020/7/21.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKMyQuestionnaireVC.h"
#import "YKMyQuestionnaireCell.h"
#import "YKWebVC.h"

@interface YKMyQuestionnaireVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *selectArray;

@end

@implementation YKMyQuestionnaireVC
{
    int _page;
    NSString * _questionnaireName;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的问卷";
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 0;
    _questionnaireName = @"";
    [self createRightButtonItems];
    [self layoutAllSubviews];
    
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

- (void)createRightButtonItems {
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [doneButton setTitle:@"发送" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = right2;
}

-(void)startRefresh
{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        _page = 0;
        [self getdata];
    }else{
        _page ++;
        [self getdata];
    }
}

- (void)getdata{
    NSString *pageStr = [NSString stringWithFormat:@"%d",_page * 10];
    
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getMyQuestionnaireWithQuestionnaireName:_questionnaireName startPage:pageStr completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            [self doThisDataWithResponseObj:responseObject];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
    

}

- (void)doThisDataWithResponseObj:(id)responseObject{
    NSMutableArray *tempArray = [@[] mutableCopy];
    for (NSDictionary *dict in responseObject[@"rows"]) {
        NSMutableDictionary *tempDict = [dict mutableCopy];
        [tempDict setValue:@"0" forKey:@"isSelected"];
        [tempArray addObject:tempDict];
        
    }
    
    if (_page == 0) {
        //删除原有数据 对数据源重新追加数据
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:tempArray];
        //刷新表格
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }else{
        //对现有数据源进行追加数据
        [self.dataArray addObjectsFromArray:tempArray];
        //刷新表格
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - init

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [UITextField new];
        _searchTextField.layer.cornerRadius = 20;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.layer.borderColor = RGBACOLOR(241, 241, 241).CGColor;
        
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入查询问卷" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153)}];
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
        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];

        [self createRefreshWithTableView:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKMyQuestionnaireCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKMyQuestionnaireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *dict = self.dataArray[indexPath.row];
    cell.questionnaireDict = dict;
    [cell.seleceButton setImage:[UIImage imageNamed:@"服务设置_未选"] forState:UIControlStateNormal];
    [cell.seleceButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    YKWebVC *webVC = [[YKWebVC alloc] init];
    webVC.titleString = @"问卷详情";
    webVC.urlString = [NSString stringWithFormat:@"%@",dict[@"specialUrl"]];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UItextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _page = 0;
    [self getdata];
    return YES;;
}



#pragma mark - Event

- (void)doneClick{
    if (self.selectArray.count == 0) {
        [YKAlertHelper showErrorMessage:@"请选中问卷" inView:self.view];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendQuestionnaire" object:self.selectArray];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)onTextChange:(UITextField *)textfield{
    _questionnaireName = textfield.text;
}

- (void)selectClick:(UIButton *)sender{
    YKMyQuestionnaireCell * cell = (YKMyQuestionnaireCell *)[sender superview];
    
    if ([cell.questionnaireDict[@"isSelected"] isEqualToString:@"0"]) {
        [cell.seleceButton setImage:[UIImage imageNamed:@"服务设置_选中"] forState:UIControlStateNormal];
        [cell.questionnaireDict setValue:@"1" forKey:@"isSelected"];
        [self.selectArray addObject:cell.questionnaireDict];
    }else{
        [cell.seleceButton setImage:[UIImage imageNamed:@"服务设置_未选"] forState:UIControlStateNormal];
        [cell.questionnaireDict setValue:@"0" forKey:@"isSelected"];
        [self.selectArray removeObject:cell.questionnaireDict];
    }
        
}


@end
