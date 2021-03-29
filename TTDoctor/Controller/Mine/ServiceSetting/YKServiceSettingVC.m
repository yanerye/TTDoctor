//
//  YKServiceSettingVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKServiceSettingVC.h"
#import "YKServiceSettingCell.h"
#import "YKSelfInfoVC.h"
#import "YKMainSymptomVC.h"
#import "YKQuickReplyVC.h"

@interface YKServiceSettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation YKServiceSettingVC
{
    YKDoctor *_doctor;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"服务设置_自我介绍",@"服务设置_擅长病种",@"服务设置_诊所公告",@"服务设置_出诊时间",@"服务设置_快捷回复"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"自我介绍",@"擅长病种",@"诊所公告",@"设置出诊时间和地点",@"设置快捷回复"];
    }
    return _titleArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _doctor = [YKDoctorHelper shareDoctor];
    [self.tableView reloadData];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        return 60;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKServiceSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKServiceSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < 3) {
        cell.titleLabel.hidden = NO;
        cell.detailLabel.hidden = NO;
        cell.settingLabel.hidden = YES;

    }else{
        cell.titleLabel.hidden = YES;
        cell.detailLabel.hidden = YES;
        cell.settingLabel.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        cell.detailLabel.text = _doctor.selfInfo;
    }else if (indexPath.row == 1){
        cell.detailLabel.text = _doctor.docEntityName;
    }else if (indexPath.row == 2){
        cell.detailLabel.text = _doctor.sign;
    }
    
    cell.leftImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.settingLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        YKSelfInfoVC *vc = [[YKSelfInfoVC alloc] init];
        vc.titleString = @"自我介绍";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        YKMainSymptomVC *vc = [[YKMainSymptomVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        YKSelfInfoVC *vc = [[YKSelfInfoVC alloc] init];
        vc.titleString = @"诊所公告";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){

    }else if (indexPath.row == 4){
        YKQuickReplyVC *vc = [[YKQuickReplyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

@end
