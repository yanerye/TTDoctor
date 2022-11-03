//
//  YKAlertHelper.m
//  TTDoctor
//
//  Created by YK on 2020/6/15.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKAlertHelper.h"
#import <Toast/UIView+Toast.h>

@implementation YKAlertHelper


+ (void)showErrorMessage:(NSString *)message inView:(UIView *)view{
    CSToastStyle *style = [[CSToastStyle alloc]initWithDefaultStyle];
    style.backgroundColor = [UIColor blackColor];
    [view makeToast:message duration:1 position:CSToastPositionCenter style:style];
       
}

@end
