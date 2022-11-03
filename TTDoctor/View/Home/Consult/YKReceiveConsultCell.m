//
//  YKReceiveConsultCell.m
//  TTDoctor
//
//  Created by mac on 2022/5/20.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKReceiveConsultCell.h"

@implementation YKReceiveConsultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.doctorLabel];
    [self addSubview:self.dateLabel];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(15);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(35);
    }];
    
    [self.doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameLabel);
    }];
 
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.doctorLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameLabel);
    }];
}

#pragma mark - init

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = RGBACOLOR(51, 51, 51);
        _nameLabel.text = @"哈哈哈";
    }
    return _nameLabel;;
}


- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.textColor = RGBACOLOR(102, 102, 102);
        _infoLabel.text = @"男 11岁 胃病";
    }
    return _infoLabel;;
}

- (UILabel *)doctorLabel{
    if (!_doctorLabel) {
        _doctorLabel = [UILabel new];
        _doctorLabel.font = [UIFont systemFontOfSize:13];
        _doctorLabel.textColor = RGBACOLOR(153, 153, 153);
        _doctorLabel.text = @"申请医生:张铁林 | 136666666666";

    }
    return _doctorLabel;;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = RGBACOLOR(153, 153, 153);
        _dateLabel.text = @"预约会诊时间:2020-05-24 18:40";

    }
    return _dateLabel;;
}

@end
