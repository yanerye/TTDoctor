//
//  YKPatientCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/17.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKPatientCell.h"

@implementation YKPatientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagesLabel];
    [self addSubview:self.phoneImageView];
    [self addSubview:self.phoneLabel];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).offset(-4);
        make.left.mas_equalTo(self).offset(70);
    }];
    
    [self.tagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(40);
    }];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(4);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.phoneImageView);
        make.left.mas_equalTo(self.phoneImageView.mas_right).offset(4);
    }];
    

}

#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.layer.cornerRadius = 22.5;
        _leftImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBACOLOR(51, 51, 51);
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)tagesLabel{
    if (!_tagesLabel) {
        _tagesLabel = [UILabel new];
        _tagesLabel.textColor = RGBACOLOR(51, 51, 51);
        _tagesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tagesLabel;
}


- (UIImageView *)phoneImageView{
    if (!_phoneImageView) {
        _phoneImageView = [UIImageView new];
        _phoneImageView.image = [UIImage imageNamed:@"患者_小电话"];
    }
    return _phoneImageView;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.textColor = RGBACOLOR(102, 102, 102);
        _phoneLabel.font = [UIFont systemFontOfSize:14];
    }
    return _phoneLabel;
}



@end
