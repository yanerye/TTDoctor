//
//  YKGuidePagesVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/9.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKGuidePagesVC.h"
#import "YKLoginVC.h"

@interface YKGuidePagesVC ()

@end

@implementation YKGuidePagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createGuidePages];
}

- (void)createGuidePages{
    NSArray *nameArray = [NSArray new];
    if (iPhone8){
        nameArray = @[@"引导页1_1334", @"引导页2_1334", @"引导页3_1334",@"引导页4_1334"];
    }else{
        nameArray = @[@"引导页1_2208", @"引导页2_2208", @"引导页3_2208",@"引导页4_2208"];
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(KWIDTH*nameArray.count, KHEIGHT);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    for (int i = 0; i < nameArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nameArray[i]]];
        imageView.frame = CGRectMake(0 + i*KWIDTH, 0, KWIDTH, KHEIGHT);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [scrollView addSubview:imageView];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(KWIDTH * (nameArray.count - 1) + KWIDTH/2 - 45, KHEIGHT - 80, 90, 30);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 15;
    [button addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"进入应用" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollView addSubview:button];
}

- (void)toLogin{
    YKLoginVC *loginVC = [[YKLoginVC alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = navi;
}

@end
