//
//  YKLoginCell.m
//  TTDoctor
//
//  Created by YK on 2020/6/9.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKLoginCell.h"

#define textFont 14


@implementation YKLoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentTextField];
    [self addSubview:self.graphicCodeImageView];
    [self addSubview:self.codeButton];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(14);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(10);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(110);
//        make.width.mas_equalTo(150);
    }];
    
    [self.graphicCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(80);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
}
#pragma mark - init

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:textFont];
    }
    return _titleLabel;
}

- (UITextField *)contentTextField{
    if (!_contentTextField) {
        _contentTextField = [UITextField new];
        _contentTextField.font = [UIFont systemFontOfSize:textFont];
    }
    return _contentTextField;
}

- (UIImageView *)graphicCodeImageView{
    if (!_graphicCodeImageView) {
        _graphicCodeImageView = [UIImageView new];
        _graphicCodeImageView.backgroundColor = [UIColor cyanColor];
    }
    return _graphicCodeImageView;
}

- (UIButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [UIButton new];
        _codeButton.backgroundColor = COMMONCOLOR;
        _codeButton.layer.cornerRadius = 8;
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:textFont];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

#pragma mark - event

- (void)codeClick{
    
}

@end
