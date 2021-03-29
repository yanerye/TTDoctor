//
//  YKServiceSettingCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/23.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKServiceSettingCell.h"

@implementation YKServiceSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.settingLabel];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.mas_centerY).offset(-3);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.mas_centerY).offset(3);
        make.width.mas_equalTo(240);
    }];
    
    [self.settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
}

#pragma mark - init


- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = RGBACOLOR(151, 151, 151);
    }
    return _detailLabel;
}

- (UILabel *)settingLabel{
    if (!_settingLabel) {
        _settingLabel = [UILabel new];
        _settingLabel.font = [UIFont systemFontOfSize:16];
        _settingLabel.textColor = [UIColor blackColor];
    }
    return _settingLabel;
}

@end
