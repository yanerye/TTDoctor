//
//  YKProjectDetailCell.h
//  TTDoctor
//
//  Created by YK on 2020/6/24.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKProjectDetailCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;//头像
@property (nonatomic, strong) UILabel *nameImageLabel;//姓氏
@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UILabel *centerCodeLabel;//中心编码
@property (nonatomic, strong) UILabel *detailLabel;// 队列号 病例随机号 患者编码
@property (nonatomic, strong) UIImageView *dropImageView;//脱落标志

@end


