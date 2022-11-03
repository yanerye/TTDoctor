//
//  YKBaseVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/5.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"
#import "MJRefresh.h"

@interface YKBaseVC ()

@end

@implementation YKBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(@available(iOS 15.0,*)){
        UINavigationBarAppearance *apperance=[[UINavigationBarAppearance alloc]init];
        //设置背景色
        apperance.backgroundColor = COMMONCOLOR;
        //设置标题字体
        [apperance setTitleTextAttributes:@{
          NSFontAttributeName:[UIFont systemFontOfSize:17],
          NSForegroundColorAttributeName:[UIColor whiteColor]
        }];
        //分割线去除
        apperance.shadowColor = [UIColor clearColor];
        //重新赋值
        self.navigationController.navigationBar.standardAppearance = apperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    }else{
        //设置标题字体
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:19], NSFontAttributeName, nil];
        //设置背景色
        self.navigationController.navigationBar.barTintColor = COMMONCOLOR;
        //去掉分割线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)addLeftBackNavigationItemWithImageName:(NSString *)imageName{
    UIView *left = self.navigationItem.leftBarButtonItem.customView;
    if ([left isKindOfClass:[UIButton class]]) {
        UIButton *temp = (UIButton *)left;
        [temp setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigationBack) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 24, 44);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
}

- (void)addLeftCloseNavigationItemWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationClose) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 44);
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem, leftBarItem];
}

- (void)navigationBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationClose {
    if (self.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    // 如果viewController不是导航控制器的第1个子控制器
//    if (self.childViewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return self.childViewControllers.count > 1;
//}

- (void)createRefreshWithTableView:(UITableView *)table{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector((startRefresh))];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading4_%zd", i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStateIdle];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    table.mj_header = header;
    [table.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector((startRefresh))];
    table.mj_footer = footer;
}

- (void)startRefresh{
    
}



@end
