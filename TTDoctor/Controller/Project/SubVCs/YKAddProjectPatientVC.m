//
//  YKAddProjectPatientVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/29.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAddProjectPatientVC.h"
#import "YKAddProjectPatientCell.h"


@interface YKAddProjectPatientVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *containView;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UITableView *moreTableView;

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
        _moreTitleArray = @[@"第二部分1",@"第二部分2",@"第二部分3",@"第二部分4",@"第二部分5",@"第二部分6",@"第二部分7",@"第二部分8",@"第二部分9",@"第二部分10"];
    }
    return _moreTitleArray;
}

- (NSArray *)morePlaceholderArray{
    if (!_morePlaceholderArray) {
        _morePlaceholderArray = @[@"第二默认1",@"第二默认2",@"第二默认3",@"第二默认4",@"第二默认5",@"第二默认6",@"第二默认7",@"第二默认8",@"第二默认9",@"第二默认10"];
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
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.infoTableView];
    [self.scrollView addSubview:self.moreView];
    [self.scrollView addSubview:self.moreTableView];

//    [self.view addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.edges.equalTo(self.view);
//       }];
//
//       //为UIScrollView能使用mansory添加控件能滑动 需要添加一个containView
//    [_scrollView addSubview:self.containView];
//    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView); // 需要设置宽度和scrollview宽度一样
//    }];
//
//    [self.containView addSubview:self.infoTableView];
//    [self.containView addSubview:self.moreView];
//    [self.containView addSubview:self.moreTableView];
//
//    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self.containView);
//        make.height.mas_equalTo(540);
//    }];
//
//    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.containView);
//        make.top.mas_equalTo(self.infoTableView.mas_bottom);
//        make.height.mas_equalTo(50);
//    }];
//
//    [self.moreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.containView);
//        make.top.mas_equalTo(self.moreView.mas_bottom);
//        make.height.mas_equalTo(450);
//    }];
//
//    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.moreTableView.mas_bottom);
//    }];
}

#pragma mark - init

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - 64)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = RGBACOLOR(245, 245, 245);
        _scrollView.contentSize = CGSizeMake(KWIDTH, 590);
        
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)containView{
    if (!_containView) {
        _containView = [UIView new];
    }
    return _containView;
}


- (UITableView *)infoTableView{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 540) style:UITableViewStylePlain];
        _infoTableView.tag = 100;
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.rowHeight = 45;
    }
    return _infoTableView;
}

- (UIView *)moreView{
    if (!_moreView) {
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 540, KWIDTH, 50)];
        _moreView.backgroundColor = RGBACOLOR(242, 242, 246);
        
        UIButton *moreButton = [UIButton new];
        [moreButton setTitle:@"填写更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:RGBACOLOR(70, 150, 212) forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreView addSubview:moreButton];
        
        self.upButton = [UIButton new];
        [self.upButton setImage:[UIImage imageNamed:@"项目_向下"] forState:UIControlStateNormal];
        [self.upButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreView addSubview:self.upButton];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_moreView);
            make.centerX.mas_equalTo(_moreView).offset(-20);
        }];
        
        [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(moreButton);
            make.left.mas_equalTo(moreButton.mas_right).offset(5);
        }];
    }
    return _moreView;
}

- (UITableView *)moreTableView{
    if (!_moreTableView) {
        _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 590, KWIDTH, 450) style:UITableViewStylePlain];
        _moreTableView.tag = 200;
        _moreTableView.delegate = self;
        _moreTableView.dataSource = self;
        _moreTableView.rowHeight = 45;
        
        _moreTableView.hidden = YES;
    }
    return _moreTableView;
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 12;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        YKAddProjectPatientCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[YKAddProjectPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 3) {
            cell.manButton.hidden = NO;
            cell.womanButton.hidden = NO;
            cell.contentTextField.hidden = YES;
        }else{
            cell.manButton.hidden = YES;
            cell.womanButton.hidden = YES;
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
    };
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKAddProjectPatientCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKAddProjectPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.manButton.hidden = YES;
    cell.womanButton.hidden = YES;
    cell.addressBookButton.hidden = YES;
    
    cell.titleLabel.text = self.moreTitleArray[indexPath.row];
    cell.contentTextField.placeholder = self.morePlaceholderArray[indexPath.row];

    return cell;

}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark - Event

- (void)moreClick{
    if (_isShowMore) {
        [self.upButton setImage:[UIImage imageNamed:@"项目_向下"] forState:UIControlStateNormal];
        _isShowMore = NO;
        
        self.scrollView.contentSize = CGSizeMake(KWIDTH, 590);
        self.scrollView.contentOffset = CGPointMake(0, 590 - (KHEIGHT - 64));
        self.moreTableView.hidden = YES;
    }else{
        [self.upButton setImage:[UIImage imageNamed:@"项目_向上"] forState:UIControlStateNormal];
        _isShowMore = YES;
 
        self.scrollView.contentSize = CGSizeMake(KWIDTH, 1040);
        self.scrollView.contentOffset = CGPointMake(0, 405);
        self.moreTableView.hidden = NO;
    }
}



@end
