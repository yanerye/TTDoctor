//
//  ZAlertView.m
//  顶部提示
//
//  Created by YYKit on 2017/5/27.
//  Copyright © 2017年 YZ. All rights reserved.
//

#import "ZAlertView.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width

#define RGBACOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@implementation ZAlertView

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 42, 42)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 21;
        _iconImageView.image = [UIImage imageNamed:@"通知_logo"];
    }
    return _iconImageView;
}

- (UILabel *)tipsLabel
{
    if (_tipsLabel == nil)
    {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = RGBACOLOR(51, 51, 51);
        _tipsLabel.frame = CGRectMake(78, 18, 100, 20);
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(78, 45, 100, 20);
        _nameLabel.textColor = RGBACOLOR(140, 140, 140);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil)
    {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = RGBACOLOR(153, 153, 153);
        _timeLabel.frame = CGRectMake(Screen_Width - 15 - 100 - 20, 18, 100, 20);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}



#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAlert)];
        [tap setCancelsTouchesInView:NO];
        [self addGestureRecognizer:tap];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)removeAlert
{
    [self dismiss];
}

#pragma mark 设置type
- (void)topAlertViewTypewWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time
{
        self.frame = CGRectMake(10, 25, Screen_Width - 20, 76);
        self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.cornerRadius = 9.0;
        self.layer.shadowRadius = 9.0;
        self.backgroundColor = RGBACOLOR(250, 250, 250);
        self.tipsLabel.text = title;
        self.nameLabel.text = content;
        self.timeLabel.text = time;
}


#pragma mark 显示
- (void)show
{
    [UIView animateWithDuration:0.618f
                          delay:0
     usingSpringWithDamping:0.9f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(self.center.x, 63);
                         [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
                     }
                     completion:^(BOOL finished) {
                     }];

}

#pragma mark 移除
- (void)dismiss
{
    [UIView animateWithDuration:0.618f
                          delay:0
         usingSpringWithDamping:0.99f
          initialSpringVelocity:15.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(self.center.x, -38);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}


@end

