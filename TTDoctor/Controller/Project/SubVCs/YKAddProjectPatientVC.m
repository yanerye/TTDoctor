//
//  YKAddProjectPatientVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/29.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAddProjectPatientVC.h"
#import "YKAddProjectPatientCell.h"


@interface YKAddProjectPatientVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) NSArray *infoTitleArray;
@property (nonatomic, strong) NSArray *infoPlaceholderArray;

@property (nonatomic, strong) NSArray *moreTitleArray;
@property (nonatomic, strong) NSArray *morePlaceholderArray;

@end

@implementation YKAddProjectPatientVC
{
    BOOL _isShowMore;
}

- (NSArray *)infoTitleArray{
    if (!_infoTitleArray) {
        _infoTitleArray = @[@"患者姓名",@"手机号",@"电话号",@"性别",@"出生年月",@"年龄",@"基线时间",@"患者编码",@"队列",@"病例随机号",@"姓名缩写",@"实验药物编号"];
    }
    return _infoTitleArray;
}

- (NSArray *)infoPlaceholderArray{
    if (!_infoPlaceholderArray) {
        _infoPlaceholderArray = @[@"请输入患者姓名",@"请输入手机号",@"请输入电话号",@"",@"",@"请输入年龄",@"",@"",@"",@"请输入病例随机号",@"请输入姓名缩写",@"请输入实验药物编号"];
    }
    return _infoPlaceholderArray;
}

- (NSArray *)moreTitleArray{
    if (!_moreTitleArray) {
        _moreTitleArray = @[@"第二部分1",@"第二部分2",@"第二部分3",@"第二部分4",@"第二部分5",@"第二部分6",@"第二部分7",@"第二部分8",@"第二部分9",@"第二部分10",@"第二部分11",@"第二部分12",@"第二部分13",@"第二部分14",@"第二部分15",@"第二部分16"];
    }
    return _moreTitleArray;
}

- (NSArray *)morePlaceholderArray{
    if (!_morePlaceholderArray) {
        _morePlaceholderArray = @[@"第二默认1",@"第二默认2",@"第二默认3",@"第二默认4",@"第二默认5",@"第二默认6",@"第二默认7",@"第二默认8",@"第二默认9",@"第二默认10",@"第二默认11",@"第二默认12",@"第二默认13",@"第二默认14",@"第二默认15",@"第二默认16"];
    }
    return _morePlaceholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加患者";
    [self layoutAllSubviews];
    _isShowMore = NO;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tag = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }
    
    if (_isShowMore) {
        return 16;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKAddProjectPatientCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKAddProjectPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {

        if (indexPath.row == 3) {

            cell.contentTextField.hidden = YES;
        }else{

            cell.contentTextField.hidden = NO;
        }
                
        if (indexPath.row == 0) {
            cell.addressBookButton.hidden = NO;
        }else{
            cell.addressBookButton.hidden = YES;
        }
        cell.titleLabel.text = self.infoTitleArray[indexPath.row];
        cell.contentTextField.placeholder = self.infoPlaceholderArray[indexPath.row];

        return cell;
    }
    
    cell.addressBookButton.hidden = YES;
    
    cell.titleLabel.text = self.moreTitleArray[indexPath.row];
    cell.contentTextField.placeholder = self.morePlaceholderArray[indexPath.row];

    return cell;

}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50)];
    moreView.backgroundColor = RGBACOLOR(237, 237, 237);
    
    UIButton *moreButton = [UIButton new];
    [moreButton setTitle:@"填写更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:RGBACOLOR(70, 150, 212) forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:moreButton];
    
    self.upButton = [UIButton new];
    if (_isShowMore) {
        [self.upButton setImage:[UIImage imageNamed:@"项目_向上"] forState:UIControlStateNormal];
    }else{
        [self.upButton setImage:[UIImage imageNamed:@"项目_向下"] forState:UIControlStateNormal];
    }
    [self.upButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:self.upButton];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(moreView);
        make.centerX.mas_equalTo(moreView).offset(-20);
    }];
    
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(moreButton);
        make.left.mas_equalTo(moreButton.mas_right).offset(5);
    }];
    
    return moreView;
}


#pragma mark - Event

- (void)moreClick{
    if (_isShowMore) {
        _isShowMore = NO;
    }else{
        _isShowMore = YES;
        self.tableView.contentOffset = CGPointMake(0, 405);
    }
    
    [self.tableView reloadData];
    
}



@end
