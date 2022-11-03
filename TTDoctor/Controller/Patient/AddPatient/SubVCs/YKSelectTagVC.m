//
//  YKSelectTagVC.m
//  TTDoctor
//
//  Created by YK on 2021/10/20.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKSelectTagVC.h"
#import "YKTagCell.h"
#import "YKManageTagVC.h"

#define K_Cell @"cell"

@interface YKSelectTagVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectedTagNamesArray;
@property (nonatomic, strong) NSMutableArray *selectedTagIdsArray;


@end

@implementation YKSelectTagVC

- (NSMutableArray *)selectedTagNamesArray{
    if (!_selectedTagNamesArray) {
        _selectedTagNamesArray = [[NSMutableArray alloc] init];
    }
    return _selectedTagNamesArray;
}

- (NSMutableArray *)selectedTagIdsArray{
    if (!_selectedTagIdsArray) {
        _selectedTagIdsArray = [[NSMutableArray alloc] init];
    }
    return _selectedTagIdsArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPatientTagList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择标签";
    [self layoutAllSubviews];
    [self createRightButtonItems];
}

- (void)createRightButtonItems{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [doneButton setTitle:@"设置" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [doneButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = right2;
}


- (void)layoutAllSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.doneButton];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];

}

- (void)getPatientTagList{
    [YKHUDHelper showHUDInView:self.view];
    
    [[YKBaseApiSeivice service] getPatientListWithCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            [YKHUDHelper hideHUDInView:self.view];
            self.dataArray = responseObject[@"rows"];
            [self.collectionView reloadData];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];

}

#pragma mark - init

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //给集合视图注册一个cell
        [_collectionView registerClass:[YKTagCell class] forCellWithReuseIdentifier:K_Cell];
                
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置每个图片的大小
        _flowLayout.itemSize = CGSizeMake(KWIDTH / 3, 45);
        //设置行间距
        _flowLayout.minimumLineSpacing = 0;
        //设置列间距
        _flowLayout.minimumInteritemSpacing = 0;
        //设置滚动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    }
    return _flowLayout;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton new];
        _doneButton.backgroundColor = COMMONCOLOR;
        [_doneButton setTitle:@"确认完成" forState:UIControlStateNormal];
        _doneButton.clipsToBounds = YES;
        _doneButton.layer.cornerRadius = 10;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


//创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YKTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_Cell forIndexPath:indexPath];
    if (!cell) {
        cell = [[YKTagCell alloc] initWithFrame:CGRectMake(0,0, KWIDTH / 3, 45)];
    }
    
    NSDictionary *tagDict = self.dataArray[indexPath.row];
    cell.tagLabel.text = [NSString stringWithFormat:@"%@",tagDict[@"labelName"]];
    cell.tag = indexPath.row;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YKTagCell *cell = (YKTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *tagDict = self.dataArray[indexPath.row];
    NSString *tagNameStr = [NSString stringWithFormat:@"%@",tagDict[@"labelName"]];
    NSString *tagIdStr = [NSString stringWithFormat:@"%@",tagDict[@"id"]];
    if (cell.isSelected) {
        cell.isSelected = NO;
        cell.tagLabel.backgroundColor = [UIColor whiteColor];
        cell.tagLabel.textColor = RGBACOLOR(51, 51, 51);
        [self.selectedTagNamesArray removeObject:tagNameStr];
        [self.selectedTagIdsArray removeObject:tagIdStr];
    }else{
        cell.isSelected = YES;
        cell.tagLabel.backgroundColor = COMMONCOLOR;
        cell.tagLabel.textColor = [UIColor whiteColor];
        [self.selectedTagNamesArray addObject:tagNameStr];
        [self.selectedTagIdsArray addObject:tagIdStr];
    }
}


#pragma mark - Event

- (void)doneClick{
    NSString *tagIDString = [self.selectedTagIdsArray componentsJoinedByString:@","];
    NSString *tagNameString = [self.selectedTagNamesArray componentsJoinedByString:@","];
    
    if (self.block) {
        self.block(tagIDString, tagNameString);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setClick{
    YKManageTagVC *tagVC = [[YKManageTagVC alloc] init];
    [self.navigationController pushViewController:tagVC animated:YES];
}

@end

