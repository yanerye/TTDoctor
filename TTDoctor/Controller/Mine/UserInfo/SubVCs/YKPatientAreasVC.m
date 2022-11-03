//
//  YKPatientAreasVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKPatientAreasVC.h"

@interface YKPatientAreasVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *defaultImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKPatientAreasVC


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"病区";
    self.view.backgroundColor = RGBACOLOR(245, 245, 245);
    [self layoutAllSubviews];
    [self getData];
}


- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.defaultImageView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

-(void)getData
{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getPatientAreaListCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = RGBACOLOR(245, 245, 245);

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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *areaDic = [NSDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
    if (_areaBlock) {
        _areaBlock(areaDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
   
}

@end
