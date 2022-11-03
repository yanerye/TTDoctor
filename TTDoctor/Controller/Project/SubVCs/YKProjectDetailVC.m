//
//  YKProjectDetailVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/24.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKProjectDetailVC.h"
#import "BFCButton.h"
#import "PopoverView.h"
#import "YKProjectDetailCell.h"
#import "YKAddProjectPatientVC.h"

@interface YKProjectDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIView *buttonView;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YKProjectDetailVC
{
    int page;
    
    NSString *projectID;//项目ID
    NSString *patientName;//患者姓名
    NSString *groupNumber;//中心编号
    NSString *minAge;//最小年龄
    NSString *maxAge;//最大年龄
    NSString *sex;//性别
    NSString *address;//地址
    NSString *communityHospital;//录入单位
    NSString *doctorName;//录入医生
    NSString *typeName;//备注
    NSString *patientNumber;//患者编号
    NSString *caseRandom;//病例随机号
    NSString *nameAbc;//姓名缩写
    NSString *startDate;//入组开始时间
    NSString *endDate;//入组结束时间
    NSString *projectPlanMainId;//队列id
    NSString *orderParam;//排序方式
    NSString *status;//是否脱落 全部1 未脱落-1脱落0
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.projectDict[@"projectName"];
    self.view.backgroundColor = RGBACOLOR(243, 242, 246);
    [self layoutAllSubviews];
    [self resetParameters];
}


- (void)layoutAllSubviews{
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];

    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
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

-(void)startRefresh
{
   
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        page = 0;
        [self getData];
    }else{
        page ++;
        [self getData];
    }
   
}

- (void)getData{
    NSString *startPage = [NSString stringWithFormat:@"%d",page * 10];
    
    [[YKBaseApiSeivice service] getProjectDetailWithIsSpecialMember:self.isSpecialMember ProjectID:projectID startPage:startPage patientName:patientName groupNumber:groupNumber address:address communityHospital:communityHospital sex:sex minAge:minAge maxAge:maxAge doctorName:doctorName typeName:typeName patientNumber:patientNumber caseRandom:caseRandom nameAbc:nameAbc startDate:startDate endDate:endDate projectPlanMainId:projectPlanMainId orderParam:orderParam status:status completion:^(id responseObject, NSError *error) {
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
    
    if (page == 0) {
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

#pragma maek - init

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [UIView new];
        _buttonView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < 4; i ++) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 3 * i, 0, KWIDTH / 3, 100)];
            [_buttonView addSubview:tempView];

            BFCButton *collectBtn = [BFCButton buttonWithType:UIButtonTypeCustom];
            collectBtn.tag = i;
            [collectBtn addTarget:self action:@selector(onButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
            collectBtn.alignType = BFCButtonAlignTypeTextBottom;
            if (i == 0) {
                [collectBtn setImage:[UIImage imageNamed:@"项目_添加患者"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"添加患者" forState:UIControlStateNormal];
            }else if (i == 1){
                [collectBtn setImage:[UIImage imageNamed:@"项目_高级搜索"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"高级搜索" forState:UIControlStateNormal];
            }else if (i == 2){
                [collectBtn setImage:[UIImage imageNamed:@"项目_项目进度"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"项目进度" forState:UIControlStateNormal];
            }
            collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [collectBtn setTitleColor:RGBACOLOR(121, 121, 121) forState:UIControlStateNormal];
            [tempView addSubview:collectBtn];
            [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(tempView);
                make.centerX.mas_equalTo(tempView);
                make.height.mas_equalTo(80);
            }];
        }
    }
    return _buttonView;
}

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = [UIColor whiteColor];

        UITextField *searchTextField = [UITextField new];
        searchTextField.layer.cornerRadius = 20;
        searchTextField.layer.borderWidth = 1;
        searchTextField.layer.borderColor = RGBACOLOR(241, 241, 241).CGColor;
        searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入患者名字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153)}];
        searchTextField.font = [UIFont systemFontOfSize:13];
        searchTextField.returnKeyType = UIReturnKeySearch;
        searchTextField.delegate = self;
        UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 40)];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 16, 16)];
        leftImageView.image = [UIImage imageNamed:@"随访_搜索"];
        [leftView addSubview:leftImageView];
        searchTextField.leftView=leftView;
        searchTextField.leftViewMode=UITextFieldViewModeAlways;
        [searchTextField addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
        [_searchView addSubview:searchTextField];
        
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
        
        [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [self createRefreshWithTableView:_tableView];


    }
    return _tableView;
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKProjectDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *patient = _dataArray[indexPath.row];
    cell.nameLabel.text = patient[@"patientName"];
    cell.centerCodeLabel.text = patient[@"groupNumber"];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@  %@  %@",patient[@"projectPlanMainName"],patient[@"caseRandom"],patient[@"patientNumber"]];
    
    if ([patient[@"finishStatus"] length] > 0 && [patient[@"finishStatus"] integerValue] == 0) {
        cell.dropImageView.hidden = NO;
    } else {
        cell.dropImageView.hidden = YES;
    }
    NSString *picStr = patient[@"localPic"];
    if (picStr.length > 0) {
        cell.nameImageLabel.hidden = YES;
//        if ([self isBeginWithHttp:picStr]) {
//            [XJAPIManager loadPicOnImageView:cell.myImageView withHttpUrl:picStr placeHolderPicName:@"医生默认头像.png"];
//        } else {
//            [XJAPIManager loadPicOnImageView:cell.myImageView withPicStr:picStr placeHolderPicName:@"医生默认头像.png"];
//        }
    } else {
        cell.nameImageLabel.hidden = NO;
        if ([[patient valueForKey:@"patientName"] isEqualToString:@""]) {
            cell.nameImageLabel.text = @"患";
        }else{
            cell.nameImageLabel.text = [[patient valueForKey:@"patientName"] substringToIndex:1];
        }
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
    
}

#pragma mark - private

- (void)resetParameters{
    page = 0;
    
    projectID = self.projectDict[@"id"];
    patientName = @"";
    sex = @"";
    groupNumber = @"";
    minAge = @"";
    maxAge = @"";
    address = @"";
    communityHospital = @"";
    doctorName = @"";
    typeName = @"";
    patientNumber = @"";
    caseRandom = @"";
    nameAbc = @"";
    startDate = @"";
    endDate = @"";
    projectPlanMainId = @"";
    orderParam = @"";
    status = @"1";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    page = 0;
    [self getData];
    return YES;;
}


#pragma mark - Event

- (void)onButtonsAction:(UIButton *)sender{
    if (sender.tag == 0) {
        YKAddProjectPatientVC *vc = [[YKAddProjectPatientVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)sortClick{
    CGPoint point = CGPointMake(29.5, 224.5);
    NSArray *titles = @[@"按时间", @"按姓名"];
    PopoverView * pop = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.bgColor = [UIColor whiteColor];
    pop.selectRowAtIndex = ^(NSInteger index){
        page = 0;
        if (index == 0) {
            orderParam = @"createDate";
            [self getData];
        }else{
            orderParam = @"patientName";
            [self getData];
        }
    };
    [pop show];
}


- (void)onTextChange:(UITextField *)textfield{
    patientName = textfield.text;
}

@end
