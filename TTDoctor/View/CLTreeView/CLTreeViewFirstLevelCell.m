//
//  CLTreeViewFirstLevelCell.m
//  TTDoctor
//
//  Created by YK on 2020/8/25.
//  Copyright © 2020 YK. All rights reserved.
//

#import "CLTreeViewFirstLevelCell.h"

@implementation CLTreeViewFirstLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightImageView];

    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
    }];

}

#pragma mark - init


- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [UIImage imageNamed:@"icon_right"];
    }
    return _rightImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}


@end
