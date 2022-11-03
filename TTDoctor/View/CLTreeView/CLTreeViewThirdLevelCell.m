//
//  CLTreeViewThirdLevelCell.m
//  TTDoctor
//
//  Created by YK on 2020/8/25.
//  Copyright © 2020 YK. All rights reserved.
//

#import "CLTreeViewThirdLevelCell.h"

@implementation CLTreeViewThirdLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.deptLabel];
    [self addSubview:self.hospitalLabel];

    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).offset(-5);
        make.left.mas_equalTo(self).offset(110);
    }];
    
    [self.deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
    }];
    
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(5);
        make.left.mas_equalTo(self.nameLabel);
    }];
}

#pragma mark - init


- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = RGBACOLOR(51, 51, 51);
    }
    return _nameLabel;
}

- (UILabel *)deptLabel{
    if (!_deptLabel) {
        _deptLabel = [UILabel new];
        _deptLabel.font = [UIFont systemFontOfSize:13.25];
        _deptLabel.textColor = COMMONCOLOR;
    }
    return _deptLabel;
}

- (UILabel *)hospitalLabel{
    if (!_hospitalLabel) {
        _hospitalLabel = [UILabel new];
        _hospitalLabel.font = [UIFont systemFontOfSize:13.25];
        _hospitalLabel.textColor = RGBACOLOR(153, 153, 153);
    }
    return _hospitalLabel;
}


@end
