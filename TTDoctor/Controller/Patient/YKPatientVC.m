//
//  YKPatientVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/11.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKPatientVC.h"
#import "BFCButton.h"
#import "YKPatientCell.h"
#import "PopoverView.h"
#import "YKQRCodeVC.h"
#import "YKAddPatientVC.h"
#import "YKPatientDetailVC.h"
#import "YKManageTagVC.h"

//#import "XJPatientDetial3Controller.h"
//#import "XJSettingTagController.h"
//#import "XJQRController.h"
//#import "XJAddPatientControllerV24.h"
//#import "XJSearchControllerV24.h"
//#import "XJSendMessageControllerV24.h"
//#import "XJFiltrateModel.h"
//#import "XJPatientDataManager.h"


@interface YKPatientVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UILabel *filtrateLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKPatientVC
{
    int _page;
    NSString *_patientName;
    NSString *_tagIDs;
    NSString *_tagNames;
    NSString *_primarySymptom;
    NSString *_beginAge;
    NSString *_endAge;
    NSString *_sex;
    NSString *_orderParam;
    NSString *_projectId;
    NSString *_projectName;
    
    NSString *_filtrateStr;//搜索条件str
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"患者";
    self.view.backgroundColor = RGBACOLOR(245, 245, 245);
    [self resetParameters];
    [self createRightButtonItems];
    [self layoutAllSubviews];
    //过滤通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filtrate:) name:@"Filtrate" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                             NSFontAttributeName : [UIFont systemFontOfSize:19]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}



- (void)layoutAllSubviews{

    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];

    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(108);
    }];

    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark -高级搜索通知

- (void)filtrate:(NSNotification *)notifi{

    self.searchTextField.hidden = YES;
    self.cancelButton.hidden = NO;
    self.filtrateLabel.hidden = NO;

//    NSLog(@"%@",[notifi valueForKey:@"userInfo"]);
//    tempModel = [[notifi valueForKey:@"userInfo"] valueForKey:@"filtrateModel"];//filtrateStr
//    NSString *tempStr = [[notifi valueForKey:@"userInfo"] valueForKey:@"filtrateStr"];
//    [XJPatientDataManager shareXJPatientManager].filModel = tempModel;
//    _filtrateStr = [NSString stringWithString:tempStr];
//    self.filtrateLabel.text = _filtrateStr;
//    _page = 0;
//    _patientName = [self strOrNull:tempModel.patientName];
//    _tagIDs = [self strOrNull:tempModel.tagIds];
//    _tagNames = [self strOrNull:tempModel.tagNames];
//    _primarySymptom = [self strOrNull:tempModel.primarySymptom];
//    _beginAge = [self strOrNull:tempModel.beginAge];
//    _endAge = [self strOrNull:tempModel.endAge];
//    _sex = [self strOrNull:tempModel.sex];
//    _projectId = [self strOrNull:tempModel.projectId];
    [self getData];
}

- (NSString *)strOrNull:(NSString *)str {
    return str.length > 0 ? str : @"";
}

#pragma mark - 标签管理

- (void)createRightButtonItems {
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    image2.image = [UIImage imageNamed:@"患者_标签"];

    image2.userInteractionEnabled = YES;
    [image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick)]];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:image2];
    self.navigationItem.rightBarButtonItem = right2;
}

#pragma mark - 重置数据

- (void)resetParameters{
    _page = 0;
    _patientName = @"";
    _tagIDs = @"";
    _tagNames = @"";
    _primarySymptom = @"";
    _beginAge = @"";
    _endAge = @"";
    _sex = @"";
    _orderParam = @"createDate";//patientName按照姓名排序，createDate按加入时间
    _projectId = @"";
    _projectName = @"";
}

#pragma mark - Network

-(void)startRefresh
{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        _page = 0;
        [self getData];
    }else{
        _page ++;
        [self getData];
    }
   
}

//请求患者列表
- (void)getData{
    NSString *pageStr = [NSString stringWithFormat:@"%d", _page];
    NSString *startPage = [NSString stringWithFormat:@"%d", _page *10];

    [[YKBaseApiSeivice service] getPatientListWithPatientName:_patientName page:pageStr startpage:startPage tagIds:_tagIDs primarySymptom:_primarySymptom beginAge:_beginAge endAge:_endAge sex:_sex orderParam:_orderParam projectId:_projectId completion:^(id responseObject, NSError *error) {
        if (!error) {
            [self doThisDataWithResponseObj:responseObject];
        }else{
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

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [UIView new];
        _buttonView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < 4; i ++) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 4 * i, 0, KWIDTH / 4, 108)];
            [_buttonView addSubview:tempView];
         
            BFCButton *collectBtn = [BFCButton buttonWithType:UIButtonTypeCustom];
            collectBtn.tag = i;
            [collectBtn addTarget:self action:@selector(onButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
            collectBtn.alignType = BFCButtonAlignTypeTextBottom;
            if (i == 0) {
                [collectBtn setImage:[UIImage imageNamed:@"患者_扫描添加"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"扫描添加" forState:UIControlStateNormal];
            }else if (i == 1){
                [collectBtn setImage:[UIImage imageNamed:@"患者_手动添加"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"手动添加" forState:UIControlStateNormal];
            }else if (i == 2){
                [collectBtn setImage:[UIImage imageNamed:@"患者_高级搜索"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"高级搜索" forState:UIControlStateNormal];
            }else if (i == 3){
                [collectBtn setImage:[UIImage imageNamed:@"患者_群发消息"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"群发消息" forState:UIControlStateNormal];
            }
            collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [collectBtn setTitleColor:RGBACOLOR(102, 102, 102) forState:UIControlStateNormal];
            [tempView addSubview:collectBtn];
            [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(tempView);
                make.centerX.mas_equalTo(tempView);
                make.height.mas_equalTo(75);
            }];
        }
        
    }
    return _buttonView;
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
        
        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView).offset(82);
            make.right.mas_equalTo(_searchView).offset(-15);
            make.centerY.mas_equalTo(_searchView);
            make.height.mas_equalTo(40);
        }];
        
        [sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView).offset(15);
            make.centerY.mas_equalTo(_searchView);
        }];
        
        [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchView);
            make.left.mas_equalTo(sortButton.mas_right).offset(5.5);
        }];
        
        self.cancelButton = [UIButton new];
        self.cancelButton.hidden = YES;
        self.cancelButton.layer.cornerRadius = 5;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.cancelButton.backgroundColor = RGBACOLOR(242, 242, 246);
        [self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:self.cancelButton];
        
        self.filtrateLabel = [UILabel new];
        self.filtrateLabel.hidden = YES;
        self.filtrateLabel.textAlignment = NSTextAlignmentCenter;
        self.filtrateLabel.textColor = [UIColor colorWithRed:0/255.0 green:221/255.0 blue:191/255.0 alpha:1.0];
        self.filtrateLabel.font = [UIFont systemFontOfSize:14];
        [_searchView addSubview:self.filtrateLabel];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchView);
            make.right.mas_equalTo(_searchView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(50, 28));
        }];
        [self.filtrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchView);
            make.left.mas_equalTo(selectButton.mas_right).offset(10);
            make.right.mas_equalTo(self.cancelButton.mas_left).offset(-10);
        }];

    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [self createRefreshWithTableView:_tableView];

        
    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKPatientCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *picStr = [NSString stringWithFormat:@"%@",dict[@"localPic"]];
    if (picStr.length > 0) {
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"随访_默认头像"]];
    } else {
        cell.leftImageView.image = [UIImage imageNamed:@"随访_默认头像"];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
    cell.phoneLabel.text = [NSString stringWithFormat:@"%@",dict[@"cellphone"]];
    cell.tagesLabel.text = [NSString stringWithFormat:@"%@",dict[@"tags"]];

    if ([dict[@"cellphone"] length] == 0) {
        cell.phoneImageView.hidden = YES;
    } else {
        cell.phoneImageView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    YKPatientDetailVC *detailVC = [[YKPatientDetailVC alloc] init];
    detailVC.patientId = [NSString stringWithFormat:@"%@",dict[@"patientId"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < 10) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
    }

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _page = 0;
    [self getData];
    return YES;;
}


#pragma mark - Event

- (void)onButtonsAction:(UIButton *)sender{
    if (sender.tag == 0) {
        YKQRCodeVC *codeVC = [[YKQRCodeVC alloc] init];
        codeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:codeVC animated:YES];
    }else if ( sender.tag == 1){
        YKAddPatientVC *addVC = [[YKAddPatientVC alloc] init];
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
    }else if (sender.tag == 2){

    }else if (sender.tag == 3){
        
    }
}

- (void)sortClick{
    CGPoint point = CGPointMake(30, navBarHeight + 160);
    NSArray *titles = @[@"按时间", @"按姓名"];
    PopoverView * pop = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.bgColor = [UIColor whiteColor];
    pop.selectRowAtIndex = ^(NSInteger index){
        _page = 0;
        if (index == 0) {
            _orderParam = @"createDate";
            [self getData];
        }else{
            _orderParam = @"patientName";
            [self getData];
        }
    };
    [pop show];
}

- (void)tagClick{
    YKManageTagVC *tagVC = [[YKManageTagVC alloc] init];
    tagVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tagVC animated:YES];
}

- (void)onTextChange:(UITextField *)textfield{
    _patientName = textfield.text;
}

- (void)cancelClick{
//    [XJPatientDataManager shareXJPatientManager].filModel = nil;
    _filtrateStr = @"";
    self.filtrateLabel.text = @"";
    self.filtrateLabel.hidden = YES;
    self.cancelButton.hidden = YES;
    [self resetParameters];
    self.searchTextField.hidden = NO;
    [self getData];
}

@end
