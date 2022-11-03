//
//  YKAddPatientVC.m
//  TTDoctor
//
//  Created by YK on 2021/10/9.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKAddPatientVC.h"
#import "YKAddProjectPatientCell.h"
#import "MMPopupView.h"
#import "MMSheetView.h"
#import "CXDatePickerView.h"
#import "NSDate+CXCategory.h"
#import "YKSelectTagVC.h"
#import "YKSelectMainSymptomVC.h"

@interface YKAddPatientVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) NSArray *infoTitleArray;
@property (nonatomic, strong) NSArray *infoPlaceholderArray;

@property (nonatomic, strong) NSArray *moreTitleArray;
@property (nonatomic, strong) NSArray *morePlaceholderArray;


@property (nonatomic, strong) NSArray *nationArray;


@end

@implementation YKAddPatientVC
{
    BOOL _isShowMore;
    NSString *_patientNameStr;      //患者姓名
    NSString *_cellphoneStr;        //手机号
    NSString *_fixedCellPhoneStr;   //电话
    NSString *_sexStr;              //性别
    NSString *_birthdayStr;         //出生年月
    NSString *_ageStr;              //年龄
    NSString *_tagIdsStr;           //患者标签
    NSString *_goodEntityIdsStr;    //主症
    NSString *_complicationStr;     //并发症
    NSString *_idCardNum;           //身份证号
    NSString *_addressStr;          //住址
    NSString *_sureTimeStr;         //确认时间
    NSString *_courseTimeYearStr;            //病程时间年
    NSString *_courseTimeMonthStr;           //病程时间月
    NSString *_courseTimeDayStr;             //病程时间日
    NSString *_heightStr;                    //身高
    NSString *_weightStr;                    //体重
    NSString *_bmiStr;                       //BMI
    NSString *_temperatureStr;               //体温
    NSString *_emailStr;                     //邮箱
    NSString *_wechatStr;                    //微信
    NSString *_qqStr;                        //QQ
    NSString *_linkNameStr;                  //联系人姓名
    NSString *_linkCellPhoneStr;             //联系人电话
    NSString *_linkRelationStr;              //联系人关系
    NSString *_degreeIdStr;                  //学历
    NSString *_nationIdStr;                  //民族
    NSString *_occupationIdStr;              //职业
    NSString *_marriageIdStr;                //婚姻状况
    NSString *_provinceStr;                  //籍贯-省
    NSString *_cityStr;                      //籍贯-城市
    NSString *_clinicNumStr;                 //门诊号
    NSString *_sickNumStr;                   //住院号
    NSString *_bedNumStr;                    //病床号
    NSString *_hospitalStartDateStr;         //入院时间
    NSString *_hospitalEndDateStr;           //出院时间
    NSString *_hospitalDayStr;               //住院天数
    NSString *_outHospitalDiagnosticStr;     //出院诊断
    NSString *_communityHospitalStr;         //单位
    NSString *_communityDoctorStr;           //医生
    NSString *_typeNameStr;                  //备注
}

- (NSArray *)infoTitleArray{
    if (!_infoTitleArray) {
        _infoTitleArray = @[@"患者姓名",@"手机号",@"电话号",@"性别",@"出生年月",@"年龄",@"患者标签",@"主症",@"并发症",@"身份证号",@"住址"];
    }
    return _infoTitleArray;
}

- (NSArray *)infoPlaceholderArray{
    if (!_infoPlaceholderArray) {
        _infoPlaceholderArray = @[@"请输入患者姓名",@"请输入手机号",@"请输入电话号",@"",@"",@"请输入年龄",@"",@"",@"请输入并发症",@"请输入身份证号",@"请输入住址"];
    }
    return _infoPlaceholderArray;
}

- (NSArray *)moreTitleArray{
    if (!_moreTitleArray) {
        _moreTitleArray = @[@"确诊时间",@"病程时间",@"身高",@"体重",@"BMI",@"体温",@"邮箱",@"微信",@"QQ",@"联系人",@"联系人电话",@"联系人关系",@"学历",@"民族",@"职业",@"婚姻状况",@"籍贯",@"",@"门诊号",@"住院号",@"病床号",@"入院时间",@"出院时间",@"住院天数",@"出院诊断",@"单位",@"医生",@"备注"];
    }
    return _moreTitleArray;
}

- (NSArray *)morePlaceholderArray{
    if (!_morePlaceholderArray) {
        _morePlaceholderArray = @[@"",@"",@"请输入身高",@"请输入体重",@"",@"请输入体温",@"请输入邮箱",@"请输入微信号",@"请输入QQ号",@"请输入联系人",@"请输入联系人电话",@"",@"",@"",@"",@"",@"请输入省/市/自治区",@"请输入市/县/区",@"请输入门诊号",@"请输入住院号",@"请输入病床号",@"",@"",@"",@"请输入出院诊断",@"请输入单位名称",@"请输入医生姓名",@"请输入备注"];
    }
    return _morePlaceholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加患者";
    [self createRightButtonItems];
    [self layoutAllSubviews];
    [self initializeParameter];
    [self getChooseDate];
    _isShowMore = NO;
}

- (void)getChooseDate{
    [[YKBaseApiSeivice service] getPatientChooseDateCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            self.nationArray = responseObject[@"occupation"];
        }else{
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}

- (void)initializeParameter{
    _patientNameStr = @"";
    _cellphoneStr = @"";
    _fixedCellPhoneStr = @"";
    _sexStr = @"";
    _birthdayStr = @"";
    _ageStr = @"";
    _tagIdsStr = @"";
    _goodEntityIdsStr = @"";
    _complicationStr = @"";
    _idCardNum = @"";
    _addressStr = @"";
    _sureTimeStr = @"";
    _courseTimeYearStr = @"";
    _courseTimeMonthStr = @"";
    _courseTimeDayStr = @"";
    _heightStr = @"";
    _weightStr = @"";
    _bmiStr = @"";
    _temperatureStr = @"";
    _emailStr = @"";
    _wechatStr = @"";
    _qqStr = @"";
    _linkNameStr = @"";
    _linkCellPhoneStr = @"";
    _linkRelationStr = @"";
    _degreeIdStr = @"";
    _nationIdStr = @"";
    _occupationIdStr = @"";
    _marriageIdStr = @"";
    _provinceStr = @"";
    _cityStr = @"";
    _clinicNumStr = @"";
    _sickNumStr = @"";
    _bedNumStr = @"";
    _hospitalStartDateStr = @"";
    _hospitalEndDateStr = @"";
    _hospitalDayStr = @"";
    _outHospitalDiagnosticStr = @"";
    _communityHospitalStr = @"";
    _communityDoctorStr = @"";
    _typeNameStr = @"";
}

- (void)createRightButtonItems {
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = right2;
}


- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
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
        return 11;
    }
    
    if (_isShowMore) {
        return 28;
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
        
        cell.titleLabel.text = self.infoTitleArray[indexPath.row];

        if (indexPath.row == 0) {
            cell.contentTextField.placeholder = self.infoPlaceholderArray[indexPath.row];
            cell.addressBookButton.hidden = NO;
        }else if (indexPath.row == 3 ) {
            cell.contentTextField.text = @"请选择性别";
            cell.contentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 4) {
            cell.contentTextField.text = @"请选择出生日期";
            cell.contentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 6 || indexPath.row == 7) {
            cell.contentTextField.userInteractionEnabled = NO;
            cell.rightImageView.hidden = NO;
        }else{
            cell.contentTextField.placeholder = self.infoPlaceholderArray[indexPath.row];
            cell.contentTextField.userInteractionEnabled = YES;
        }

        return cell;
    }
    
    cell.addressBookButton.hidden = YES;
    cell.rightImageView.hidden = YES;
    cell.titleLabel.text = self.moreTitleArray[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.contentTextField.text = @"请选择确诊时间";
        cell.contentTextField.userInteractionEnabled = NO;
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        cell.unitLabel.hidden = NO;
        cell.unitLabel.text = @"CM";
    }else if (indexPath.row == 3){
        cell.unitLabel.hidden = NO;
        cell.unitLabel.text = @"KG";
    }else if (indexPath.row == 4){
        cell.contentTextField.userInteractionEnabled = NO;
    }else if (indexPath.row == 5){
        cell.unitLabel.hidden = NO;
        cell.unitLabel.text = @"℃";
    }else if (indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 14 || indexPath.row == 15){
        cell.contentTextField.text = @"请选择";
        cell.contentTextField.textColor = RGBACOLOR(51, 51, 51);
        cell.contentTextField.userInteractionEnabled = NO;
        cell.contentTextField.backgroundColor = RGBACOLOR(229, 229, 229);
    }else if (indexPath.row == 21){
        cell.contentTextField.text = @"请选择入院时间";
        cell.contentTextField.userInteractionEnabled = NO;
    }else if (indexPath.row == 22){
        cell.contentTextField.text = @"请选择出院时间";
        cell.contentTextField.userInteractionEnabled = NO;
    }else if (indexPath.row == 23){
        cell.contentTextField.text = @"";
        cell.contentTextField.userInteractionEnabled = NO;
    }
    
    cell.contentTextField.placeholder = self.morePlaceholderArray[indexPath.row];

    return cell;
    
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKAddProjectPatientCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 3 ) {
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    cell.contentTextField.text = @"男";
                } else if(index == 1) {
                    cell.contentTextField.text = @"女";
                }
            };
            NSArray *items = @[MMItemMake(@"男", MMItemTypeNormal, block),
                               MMItemMake(@"女", MMItemTypeNormal, block)];
            [[[MMSheetView alloc] initWithTitle:nil items:items] showWithBlock:nil];
        }else if (indexPath.row == 4) {
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDay completeBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
                cell.contentTextField.text = dateString;
                NSLog(@"选择的日期：%@",dateString);
            }];
            datepicker.datePickerColor = RGBACOLOR(153, 153, 153);//滚轮日期颜色
            datepicker.datePickerSelectColor = [UIColor blackColor];
            datepicker.hideSegmentedLine = NO;
            datepicker.datePickerSelectFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            [datepicker show];
        }else if (indexPath.row == 6) {
            YKSelectTagVC *tagVC = [[YKSelectTagVC alloc] init];
            tagVC.block = ^(NSString *tagIds, NSString *tagNames) {
                NSLog(@"%@=======%@",tagIds,tagNames);
            };
            [self.navigationController pushViewController:tagVC animated:YES];
        }else if (indexPath.row == 7) {
            YKSelectMainSymptomVC *vc = [[YKSelectMainSymptomVC alloc] init];
            vc.block = ^(NSString *goodEntityIds, NSString *goodEntityNames) {
                NSLog(@"%@=======%@",goodEntityIds,goodEntityNames);
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        if (indexPath.row == 0) {
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDay completeBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",dateString);
            }];
            datepicker.datePickerColor = RGBACOLOR(153, 153, 153);//滚轮日期颜色
            datepicker.datePickerSelectColor = [UIColor blackColor];
            datepicker.hideSegmentedLine = NO;
            datepicker.datePickerSelectFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            [datepicker show];
        }else if (indexPath.row == 21){
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDay completeBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",dateString);
            }];
            datepicker.datePickerColor = RGBACOLOR(153, 153, 153);//滚轮日期颜色
            datepicker.datePickerSelectColor = [UIColor blackColor];
            datepicker.hideSegmentedLine = NO;
            datepicker.datePickerSelectFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            [datepicker show];
        }else if (indexPath.row == 22){
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDay completeBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",dateString);
            }];
            datepicker.datePickerColor = RGBACOLOR(153, 153, 153);//滚轮日期颜色
            datepicker.datePickerSelectColor = [UIColor blackColor];
            datepicker.hideSegmentedLine = NO;
            datepicker.datePickerSelectFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            [datepicker show];
        }
    }
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 17) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 105, 0, 0)];
    }

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


- (void)doneClick{
    
}

@end

