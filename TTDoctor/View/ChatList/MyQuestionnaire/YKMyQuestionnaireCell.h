//
//  YKMyQuestionnaireCell.h
//  TTDoctor
//
//  Created by YK on 2020/7/21.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMyQuestionnaireCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *seleceButton;

@property (nonatomic, strong) NSMutableDictionary *questionnaireDict;

@end


