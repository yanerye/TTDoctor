//
//  YKHomeCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/16.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKHomeCell.h"

@implementation YKHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.nameLabel];
    [self addSubview:self.projectLabel];
    [self addSubview:self.stageLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(14);
        make.left.mas_equalTo(self).offset(15);
    }];
    
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(14.5);
    }];
    
    [self.stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameLabel);
    }];
}

#pragma mark - init

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBACOLOR(51, 51, 51);
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)projectLabel{
    if (!_projectLabel) {
        _projectLabel = [UILabel new];
        _projectLabel.textColor = RGBACOLOR(51, 51, 51);
        _projectLabel.font = [UIFont systemFontOfSize:15];
    }
    return _projectLabel;
}

- (UILabel *)stageLabel{
    if (!_stageLabel) {
        _stageLabel = [UILabel new];
        _stageLabel.textColor = RGBACOLOR(153, 153, 153);
        _stageLabel.font = [UIFont systemFontOfSize:13];
    }
    return _stageLabel;
}



@end
