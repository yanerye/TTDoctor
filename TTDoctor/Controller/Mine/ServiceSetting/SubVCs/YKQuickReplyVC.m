//
//  YKQuickReplyVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/24.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKQuickReplyVC.h"
#import "YKSelfInfoVC.h"

@interface YKQuickReplyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *defaultImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKQuickReplyVC


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置快捷回复";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}


- (void)layoutAllSubviews{
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.defaultImageView];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-2);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addButton.mas_top);
        make.left.right.mas_equalTo(self.view);
    }];
    
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

-(void)getData
{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKApiService service] getQuickReplyListCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            [self.dataArray removeAllObjects];
            NSArray *tempArray = responseObject[@"rows"];
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

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton new];
        [_addButton setImage:[UIImage imageNamed:@"快捷回复_添加"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
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

- (UIImageView *)defaultImageView{
    if (!_defaultImageView) {
        _defaultImageView = [UIImageView new];
        _defaultImageView.image = [UIImage imageNamed:@"病例登记_默认"];
        _defaultImageView.hidden = YES;
    }
    return _defaultImageView;;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSDictionary *dict = self.dataArray[indexPath.row];
            [[YKApiService service] deleteQuickReplyWithReplyID:dict[@"id"] completion:^(id responseObject, NSError *error) {
                if (!error) {
                    [self getData];
                }else{
                    [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
                }
            }];
        }];
        layTopRowAction1.backgroundColor = [UIColor redColor];
        NSArray *arr = @[layTopRowAction1];
        return arr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    YKSelfInfoVC *vc = [[YKSelfInfoVC alloc] init];
    vc.titleString = @"修改快捷回复";
    vc.replyDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Event

- (void)addClick{
    YKSelfInfoVC *vc = [[YKSelfInfoVC alloc] init];
    vc.titleString = @"添加快捷回复";
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
