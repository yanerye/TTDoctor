//
//  YKDoctorListVC.m
//  TTDoctor
//
//  Created by YK on 2020/8/25.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKDoctorListVC.h"
#import "CLTreeViewFirstLevelCell.h"
#import "CLTreeViewSecondLevelCell.h"
#import "CLTreeViewThirdLevelCell.h"
#import "CLTreeViewFirstLevelModel.h"
#import "CLTreeViewSecondLevelModel.h"
#import "CLTreeViewThirdLevelModel.h"
#import "CLTreeViewNode.h"

@interface YKDoctorListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray* dataArray; //保存全部数据的数组
@property(nonatomic, strong) NSArray *displayArray;   //保存要显示在界面上的数据的数组


@end

@implementation YKDoctorListVC

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"医生选择";
    [self getDoctorList];
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in self.dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}



- (void)getDoctorList{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *fullURL = @"https://cmcd.ttdoc.cn/sp/client/doctorTeam/list.do";
//    NSString *fullURL = @"http://192.168.1.117:8080/cmcd-sp/client/doctorTeam/list.do";

    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:fullURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *firstDict in responseObject) {
            NSMutableArray *firstArr = [[NSMutableArray alloc] init];
            NSArray *secondArray = firstDict[@"children"];
            for (NSDictionary *secondDict in secondArray) {
                NSMutableArray *secondArr = [[NSMutableArray alloc] init];
                NSArray *thirdArray = secondDict[@"children"];
                for (NSDictionary *thirdDict in thirdArray) {
                    //第三层数据
                    CLTreeViewNode *node3 = [[CLTreeViewNode alloc]init];
                    node3.type = 2;
                    node3.isExpanded = FALSE;
                    CLTreeViewThirdLevelModel *tmp3 =[[CLTreeViewThirdLevelModel alloc]init];
                    tmp3.name = [NSString stringWithFormat:@"%@",thirdDict[@"name"]];
                    tmp3.dept = [NSString stringWithFormat:@"%@",thirdDict[@"iconClose"]];
                    tmp3.hospital = [NSString stringWithFormat:@"%@",thirdDict[@"code"]];
                    node3.nodeData = tmp3;
                    [secondArr addObject:node3];
                }
                //第二层数据
                CLTreeViewNode *node2 = [[CLTreeViewNode alloc]init];
                node2.type = 1;
                node2.isExpanded = FALSE;
                CLTreeViewSecondLevelModel *tmp2 =[[CLTreeViewSecondLevelModel alloc]init];
                tmp2.name = [NSString stringWithFormat:@"%@",secondDict[@"name"]];
                node2.nodeData = tmp2;
                [firstArr addObject:node2];
                node2.sonNodes = secondArr;
            }
            //第一层数据
            CLTreeViewNode *node1 = [[CLTreeViewNode alloc]init];
            node1.type = 0;
            node1.isExpanded = FALSE;
            CLTreeViewFirstLevelModel *tmp1 =[[CLTreeViewFirstLevelModel alloc]init];
            tmp1.name = [NSString stringWithFormat:@"%@",firstDict[@"name"]];
            node1.nodeData = tmp1;
            node1.sonNodes = firstArr;
            [self.dataArray addObject:node1];
        }
        
        [self reloadDataForDisplayArray];//初始化将要显示的数据

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];

    }
    return _tableView;
    
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        return 50;
    }else if(node.type == 1){//类型为1的cell
        return 50;
    }
    return 66;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)

//    if (node.type == 0) {
//        CLTreeViewFirstLevelCell *cell = (CLTreeViewFirstLevelCell*)[tableView cellForRowAtIndexPath:indexPath];
//        if(cell.node.isExpanded ){
//            [self rotateFirstArrow:cell with:M_PI_2];
//        }
//        else{
//            [self rotateFirstArrow:cell with:0];
//        }
//
//    }else if (node.type == 1){
//        CLTreeViewSecondLevelCell *cell = (CLTreeViewSecondLevelCell*)[tableView cellForRowAtIndexPath:indexPath];
//        if(cell.node.isExpanded ){
//            [self rotateSecondArrow:cell with:M_PI_2];
//        }
//        else{
//            [self rotateSecondArrow:cell with:0];
//        }
//    }else{
//        CLTreeViewThirdLevelCell *cell = (CLTreeViewThirdLevelCell*)[tableView cellForRowAtIndexPath:indexPath];
//        if(cell.node.isExpanded ){
//            cell.leftImageView.image = [UIImage imageNamed:@"服务设置_选中"];
//        }
//        else{
//            cell.leftImageView.image = [UIImage imageNamed:@"服务设置_未选"];
//        }
//    }
}

//-(void) rotateFirstArrow:(CLTreeViewFirstLevelCell*) cell with:(double)degree{
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.rightImageView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
//    } completion:NULL];
//}
//
//-(void) rotateSecondArrow:(CLTreeViewSecondLevelCell*) cell with:(double)degree{
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.rightImageView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
//    } completion:NULL];
//}


-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in self.dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        if(cnt == row){
                            node3.isExpanded = !node3.isExpanded;
                        }
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeViewFirstLevelCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[CLTreeViewFirstLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeViewSecondLevelCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if (cell == nil) {
            cell = [[CLTreeViewSecondLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier1];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else{//类型为2的cell
        CLTreeViewThirdLevelCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if (cell == nil) {
            cell = [[CLTreeViewThirdLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
}


-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeViewFirstLevelModel *nodeData = node.nodeData;
        ((CLTreeViewFirstLevelCell*)cell).nameLabel.text = nodeData.name;
        if (!node.isExpanded) {
            ((CLTreeViewFirstLevelCell*)cell).rightImageView.image = [UIImage imageNamed:@"icon_right"];
        }else{
            ((CLTreeViewFirstLevelCell*)cell).rightImageView.image = [UIImage imageNamed:@"项目_向下"];
        }
    }else if(node.type == 1){
        CLTreeViewSecondLevelModel *nodeData = node.nodeData;
        ((CLTreeViewSecondLevelCell*)cell).nameLabel.text = nodeData.name;
        if (!node.isExpanded) {
            ((CLTreeViewSecondLevelCell*)cell).rightImageView.image = [UIImage imageNamed:@"icon_right"];
        }else{
            ((CLTreeViewSecondLevelCell*)cell).rightImageView.image = [UIImage imageNamed:@"项目_向下"];
        }
    }else{
        CLTreeViewThirdLevelModel *nodeData = node.nodeData;
        ((CLTreeViewThirdLevelCell*)cell).nameLabel.text = nodeData.name;
        ((CLTreeViewThirdLevelCell*)cell).deptLabel.text = nodeData.dept;
        ((CLTreeViewThirdLevelCell*)cell).hospitalLabel.text = nodeData.hospital;
        if (!node.isExpanded) {
            ((CLTreeViewThirdLevelCell*)cell).leftImageView.image = [UIImage imageNamed:@"服务设置_未选"];
        }else{
            ((CLTreeViewThirdLevelCell*)cell).leftImageView.image = [UIImage imageNamed:@"服务设置_选中"];
        }
    }
}

@end
