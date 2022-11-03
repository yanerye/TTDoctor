//
//  YKTagCell.m
//  TTDoctor
//
//  Created by YK on 2021/10/9.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKTagCell.h"

@implementation YKTagCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}


- (void)layoutAllSubviews{
    [self addSubview:self.tagLabel];

    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self);

    }];
}

#pragma mark - init

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = RGBACOLOR(51, 51, 51);
        _tagLabel.font = [UIFont systemFontOfSize:14];
        _tagLabel.clipsToBounds = YES;
        _tagLabel.layer.borderColor = COMMONCOLOR.CGColor;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.cornerRadius = 6;
    }
    return _tagLabel;
}



@end
