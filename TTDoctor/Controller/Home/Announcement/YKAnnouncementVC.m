//
//  YKAnnouncementVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/17.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAnnouncementVC.h"
#import "YKAnnouncementCell.h"
#import "YKWebVC.h"

@interface YKAnnouncementVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YKAnnouncementVC
{
    int _page;
    NSString *_pageString;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    [self addLeftBackNavigationItemWithImageName:@"icon_back"];
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 0;
    [self layoutAllSubviews];
    [self createRefreshWithTableView:_tableView];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];
}

- (void)startRefresh{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        _page = 0;
        [self getAnnouncementList];
    }else{
        _page ++;
        [self getAnnouncementList];
    }
}

#pragma mark -NetWork

//获取公告列表
- (void)getAnnouncementList{
    _pageString = [NSString stringWithFormat:@"%d",_page *10];
    [[YKBaseApiSeivice service] getAnnouncementListWithStartPage:_pageString completion:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *tempArray = responseObject[@"rows"];
            [self doDataWithArray:tempArray];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//处理数据
- (void)doDataWithArray:(NSArray *)tempArray {
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKAnnouncementCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKAnnouncementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",dict[@"day"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    YKWebVC *webVC = [[YKWebVC alloc] init];
    webVC.titleString = @"公告详情";
    webVC.urlString = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
