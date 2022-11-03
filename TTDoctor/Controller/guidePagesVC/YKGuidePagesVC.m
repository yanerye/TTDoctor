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
//    [self swapWithA:8 b:10];
//   [self maxCommonWithA:18 b:27];
//    [self maxCommon2WithA:20 b:8];
//    [self primeWithA:2047];
}

- (void)swapWithA:(int)a b:(int)b{
    int temp = a;
    a = b;
    b = temp;
    NSLog(@"%d=======%d",a, b);
}

- (void)maxCommon1WithA:(int)a b:(int)b{
    int max = 0;
    for (int i = 1; i < a; i ++) {
        if (a % i == 0 && b % i == 0) {
            max = i;
        }
    }
    NSLog(@"输出是=======%d", max);
}

- (void)maxCommon2WithA:(int)a b:(int)b{
    int r = 0;
    while (a % b > 0) {
        r = a % b;
        a = b;
        b = r;
    }
    NSLog(@"最终的结果是=====%d", r);
}

- (void)primeWithA:(int)a{
    for (int i = 2; i < sqrt(a); i ++ ) {
        NSLog(@"%d",i);
        if (a % i == 0) {
            NSLog(@"不是质数");
            return;
        }
    }
    NSLog(@"是质数");
}

- (void)createGuidePages{
    NSArray *nameArray = [NSArray new];
    if (!isNotch){
        nameArray = @[@"guide1_1334", @"guide2_1334", @"guide3_1334",@"guide4_1334"];
    }else{
        nameArray = @[@"guide1_2208", @"guide2_2208", @"guide3_2208",@"guide4_2208"];
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
