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
    
    if (self.navigationController) {
        
        //导航栏后退图片
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
     
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        
        //去掉下方横线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:19], NSFontAttributeName, nil];
    self.navigationController.navigationBar.barTintColor = COMMONCOLOR;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

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
