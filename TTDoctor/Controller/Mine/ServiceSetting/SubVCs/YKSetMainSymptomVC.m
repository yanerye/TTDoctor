//
//  YKSetMainSymptomVC.m
//  TTDoctor
//
//  Created by YK on 2021/10/21.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKSetMainSymptomVC.h"
#import "YKMainSymptomCell.h"

#define TABLE_HEADER_HEIGHT  40

@interface YKSetMainSymptomVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKSetMainSymptomVC
{
    YKDoctor *_doctor;
    NSString *_deptName;
    NSString *_docEntityName;
    NSArray *_docEntityArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置主症";
    self.view.backgroundColor = [UIColor whiteColor];
    _doctor = [YKDoctorHelper shareDoctor];
    _deptName = _doctor.deptName;
    _docEntityName = _doctor.docEntityName;
    _docEntityArray = [_docEntityName componentsSeparatedByString:@","];
    
    [self layoutAllSubviews];
    [self createRightButtonItems];
    [self getData];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
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

- (void)getData{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getDiseasesTypeListCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            NSArray *tempArray =responseObject[@"entityTags"];
            for (NSDictionary *dict in tempArray) {
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [tempDict setValue:@"0" forKey:@"isSelected"];
                if ([_deptName isEqualToString:dict[@"paramName"]]) {
                    [self.dataArray addObject:tempDict];
                }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
    
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, TABLE_HEADER_HEIGHT)];
    headerView.backgroundColor = RGBACOLOR(228, 228, 228);
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, TABLE_HEADER_HEIGHT)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = RGBACOLOR(66, 66, 66);
    [nameLabel setFont:[UIFont boldSystemFontOfSize:18]];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = _deptName;
    [headerView addSubview:nameLabel];
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKMainSymptomCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKMainSymptomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    for (int i = 0; i < _docEntityArray.count; i ++) {
        if ([dict[@"name"] isEqualToString:_docEntityArray[i]]) {
            [dict setValue:@"1" forKey:@"isSelected"];
        }
    }
    
    if ([dict[@"isSelected"] isEqualToString:@"1"]) {
        cell.selectImageView.image = [UIImage imageNamed:@"服务设置_选中"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"服务设置_未选"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YKMainSymptomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([dict[@"isSelected"] isEqualToString:@"1"]) {
        cell.selectImageView.image = [UIImage imageNamed:@"服务设置_未选"];
        [dict setValue:@"0" forKey:@"isSelected"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"服务设置_选中"];
        [dict setValue:@"1" forKey:@"isSelected"];
    }
}

#pragma mark - event

- (void)doneClick{
    NSMutableArray *goodsIDArray = [NSMutableArray array];
    NSMutableArray *goodsNameArray = [NSMutableArray array];

    for (NSDictionary *dict in self.dataArray) {
        if ([dict[@"isSelected"] isEqualToString:@"1"]) {
            [goodsIDArray addObject:dict[@"id"]];
            [goodsNameArray addObject:dict[@"name"]];
        }
    }
    
    NSString *goodsIDString = [goodsIDArray componentsJoinedByString:@","];
    NSString *goodsNameString = [goodsNameArray componentsJoinedByString:@","];
    
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] saveskilledDiseasesWithGoodsIDs:goodsIDString completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            _doctor.docEntityName = goodsNameString;
            [YKDoctorHelper updateDoctorWithDoctor:_doctor];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}


@end
