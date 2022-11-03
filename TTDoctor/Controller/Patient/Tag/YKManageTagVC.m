//
//  YKManageTagVC.m
//  TTDoctor
//
//  Created by YK on 2021/10/20.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKManageTagVC.h"
#import "YKTagCell.h"
#import "YKModifyTagVC.h"

#define K_Cell @"cell"

@interface YKManageTagVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation YKManageTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"标签管理";
    [self layoutAllSubviews];
    [self getPatientTagList];
}


- (void)layoutAllSubviews {
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.collectionView];

    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottom);
        make.height.mas_equalTo(44);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
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
        _flowLayout.itemSize = CGSizeMake(KWIDTH / 2, 60);
        //设置行间距
        _flowLayout.minimumLineSpacing = 0;
        //设置列间距
        _flowLayout.minimumInteritemSpacing = 0;
        //设置滚动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    }
    return _flowLayout;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COMMONCOLOR;
        [_bottomView addSubview:lineView];
        
        UIButton *addButton = [UIButton new];
        [addButton setImage:[UIImage imageNamed:@"patient_tag_add"] forState:UIControlStateNormal];
        [_bottomView addSubview:addButton];
        
        [addButton addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(_bottomView);
            make.height.mas_equalTo(1);
        }];
        
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_bottomView);
        }];
    }
    return _bottomView;
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
        cell = [[YKTagCell alloc] initWithFrame:CGRectMake(0,0, KWIDTH / 2, 60)];
    }
    
    NSDictionary *tagDict = self.dataArray[indexPath.row];
    cell.tagLabel.text = [NSString stringWithFormat:@"%@(%@人)",tagDict[@"labelName"],tagDict[@"labelPatientNum"]];
    cell.tag = indexPath.row;
    
    //长按删除操作
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.0;
    longPress.delegate = self;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    YKModifyTagVC *modifyVC = [[YKModifyTagVC alloc] init];
    modifyVC.titleString = @"修改标签";
    modifyVC.contentStr = [NSString stringWithFormat:@"%@",dict[@"labelName"]];
    modifyVC.tagId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    modifyVC.block = ^{
        [self getPatientTagList];
    };
    [self.navigationController pushViewController:modifyVC animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)longPress:(UILongPressGestureRecognizer *)longtap{
    YKTagCell *tagCell = (YKTagCell *)longtap.view;
    if (longtap.state == UIGestureRecognizerStateBegan) {
        NSDictionary *dict = self.dataArray[tagCell.tag];
        NSString *tagId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        if ([dict[@"labelPatientNum"] intValue] > 0) {
            [YKAlertHelper showErrorMessage:@"此标签中已有患者,不能删除" inView:self.view];
        }else{
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除此标签么" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cacelAction];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[YKBaseApiSeivice service] deletePatientTagWithTagId:tagId completion:^(id responseObject, NSError *error) {
                    if (!error) {
                        [self getPatientTagList];
                    }else{
                        [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
                    }
                }];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if (longtap.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark - Event

- (void)addTag{
    YKModifyTagVC *modifyVC = [[YKModifyTagVC alloc] init];
    modifyVC.titleString = @"添加标签";
    modifyVC.contentStr = @"";
    modifyVC.block = ^{
        [self getPatientTagList];
    };
    [self.navigationController pushViewController:modifyVC animated:YES];
}

@end

