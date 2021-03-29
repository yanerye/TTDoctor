//
//  YKChatListVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/11.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatListVC.h"
#import "YKChatListCell.h"
#import "YKChatDetailVC.h"
#import "YKChatUserModel.h"
#import "YKTestChatVC.h"
//#import "LWGChatController.h"
//#import "FindPatientChatController.h"



@interface YKChatListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *defaultImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation YKChatListVC
{
    NSString * _patientName;
    NSString * _currentString;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"随访";
    self.view.backgroundColor = [UIColor whiteColor];
    _currentString = [self getCurrentdate];
    _patientName = @"";
    [self layoutAllSubviews];
}

- (NSString *)getCurrentdate{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    return dateStr;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                          NSFontAttributeName : [UIFont systemFontOfSize:19]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}


-(void)startRefresh
{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self startRequest];
    }else{
        [self startRequest];
    }
}

- (void)startRequest{
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];

    NSString *accessPath;
    if (_patientName.length == 0) {
         accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/list/0/null",TOKEN_SERVER];
    }else{
         accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/list/0/%@",TOKEN_SERVER,_patientName];
    }

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:accessPath parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];

    NSURLSessionTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSMutableArray *tempArray = [@[] mutableCopy];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [tempArray addObject:dic];
            }
            
            [self.dataArray removeAllObjects];
            
            if (tempArray.count > 0) {
                [self.dataArray addObjectsFromArray:tempArray];
                //刷新表格
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                self.defaultImageView.hidden = YES;
            } else {
                self.tableView.hidden = YES;
                self.defaultImageView.hidden = NO;
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [YKAlertHelper showErrorMessage:@"请求失败" inView:self.view];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
  
   [task resume];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.defaultImageView];

    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(5);
         make.left.mas_equalTo(self.view);
         make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
     }];
    
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
}

#pragma mark - init

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [UITextField new];
        _searchTextField.layer.cornerRadius = 20;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.layer.borderColor = RGBACOLOR(241, 241, 241).CGColor;
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入患者名字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153)}];
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
        
        UIView *leftView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 40)];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 16, 16)];
        leftImageView.image = [UIImage imageNamed:@"随访_搜索"];
        [leftView addSubview:leftImageView];
        
        _searchTextField.leftView=leftView;
        _searchTextField.leftViewMode=UITextFieldViewModeAlways;
        
        [_searchTextField addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 77;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [self createRefreshWithTableView:_tableView];

        
    }
    return _tableView;
}

- (UIImageView *)defaultImageView{
    if (!_defaultImageView) {
        _defaultImageView = [UIImageView new];
        _defaultImageView.image = [UIImage imageNamed:@"随访_默认"];
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
    YKChatListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    if ([dict[@"patientImage"] isKindOfClass:[NSNull class]]) {
        cell.leftImageView.image = [UIImage imageNamed:@"随访_默认头像"];
    }else{
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"随访_默认头像"]];
    }
    
    NSString *tempString = [[NSString stringWithFormat:@"%@",dict[@"updateDate"]] substringToIndex:10];
    NSString *dayString = [[self dateWithString:tempString] substringToIndex:10];
    NSString *minuteString = [[self dateWithString:tempString] substringFromIndex:11];
    
    if ([dayString isEqualToString:_currentString]) {
         cell.timeLabel.text = minuteString;
    }else{
        cell.timeLabel.text = [dayString substringFromIndex:5];
    }

    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
    if ([dict[@"lastMessage"] isKindOfClass:[NSNull class]]) {
        cell.messageLabel.text = @"";
    }else{
        cell.messageLabel.text = [NSString stringWithFormat:@"%@",dict[@"lastMessage"]];
    }
    
    if ([dict[@"unreadClient"] intValue] == 1 && [dict[@"unreadCount"] intValue] >0) {
        cell.redView.hidden = NO;
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [NSString stringWithFormat:@"%@",dict[@"unreadCount"]];
    }else{
        cell.redView.hidden = YES;
        cell.numberLabel.hidden = YES;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArray.count) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dict = self.dataArray[indexPath.row];
//    YKChatDetailVC *chatVC = [[YKChatDetailVC alloc] init];
//    chatVC.chatId = [NSString stringWithFormat:@"%@",dict[@"id"]];
//    chatVC.titleString = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
//    chatVC.patientImage = [NSString stringWithFormat:@"%@",dict[@"patientImage"]];
//    chatVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatVC animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    YKTestChatVC *chatVC = [[YKTestChatVC alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    YKChatUserModel *userModel = [[YKChatUserModel alloc] init];
    userModel.uid = [NSString stringWithFormat:@"%@",dict[@"id"]];
    userModel.name = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
    userModel.avatar = [NSString stringWithFormat:@"%@",dict[@"patientImage"]];
    chatVC.userModel = userModel;
    
    chatVC.chatId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - 时间戳转化日期

-(NSString*)dateWithString:(NSString*)str{
    NSTimeInterval interval = [str doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - UItextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self startRequest];
    return YES;;
}



#pragma mark - Event

- (void)selectClick{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    FindPatientChatController *swVC = [storyboard instantiateViewControllerWithIdentifier:@"FindPatientChatController"];
//    [self.navigationController pushViewController:swVC animated:YES];
}


- (void)onTextChange:(UITextField *)textfield{
    _patientName = textfield.text;
}


@end
