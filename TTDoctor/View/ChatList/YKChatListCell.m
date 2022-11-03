//
//  YKChatListCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/18.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatListCell.h"

@implementation YKChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.redView];
    [self addSubview:self.numberLabel];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).offset(-8);
        make.left.mas_equalTo(self).offset(70);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(8);
        make.left.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(150);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(18);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.timeLabel);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.redView);
    }];
    
    
}

#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.layer.cornerRadius = 22.5;
    }
    return _leftImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textColor = RGBACOLOR(153, 153, 153);
        _messageLabel.font = [UIFont systemFontOfSize:13];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGBACOLOR(153, 153, 153);
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (UIView *)redView{
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 11;
    }
    return _redView;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numberLabel;
}


@end
