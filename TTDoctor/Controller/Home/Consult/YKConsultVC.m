//
//  YKConsultVC.m
//  TTDoctor
//
//  Created by mac on 2022/5/19.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKConsultVC.h"
#import "PopoverView.h"
#import "YKReceiveConsultCell.h"

@interface YKConsultVC () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation YKConsultVC
{
    int _page;
    NSString *_orderParam;
    NSString *_patientName;

    
    int _currentIndex;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会诊";
    self.view.backgroundColor = RGBACOLOR(241, 241, 241);
    _page = 0;
    _patientName = @"";
    _orderParam = @"createDate";
    _currentIndex = 0;

    [self createRightButtonItems];
    [self layoutAllSubviews];
}

- (void)createRightButtonItems {
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addConsult)];
    self.navigationItem.rightBarButtonItem = addItem;
}

//添加控件
- (void)layoutAllSubviews{

    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
    }];
}

#pragma mark - netWork


-(void)startRefresh
{
    if (_currentIndex == 0) {
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            _page = 0;
            [self getMyReceiveConsult];
        }else{
            _page ++;
            [self getMyReceiveConsult];
        }
    }else{
        
    }

   
}

- (void)getMyReceiveConsult{
    NSString *startPage = [NSString stringWithFormat:@"%d", _page * 10];

    [YKHUDHelper showHUDInView:self.view];

    [[YKBaseApiSeivice service] getMyReceiveConsultWithPatientName:_patientName start:startPage orderParam:_orderParam completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            [self doThisDataWithResponseObj:responseObject];
        }else{
            
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            
        }
    }];
}

- (void)doThisDataWithResponseObj:(id)responseObject {
    NSMutableArray *tempArray = [@[] mutableCopy];
    for (NSDictionary *dic in responseObject[@"rows"]) {
        [tempArray addObject:dic];
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

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *receiveButton = [UIButton new];
        [receiveButton setTitle:@"我收到的会诊" forState:UIControlStateNormal];
        [receiveButton setTitleColor:RGBACOLOR(21, 21, 21) forState:UIControlStateNormal];
        receiveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        receiveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_headerView addSubview:receiveButton];
        
        [receiveButton addTarget:self action:@selector(receiveClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBACOLOR(182, 182, 182);
        [_headerView addSubview:lineView];

        
        UIButton *applyButton = [UIButton new];
        [applyButton setTitle:@"我申请的会诊" forState:UIControlStateNormal];
        [applyButton setTitleColor:RGBACOLOR(21, 21, 21) forState:UIControlStateNormal];
        applyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_headerView addSubview:applyButton];
        
        [applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];

        
        [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(_headerView);
            make.right.mas_equalTo(_headerView.mas_centerX);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView).offset(6);
            make.bottom.mas_equalTo(_headerView).offset(-6);
            make.centerX.mas_equalTo(_headerView);
            make.width.mas_equalTo(1);
        }];
        
        [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(_headerView);
            make.left.mas_equalTo(_headerView.mas_centerX);
        }];
        
        
        self.indicateView = [[UIView alloc] initWithFrame:CGRectMake((KWIDTH / 2 - 110) / 2, 39, 110, 1)];
        self.indicateView.backgroundColor = COMMONCOLOR;
        [_headerView addSubview:self.indicateView];
    }
    return _headerView;
}


- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = [UIColor whiteColor];

        self.searchTextField = [UITextField new];
        self.searchTextField.layer.cornerRadius = 20;
        self.searchTextField.layer.borderWidth = 1;
        self.searchTextField.layer.borderColor = RGBACOLOR(241, 241, 241).CGColor;
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入患者名字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153)}];
        self.searchTextField.font = [UIFont systemFontOfSize:13];
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.delegate = self;
        UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 40)];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 16, 16)];
        leftImageView.image = [UIImage imageNamed:@"随访_搜索"];
        [leftView addSubview:leftImageView];
        self.searchTextField.leftView=leftView;
        self.searchTextField.leftViewMode=UITextFieldViewModeAlways;
        [self.searchTextField addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
        [_searchView addSubview:self.searchTextField];
        
        UIButton *sortButton = [UIButton new];
        [sortButton setTitle:@"排序" forState:UIControlStateNormal];
        sortButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [sortButton setTitleColor:RGBACOLOR(51, 51, 51) forState:UIControlStateNormal];
        [sortButton addTarget:self action:@selector(sortClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:sortButton];
        
        UIButton *selectButton = [UIButton new];
        [selectButton setImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(sortClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:selectButton];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBACOLOR(231, 231, 231);
        [_searchView addSubview:lineView];

        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView).offset(82);
            make.right.mas_equalTo(_searchView).offset(-15);
            make.centerY.mas_equalTo(_searchView);
            make.height.mas_equalTo(36);
        }];
        
        [sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView).offset(15);
            make.centerY.mas_equalTo(_searchView);
        }];
        
        [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchView);
            make.left.mas_equalTo(sortButton.mas_right).offset(5.5);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_searchView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [self createRefreshWithTableView:_tableView];

        
    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentIndex == 0) {
        return 90;
    }
    
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    if (_currentIndex == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        YKReceiveConsultCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[YKReceiveConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@岁 %@", dict[@"sex"], dict[@"age"], dict[@"goodEntityName"]];
        cell.doctorLabel.text = [NSString stringWithFormat:@"申请医生:%@ | %@", dict[@"applyName"], dict[@"applyCellphone"]];
        cell.dateLabel.text = [NSString stringWithFormat:@"预约会诊时间:%@", dict[@"appointDateStr"]];
    //    cell.stateButton.tag = indexPath.row;
    //    [cell.stateButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell setStateImageWithState:patient.inviteStatus];

        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"搜索");
    return YES;;
}

#pragma mark - Event

- (void)addConsult{
    NSLog(@"添加");
}


- (void)receiveClick{
    self.indicateView.frame = CGRectMake((KWIDTH / 2 - 110) / 2, 39, 110, 1);
    
}

- (void)applyClick{
    self.indicateView.frame = CGRectMake(KWIDTH / 2 + (KWIDTH / 2 - 110) / 2, 39, 110, 1);

}

- (void)sortClick{
    CGPoint point = CGPointMake(30, navBarHeight + 90);
    NSArray *titles = @[@"按时间", @"按姓名"];
    PopoverView * pop = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.bgColor = [UIColor whiteColor];
    pop.selectRowAtIndex = ^(NSInteger index){
        _page = 0;
        if (index == 0) {
            _orderParam = @"createDate";
        }else{
            _orderParam = @"patientName";
        }
    };
    [pop show];
}

- (void)onTextChange:(UITextField *)textfield{
    _patientName = textfield.text;
    NSLog(@"%@",_patientName);
}


@end
