//
//  YKHUDHelper.m
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKHUDHelper.h"
#import "MBProgressHUD.h"

@implementation YKHUDHelper

+ (void)showHUDInView:(UIView *)view {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];

}

+ (void)hideHUDInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
