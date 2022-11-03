//
//  YKMyQuestionnaireCell.m
//  TTDoctor
//
//  Created by YK on 2020/7/21.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKMyQuestionnaireCell.h"

@implementation YKMyQuestionnaireCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numberLabel];
    [self addSubview:self.seleceButton];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(12);
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(9);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-10);
        make.left.mas_equalTo(self.titleLabel);
    }];
    
    [self.seleceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(50);
    }];
}

#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [UIImage imageNamed:@"questionaire_pc"];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(32, 32, 32);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.textColor = RGBACOLOR(94, 94, 94);
        _numberLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numberLabel;
}

- (UIButton *)seleceButton{
    if (!_seleceButton) {
        _seleceButton = [UIButton new];
    }
    return _seleceButton;
}

#pragma mark - init

- (void)setQuestionnaireDict:(NSMutableDictionary *)questionnaireDict{
    _questionnaireDict = questionnaireDict;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",_questionnaireDict[@"masterQuestionName"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@次使用",_questionnaireDict[@"targetNum"]];
}

@end
