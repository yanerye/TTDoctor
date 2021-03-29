//
//  YKProjectDetailCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/24.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKProjectDetailCell.h"

@implementation YKProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameImageLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.centerCodeLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.dropImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.leftImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).offset(-7);
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(8);
    }];
    
    [self.centerCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(7);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerCodeLabel);
        make.left.mas_equalTo(self.centerCodeLabel).offset(60);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.dropImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
}

#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [UIImage imageNamed:@"空白圆"];
    }
    return _leftImageView;;
}

- (UILabel *)nameImageLabel{
    if (!_nameImageLabel) {
        _nameImageLabel = [UILabel new];
        _nameImageLabel.font = [UIFont systemFontOfSize:28];
        _nameImageLabel.textColor = RGBACOLOR(182, 182, 184);
    }
    return _nameImageLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)centerCodeLabel{
    if (!_centerCodeLabel) {
        _centerCodeLabel = [UILabel new];
        _centerCodeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _centerCodeLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:11];
    }
    return _detailLabel;
}

- (UIImageView *)dropImageView{
    if (!_dropImageView) {
        _dropImageView = [UIImageView new];
        _dropImageView.image = [UIImage imageNamed:@"项目_脱落"];
    }
    return _dropImageView;;
}

@end
