//
//  YKBaseNaviVC.m
//  TTDoctor
//
//  Created by mac on 2022/11/2.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKBaseNaviVC.h"

@interface YKBaseNaviVC ()<UIGestureRecognizerDelegate>

@end

@implementation YKBaseNaviVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.interactivePopGestureRecognizer.delegate = self;
    [self clearNavigationBar];
}

- (void)clearNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 如果viewController不是导航控制器的第1个子控制器
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
}


@end
