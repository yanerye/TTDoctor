//
//  YKAnnouncementCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/17.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAnnouncementCell.h"

#define TEXTFONT 15

@implementation YKAnnouncementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(7);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [UIImage imageNamed:@"home_horn"];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(121, 121, 121);
        _titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGBACOLOR(169, 169, 169);
        _timeLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    }
    return _timeLabel;
}


@end
