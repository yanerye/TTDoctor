//
//  YKMineVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/11.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKMineVC.h"
#import "YKMineCell.h"
#import "YKLoginVC.h"
#import "YKUserInfoVC.h"
#import "YKQRCodeVC.h"
#import "YKServiceSettingVC.h"
#import "YKWebVC.h"
#import "YKDoctorListVC.h"
#import <TZImagePickerController.h>
#import "YKChatMessageModel.h"
#import "YKChatMessageManager.h"
#import "YKChatUserModel.h"
#import "YKChatDBManager.h"
#import "YKChatHelper.h"
#import "SDImageCache.h"
#import <MyTestSDK/YKAlertViewController.h>

@interface YKMineVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) YKChatUserModel *userModel;
@property (nonatomic, strong) NSMutableArray *messageModels;


@end

@implementation YKMineVC
{
    YKDoctor *doc;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"我的_我的二维码",@"我的_服务设置",@"我的_服务条款",@"我的_关于我们"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"我的二维码",@"服务设置",@"服务条款",@"关于我们"];
    }
    return _titleArray;
}

- (NSMutableArray *)messageModels{
    if (!_messageModels) {
        _messageModels = [NSMutableArray arrayWithCapacity:0];
    }
    return _messageModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(244, 244, 244);
    [self layoutAllSubviews];
//    [self addTestButton];
//    YKChatUserModel *userModel = [[YKChatUserModel alloc] init];
//    userModel.uid = @"102";
//    userModel.avatar = @"https://cmcd.ttdoc.cn/weixin/images/woman.png";
//    userModel.name = @"王小四";
//    self.userModel = userModel;
//    [self showAlertButton];
}

- (void)showAlertButton{
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 50)];
    sendButton.backgroundColor = [UIColor cyanColor];
    [sendButton setTitle:@"显示" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

-(void)showAlert{
    ZHYAlertButtonItem *cancel = [[ZHYAlertButtonItem alloc] init];
    cancel.title = @"取消";
    cancel.color = 0xAD7255;
    ZHYAlertButtonItem *sure = [[ZHYAlertButtonItem alloc] init];
    sure.title = @"确定";
    sure.color = 0xAD7255;
    sure.buttonBlock = ^{

    };
    YKAlertViewController *alert = [[YKAlertViewController alloc] initWithAlertTitle:@"退出提示" contentText:@"您确定要退出当前账户？" actionButtons:@[cancel, sure]];
    [alert showAlert];
}

- (void)addTestButton{
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 50)];
    sendButton.backgroundColor = [UIColor cyanColor];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    UIButton *receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 50)];
    receiveButton.backgroundColor = [UIColor cyanColor];
    [receiveButton setTitle:@"接收" forState:UIControlStateNormal];
    [receiveButton addTarget:self action:@selector(receive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receiveButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 100, 50)];
    saveButton.backgroundColor = [UIColor cyanColor];
    [saveButton setTitle:@"显示保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 100, 50)];
    deleteButton.backgroundColor = [UIColor cyanColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
}

- (void)send{
    YKChatMessageModel *model = [YKChatMessageManager createTextMessage:self.userModel
                                                                message:@"我发送了一条文本消息"
                                                               isSender:YES];
    [self sendMessageModel:model];
}


//发送消息
- (void)sendMessageModel:(YKChatMessageModel *)model {
    [self addMessageModel:model];
}

//消息存储
- (void)addMessageModel:(YKChatMessageModel *)model {
    [[YKChatDBManager DBManager] insertMessage:model chatWithUser:self.userModel];
    
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)receive{

    YKChatMessageModel *model = [YKChatMessageManager createTextMessage:self.userModel
                                                                message:@"我收到了一条文本消息，啊哈哈哈哈哈哈哈安徽哈哈哈殴斗阿苏有大神的阿萨德阿萨德啊"
                                                               isSender:NO];
    [self receiveMessageModel:model];
}

//收到消息
- (void)receiveMessageModel:(YKChatMessageModel *)model {
    [self addMessageModel:model];
}

- (void)delete{
    [[YKChatDBManager DBManager] deleteUserModel:self.userModel.uid];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可不写
}

- (void)show{
    self.messageModels = [[YKChatDBManager DBManager] messagesWithUser:self.userModel];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    doc = [YKDoctorHelper shareDoctor];
    [self configUI];
    [self preferredStatusBarStyle];
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutButton];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(240);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(-16);
        make.height.mas_equalTo(200);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.height.mas_equalTo(46);
    }];
}


- (void)configUI{
     NSString *picUrl = doc.picUrl;
     if (picUrl.length < 1) {
         self.iconImageView.image = [UIImage imageNamed:@"我的_医生默认"];
     } else {
         NSString *doctorImageStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,picUrl];
         [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctorImageStr] placeholderImage:[UIImage imageNamed:@"我的_医生默认"]];
     }
    NSString *tempString1 = [NSString stringWithFormat:@"%@", doc.familyname];
    NSString *tempString= [NSString stringWithFormat:@"%@ %@ | %@", doc.familyname,doc.professionalRanksName, doc.deptName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, tempString1.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(tempString1.length , tempString.length - tempString1.length)];
    self.introduceLabel.attributedText = str;
    self.hospitalLabel.text = doc.hospitalName;
}

#pragma mark - init

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = COMMONCOLOR;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"个人中心";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [_headerView addSubview:titleLabel];
        
        self.iconImageView = [UIImageView new];
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = 39;
        self.iconImageView.backgroundColor = [UIColor cyanColor];
        self.iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconGTR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountClick)];
        [self.iconImageView addGestureRecognizer:iconGTR];
        [_headerView addSubview:self.iconImageView];
        
        self.introduceLabel = [UILabel new];
        self.introduceLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:self.introduceLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_headerView);
            make.top.mas_equalTo(_headerView).offset(32.5);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView).offset(74);
            make.centerX.mas_equalTo(_headerView);
            make.size.mas_equalTo(CGSizeMake(77, 77));
        }];
        
        [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView).offset(162);
            make.centerX.mas_equalTo(_headerView);
        }];
        
        self.hospitalLabel = [UILabel new];
        self.hospitalLabel.textColor = [UIColor whiteColor];
        self.hospitalLabel.font = [UIFont systemFontOfSize:14];
        [_headerView addSubview:self.hospitalLabel];
        
        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView).offset(191);
            make.centerX.mas_equalTo(_headerView);

        }];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 5;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        
        [_tableView setSeparatorColor:RGBACOLOR(238, 238, 238)];

    }
    return _tableView;
}

- (UIButton *)logoutButton{
    if (!_logoutButton) {
        _logoutButton = [UIButton new];
        _logoutButton.backgroundColor = [UIColor whiteColor];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:RGBACOLOR(0, 205, 171) forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _logoutButton.layer.cornerRadius = 23;
        
        [_logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

#pragma mark - Event

- (void)accountClick{
    YKUserInfoVC *userVC = [[YKUserInfoVC alloc] init];
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}

//退出登录,显示登录页面
-(void)logOut {
    //清理数据
    [self clearData];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];

//    //极光推送移除别名
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//    } seq:0] ;
   
    if (accessToken.length >0) {
         //退出登录
        NSString *accessPath = [NSString stringWithFormat:@"%@/app/auth/v2.0/logout",TOKEN_SERVER];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:accessPath parameters:nil error:nil];
        request.timeoutInterval = 10.f;

        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
        NSURLSessionTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            //移除token
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
            //移除别名
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
        }];
        [task resume];
    }
    
    YKLoginVC *loginVC = [[YKLoginVC alloc] init];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    keyWindow.rootViewController = navi;
}

- (void)clearData{
    [YKDoctorHelper clearDoctor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"phoneNumber"];
    [userDefaults removeObjectForKey:@"passWord"];
    
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKMineCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.leftImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 3) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        YKQRCodeVC *QRCodeVC = [[YKQRCodeVC alloc] init];
        QRCodeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }else if (indexPath.row == 1){
        YKServiceSettingVC *settingVC = [[YKServiceSettingVC alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if (indexPath.row == 2){
        YKWebVC *webVC = [[YKWebVC alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.titleString = @"服务条款";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.row == 3){
        YKWebVC *webVC = [[YKWebVC alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.titleString = @"关于我们";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
//    YKDoctorListVC *vc = [[YKDoctorListVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    


}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


@end
