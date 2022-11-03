//
//  YKHomeVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/11.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKHomeVC.h"
#import "BFCButton.h"
#import "YKHomeCell.h"
#import "YKAnnouncementVC.h"
#import "YKTabBarVC.h"
#import "YKWebVC.h"
#import "YKConsultVC.h"


@interface YKHomeVC ()<UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *containView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *placeHoderImageView;

@property (strong, nonatomic) UIView *footerRemindView;
@property (strong, nonatomic) UILabel *remindWordLabel;

@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation YKHomeVC
{
    NSString *currentTime;
    NSDate *currentDate;
    UITapGestureRecognizer *reRegisterTap;//重新提交注册信息
    UITapGestureRecognizer *kaitongzhensuoTap;//第一次开通诊所
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
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self checkUpdateFromBackground];
    [self createRightButtonItems];
    [self layoutAllSubviews];
    [self createLabelAction];
    [self getAnnouncementList];
    NSString *str = [self getCurrentdate];
    [self getResearchProjectListBeginTime:str endTime:str];

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
    
    if(@available(iOS 15.0,*)){
        UINavigationBarAppearance *apperance=[[UINavigationBarAppearance alloc]init];
        //设置背景色
        apperance.backgroundColor = [UIColor whiteColor];
        //设置标题字体
        [apperance setTitleTextAttributes:@{
          NSFontAttributeName:[UIFont systemFontOfSize:19],
          NSForegroundColorAttributeName:[UIColor blackColor]
        }];
        //分割线去除
        apperance.shadowColor = [UIColor clearColor];
        //重新赋值
        self.navigationController.navigationBar.standardAppearance = apperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19]}];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    

    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self setDoctorType];
}


//设置客服按钮
- (void)createRightButtonItems {
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
    image2.image = [UIImage imageNamed:@"home_service"];

    image2.userInteractionEnabled = YES;
    [image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneClick)]];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:image2];
    self.navigationItem.rightBarButtonItem = right2;
}

//添加控件
- (void)layoutAllSubviews{


    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.view);
       }];
       
       //为UIScrollView能使用mansory添加控件能滑动 需要添加一个containView
    [_scrollView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView); // 需要设置宽度和scrollview宽度一样
    }];
    
    [self.containView addSubview:self.topView];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.containView);
        make.height.mas_equalTo(283);
    }];
}

- (void)addTableView{
     [self.bottomView removeFromSuperview];
     self.bottomView = nil;
     self.tableView = nil;
     self.placeHoderImageView = nil;
     [self.containView addSubview:self.bottomView];

     
    if (self.dataArray.count > 0) {
          [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.containView);
            make.height.mas_equalTo (32 + 68 * self.dataArray.count);
        }];
    }else{
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.containView);
            make.height.mas_equalTo (260);
        }];
    }
  
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
}
#pragma mark - NetRequest

//获取公告列表
- (void)getAnnouncementList{
    
    [[YKBaseApiSeivice service] getAnnouncementListCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            NSString *announcementStr = responseObject[0][@"title"];
            self.noticeLabel.text = announcementStr;
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}

//科室列表接口
- (void)getDepartMentList{

}

- (void)getResearchProjectListBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{
    
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getFollowUPListWithBeginTime:beginTime endTime:endTime projectId:@"" patientName:@"" Completion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            NSArray *tempArray= responseObject[@"projectPlanList"];
            [self.dataArray removeAllObjects];
            if (tempArray.count > 0) {
                for (NSDictionary *dict in tempArray) {
                    [self.dataArray addObject:dict];
                }
            }
            [self addTableView];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            [self addTableView];
        }
    }];
}

#pragma mark - init

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = RGBACOLOR(245, 245, 245);

    }
    return _scrollView;
}

- (UIView *)containView{
    if (!_containView) {
        _containView = [UIView new];
    }
    return _containView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *topImageView = [UIImageView new];
        topImageView.image = [UIImage imageNamed:@"home_banner"];
        topImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideClick)];
        [topImageView addGestureRecognizer:guideTap];
        [_topView addSubview:topImageView];
        
        UIView *noticeView = [UIView new];
        [_topView addSubview:noticeView];

        
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(_topView).offset(15);
              make.left.mas_equalTo(_topView).offset(15);
              make.right.mas_equalTo(_topView).offset(-15);
              make.height.mas_equalTo(128);
        }];
          
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(topImageView.mas_bottom);
              make.left.mas_equalTo(_topView);
              make.right.mas_equalTo(_topView);
              make.height.mas_equalTo(40);
        }];
        
        UIImageView *noticeImageView = [UIImageView new];
        noticeImageView.image = [UIImage imageNamed:@"home_notice"];
        
        UIButton *rightButton = [UIButton new];
        [rightButton setImage:[UIImage imageNamed:@"home_right"]  forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *moreButton = [UIButton new];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:RGBACOLOR(153, 153, 153) forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [noticeView addSubview:noticeImageView];
        [noticeView addSubview:self.noticeLabel];
        [noticeView addSubview:rightButton];
        [noticeView addSubview:moreButton];

        
        [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(noticeView).offset(10);
              make.left.mas_equalTo(noticeView).offset(15);
            make.size.mas_equalTo(CGSizeMake(35, 16));
        }];
        
        [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(noticeImageView);
            make.left.mas_equalTo(noticeImageView.mas_right).offset(5);
            make.right.mas_equalTo(noticeView).offset(-80);
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(noticeImageView);
            make.right.mas_equalTo(noticeView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(8, 14));
        }];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(noticeImageView);
            make.right.mas_equalTo(rightButton.mas_left);
        }];
        
        for (int i = 0; i < 4; i ++) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 4 * i, 180, KWIDTH / 4, 102)];
            [_topView addSubview:tempView];

            BFCButton *collectBtn = [BFCButton buttonWithType:UIButtonTypeCustom];
            collectBtn.tag = i;
            [collectBtn addTarget:self action:@selector(onButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
            collectBtn.alignType = BFCButtonAlignTypeTextBottom;
            if (i == 0) {
                [collectBtn setImage:[UIImage imageNamed:@"home_patient"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"患者" forState:UIControlStateNormal];
            }else if (i == 1){
                [collectBtn setImage:[UIImage imageNamed:@"home_project"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"病例登记" forState:UIControlStateNormal];
            }else if (i == 2){
                [collectBtn setImage:[UIImage imageNamed:@"home_consultation"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"会诊" forState:UIControlStateNormal];
            }else if (i == 3){
                [collectBtn setImage:[UIImage imageNamed:@"home_refer"] forState:UIControlStateNormal];
                [collectBtn setTitle:@"转诊" forState:UIControlStateNormal];
            }
            collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [collectBtn setTitleColor:RGBACOLOR(51, 51, 51) forState:UIControlStateNormal];
            [tempView addSubview:collectBtn];
            [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(tempView);
                make.centerX.mas_equalTo(tempView);
                make.height.mas_equalTo(80);
            }];
        }
        
    }
    return _topView;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *leftView = [UIView new];
        leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:221/255.0 blue:191/255.0 alpha:1.0];
        [_bottomView addSubview:leftView];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"随访消息";
        titleLabel.font = [UIFont systemFontOfSize:17];
        [_bottomView addSubview:titleLabel];
        
        
        UIButton *rightButton = [UIButton new];
        [rightButton setImage:[UIImage imageNamed:@"home_right"]  forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:rightButton];

        UIButton *moreButton = [UIButton new];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:RGBACOLOR(153, 153, 153) forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:moreButton];

        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView).offset(13);
            make.top.mas_equalTo(_bottomView).offset(12);
            make.size.mas_equalTo(CGSizeMake(3, 16));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(5);
            make.centerY.mas_equalTo(leftView);
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.right.mas_equalTo(_bottomView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(8, 14));
        }];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.right.mas_equalTo(rightButton.mas_left);
        }];

        
        if (self.dataArray.count > 0) {
             [_bottomView addSubview:self.tableView];
             [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_bottomView).offset(32);
                make.left.right.mas_equalTo(_bottomView);
                make.height.mas_equalTo(self.dataArray.count * 68);
            }];
        }else{
            [_bottomView addSubview:self.placeHoderImageView];

            [self.placeHoderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bottomView);
                make.top.mas_equalTo(leftView.mas_bottom).offset(10);
            }];
        }

    }
    return _bottomView;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 68;
        _tableView.scrollEnabled = NO;
        [_tableView setSeparatorColor:RGBACOLOR(238, 238, 238)];
    }
    return _tableView;
}

- (UIImageView *)placeHoderImageView{
    if (!_placeHoderImageView) {
        _placeHoderImageView = [UIImageView new];
        _placeHoderImageView.image = [UIImage imageNamed:@"home_default"];
    }
    return _placeHoderImageView;;
}


- (UILabel *)noticeLabel{
    if (!_noticeLabel) {
         _noticeLabel = [UILabel new];
         _noticeLabel.textColor = RGBACOLOR(153, 153, 153);
         _noticeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _noticeLabel;;
}

#pragma mark - tableViewDelegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"patientName"]];
    cell.projectLabel.text = [NSString stringWithFormat:@"%@",dict[@"projectName"]];
    cell.stageLabel.text = [NSString stringWithFormat:@"%@ | %@",dict[@"planName"],dict[@"planMainName"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArray.count) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - 底部提示

//提示框Label事件
- (void)createLabelAction {
    self.footerRemindView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40, self.view.frame.size.width, 40)];
    self.footerRemindView.backgroundColor = [UIColor blueColor];
//    self.footerRemindView.backgroundColor = [UIColor colorWithRed:0/255.0 green:221/255.0 blue:191/255.0 alpha:1.0];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
    image.image = [UIImage imageNamed:@"感叹号.png"];
    [self.footerRemindView addSubview:image];
    self.remindWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, self.view.frame.size.width - 40, 20)];
    self.remindWordLabel.textColor = [UIColor whiteColor];
    [self.footerRemindView addSubview:self.remindWordLabel];
    [self.view addSubview:self.footerRemindView];
    [self.view bringSubviewToFront:self.footerRemindView];
}

-(void)setDoctorType{
    YKDoctor *doc = [YKDoctorHelper shareDoctor];
    if ([doc.type integerValue] == 3) {
        [self.footerRemindView removeGestureRecognizer:reRegisterTap];
        //新注册的医生
        if ([doc.registerType integerValue] == 1) {
            [self.footerRemindView removeGestureRecognizer:kaitongzhensuoTap];
            //新注册的医生  开通诊所审核中
            _remindWordLabel.text = @"您的资料已成功提交,后台审核中";
        }else{
            //新注册的医生 未开通诊所
            _remindWordLabel.text = @"您尚未通过实名认证,现在去认证    >";
            kaitongzhensuoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footLabelAction:)];
            [self.footerRemindView addGestureRecognizer:kaitongzhensuoTap];
            [self.view bringSubviewToFront:self.footerRemindView];
        }
    }else if ([doc.type integerValue] == 4){
        //审核失败 需要提示进入查看原因(2.0暂没有这个操作. 2.1里面是一个推送),就暂时不用处理type = 4
        //_footerRemindView.hidden = YES;
        _remindWordLabel.text = @"您的信息审核未通过,请重新提交    >";
        reRegisterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footLabelAction:)];
        [self.footerRemindView addGestureRecognizer:reRegisterTap];
        [self.view bringSubviewToFront:self.footerRemindView];
    }else{
        _footerRemindView.hidden = YES;
    }

}

- (void)footLabelAction:(UITapGestureRecognizer *)gesture {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    XJOpenClinicTableController *openVC = [sb instantiateViewControllerWithIdentifier:@"XJOpenClinicTableController"];
//    if (gesture == reRegisterTap) {
//        openVC.isTwice = YES;
//    } else {
//        openVC.isTwice = NO;
//    }
//    [self.navigationController pushViewController:openVC animated:YES];
}



#pragma mark - Private method

- (NSString *)getCheaseDateStrWithDateStr:(NSString *)dateStr {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dateStr componentsSeparatedByString:@"-"]];
    return [NSString stringWithFormat:@"%@年%@月%@日", arr[0], arr[1], arr[2]];
}

#pragma mark - Event

- (void)guideClick{
    YKWebVC *webVC = [[YKWebVC alloc]init];
    webVC.titleString = @"新手必看";
    webVC.urlString = @"/weixin/app-doc.html";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)phoneClick{
     NSString *phoneNumber = @"tel://4006270012";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)moreClick{
    YKAnnouncementVC *announceVC = [[YKAnnouncementVC alloc] init];
    announceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:announceVC animated:YES];
}

- (void)onButtonsAction:(UIButton *)sender{
    if (sender.tag == 0) {
        YKTabBarVC *tabBarVC = [[YKTabBarVC alloc] init];
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = tabBarVC;
        tabBarVC.selectedIndex = 1;
    }else if (sender.tag == 1) {
        YKTabBarVC *tabBarVC = [[YKTabBarVC alloc] init];
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = tabBarVC;
        tabBarVC.selectedIndex = 3;
    }else if (sender.tag == 2) {
        YKConsultVC *consultVC = [[YKConsultVC alloc] init];
        consultVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consultVC animated:YES];
    }else if (sender.tag == 3) {

    }
}

- (void)selectClick{
    
}

    
#pragma mark - 强制更新

- (void)checkUpdateFromBackground{

}




@end
