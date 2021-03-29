//
//  YKUserInfoCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/18.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKUserInfoCell.h"

#define TEXTFONT [UIFont systemFontOfSize:14]


@implementation YKUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.userImageView];
    [self addSubview:self.detailLabel];
    [self addSubview:self.rightImageView];

    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-35);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-35);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
    }];
}

#pragma mark - init

- (UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [UIImageView new];
        _userImageView.backgroundColor = [UIColor lightGrayColor];
        _userImageView.layer.cornerRadius = 25.5;
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = TEXTFONT;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = TEXTFONT;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [UIImage imageNamed:@"icon_right"];
    }
    return _rightImageView;
}

@end
