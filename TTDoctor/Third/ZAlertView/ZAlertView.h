//
//  ZAlertView.h
//  顶部提示
//
//  Created by YYKit on 2017/5/27.
//  Copyright © 2017年 YZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZAlertView : UIView

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel  *tipsLabel;
@property (nonatomic,strong) UILabel  *nameLabel;
@property (nonatomic,strong) UILabel  *timeLabel;

- (instancetype)init;
- (void)topAlertViewTypewWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time;
- (void)show;
- (void)dismiss;
@end

