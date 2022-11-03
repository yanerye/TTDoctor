//
//  YKProjectVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/29.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKProjectVC.h"
#import "YKProjectDetailVC.h"

@interface YKProjectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *defaultImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKProjectVC
{
    int _page;
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
    _page = 0;
    self.navigationItem.title = @"病历登记";
    self.view.backgroundColor = RGBACOLOR(245, 245, 245);
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:19]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.defaultImageView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

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

//我的项目
-(void)getData
{
    NSString *pageStr = [NSString stringWithFormat:@"%d", _page * 10];
    [[YKBaseApiSeivice service] getCaseRecordListWithStartPage:pageStr completion:^(id responseObject, NSError *error){
        if (!error) {
            [self doThisDataWithResponseObj:responseObject];
        }else{
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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

    if (self.dataArray.count == 0) {
        self.defaultImageView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.defaultImageView.hidden = YES;
        self.tableView.hidden = NO;
    }
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
        [_tableView setSeparatorColor:RGBACOLOR(238, 238, 238)];

        [self createRefreshWithTableView:_tableView];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"projectName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < self.dataArray.count) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01f;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.dataArray[indexPath.row] valueForKey:@"projectLockFlag"] boolValue] == YES) {
        [YKAlertHelper showErrorMessage:@"该项目已经锁定,不允许操作" inView:self.view];
    } else {
        YKProjectDetailVC *vc = [[YKProjectDetailVC alloc] init];
        NSDictionary *dict = self.dataArray[indexPath.row];
        vc.projectDict = dict;
        if ([dict[@"projectOwnType"] isEqualToString:@"sharecooperation"]) {
            vc.isSpecialMember = YES;
        }else{
            vc.isSpecialMember = NO;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        XJResearchPatientListController *researshPatientVC = [storyboard instantiateViewControllerWithIdentifier:@"XJResearchPatientListController"];
//        LWGResearchProject *rp = self.dataArray[indexPath.row];
//        researshPatientVC.isSpecialMember = [rp.projectOwnType isEqualToString:@"sharecooperation"];//判断该用户是不是协作组成员
//        researshPatientVC.rpModel = rp;
//        researshPatientVC.projectId = rp.projectId;
//        researshPatientVC.title = rp.projectName;
//        [self.navigationController pushViewController:researshPatientVC animated:YES];
    }
   
}

@end
