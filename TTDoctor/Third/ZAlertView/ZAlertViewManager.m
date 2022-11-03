//
//  ZAlertViewManager.m
//  顶部提示
//
//  Created by YYKit on 2017/5/27.
//  Copyright © 2017年 YZ. All rights reserved.
//

#import "ZAlertViewManager.h"
@interface ZAlertViewManager ()
{
    NSInteger dismisstime;

}
@property (nonatomic,strong) NSTimer *dismisTimer;
@end

@implementation ZAlertViewManager

#pragma mark 创建伪单例，确保弹窗的唯一性
+ (ZAlertViewManager *)shareManager
{
    static ZAlertViewManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[ZAlertViewManager alloc]init];
        shareManager.alertView = [[ZAlertView alloc]init];
        shareManager.alertView.userInteractionEnabled = YES;
    });
    return shareManager;
}

#pragma mark 显示弹窗
- (void)showWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time
{
    dismisstime = 0;//将时间重置为0
    [self releaseTimer];//销毁定时器
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
        [self.alertView topAlertViewTypewWithTitle:title content:content time:time];
        [self.alertView show];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAlertView)];
        tap.cancelsTouchesInView = NO;
        [self.alertView addGestureRecognizer:tap];
    
       UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertImmediately)];
       [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
       [self.alertView addGestureRecognizer:recognizer];
    });
}



#pragma mark 立即移除弹窗
- (void)dismissAlertImmediately
{
    [self releaseTimer];
    [self.alertView dismiss];
}

#pragma mark 延迟移除弹窗
- (void)dismissAlertWithTime:(NSInteger)time
{
    self.dismissTime = time;
    self.dismisTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(dismisAlertWithTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)dismisAlertWithTimer:(NSTimer *)timer
{
    if (dismisstime >= self.dismissTime)
    {
        [self releaseTimer];
        [self.alertView dismiss];
    }
    dismisstime += 1;
}

#pragma mark 释放定时器对象
- (void)releaseTimer
{
    [self.dismisTimer invalidate];
}

#pragma mark block
- (void)tapAlertView
{
    [self.alertView dismiss];
    dismisstime = 0;//将时间重置为0
    [self.dismisTimer invalidate];//销毁定时器
    self.didselectedAlertViewBlock();
}
- (void)didSelectedAlertViewWithBlock:(SelectedAlertView)didselectedAlertViewBlock
{
    self.didselectedAlertViewBlock = didselectedAlertViewBlock;
}
@end

