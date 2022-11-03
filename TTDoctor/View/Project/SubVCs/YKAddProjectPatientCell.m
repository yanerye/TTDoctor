//
//  YKAddProjectPatientCell.m
//  TTDoctor
//
//  Created by YK on 2020/7/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAddProjectPatientCell.h"
#import "BFCButton.h"

#define TEXTFONT 14

@implementation YKAddProjectPatientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentTextField];
    [self addSubview:self.addressBookButton];
    [self addSubview:self.rightImageView];
    [self addSubview:self.unitLabel];
//    [self addSubview:self.sexView];


    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(128, 25));
    }];
    
    [self.addressBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self).offset(6);
        make.width.mas_equalTo(60);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
//    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self);
//        make.left.mas_equalTo(self.titleLabel.mas_right);
//    }];
}

#pragma mark - init

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    }
    return _titleLabel;
}

- (UITextField *)contentTextField{
    if (!_contentTextField) {
        _contentTextField = [UITextField new];
        _contentTextField.font = [UIFont systemFontOfSize:TEXTFONT];
    }
    return _contentTextField;
}

- (UIButton *)addressBookButton{
    if (!_addressBookButton) {
        _addressBookButton = [UIButton new];
        _addressBookButton.backgroundColor = RGBACOLOR(235, 235, 235);
        [_addressBookButton setTitle:@"通讯录" forState:UIControlStateNormal];
        [_addressBookButton setTitleColor:RGBACOLOR(94, 94, 94) forState:UIControlStateNormal];
        _addressBookButton.layer.cornerRadius = 4;
        _addressBookButton.titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
        _addressBookButton.hidden = YES;
    }
    return _addressBookButton;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [UIImage imageNamed:@"icon_right"];
        _rightImageView.hidden = YES;
    }
    return _rightImageView;
}

- (UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [UILabel new];
        _unitLabel.font = [UIFont systemFontOfSize:TEXTFONT];
        _unitLabel.hidden = YES;
    }
    return _unitLabel;
}

    
//- (UIView *)sexView{
//    if (!_sexView) {
//        _sexView = [UIView new];
//
//        BFCButton *manButton = [BFCButton buttonWithType:UIButtonTypeCustom];
//        manButton.tag = 1;
//        [manButton addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
//        manButton.alignType = BFCButtonAlignTypeTextRight;
//        [manButton setImage:[UIImage imageNamed:@"服务设置_未选"] forState:UIControlStateNormal];
//        [manButton setTitle:@"男" forState:UIControlStateNormal];
//        manButton.titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
//        [manButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        manButton.imageviewRatio = 0.8;
//        [_sexView addSubview:manButton];
//
//        BFCButton *womenButton = [BFCButton buttonWithType:UIButtonTypeCustom];
//        womenButton.tag = 2;
//        [womenButton addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
//        womenButton.alignType = BFCButtonAlignTypeTextRight;
//        [womenButton setImage:[UIImage imageNamed:@"服务设置_未选"] forState:UIControlStateNormal];
//        [womenButton setTitle:@"女" forState:UIControlStateNormal];
//        womenButton.titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
//        [womenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        womenButton.imageviewRatio = 0.8;
//        [_sexView addSubview:womenButton];
//
//        [manButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_sexView);
//            make.left.mas_equalTo(_sexView);
//            make.width.mas_equalTo(50);
//        }];
//
//        [womenButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_sexView);
//            make.left.mas_equalTo(manButton.mas_right).offset(20);
//            make.width.mas_equalTo(50);
//        }];
//    }
//    return _sexView;
//}
    
@end
