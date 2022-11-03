//
//  YKAlertViewController.m
//  MyTestSDK
//
//  Created by YK on 2021/2/1.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKAlertViewController.h"

@interface YKAlertViewController ()

@property (nonatomic,   copy)NSString *titleText;
@property (nonatomic,   copy)NSString *contentText;
@property (nonatomic, strong)NSArray <ZHYAlertButtonItem *> *buttons;
@property (nonatomic, strong)UIView *whiteBG;

@property (nonatomic, strong)UIScrollView *contentScroll;
@property (nonatomic, strong)UILabel *contentLable;

@end

@implementation YKAlertViewController


- (instancetype)initWithAlertTitle:(NSString *)title contentText:(NSString *)contentText actionButtons:(NSArray <ZHYAlertButtonItem *> *)buttons {
    self = [super init];
    if (self) {
        self.titleText = title;
        self.contentText = contentText;
        self.buttons = buttons;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeSubViewsConstraint];
}

- (void)makeSubViewsConstraint {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.whiteBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 135)];
    _whiteBG.center = self.view.center;
    _whiteBG.backgroundColor = [UIColor whiteColor];
    _whiteBG.layer.masksToBounds = YES;
    _whiteBG.layer.cornerRadius = 7;
    [self.view addSubview:_whiteBG];
    
    
    CGFloat limit = 21;
    self.contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 30, _whiteBG.frame.size.width - 40, limit)];
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.showsVerticalScrollIndicator = NO;
    [_whiteBG addSubview:_contentScroll];
    
    self.contentLable = [[UILabel alloc] init];
    self.contentLable.numberOfLines = 0;
    self.contentLable.text = self.contentText;
    self.contentLable.backgroundColor = [UIColor clearColor];
    self.contentLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    self.contentLable.textColor = [UIColor blackColor];
    self.contentLable.textAlignment = NSTextAlignmentCenter;
    CGFloat height = [self.contentLable sizeThatFits:CGSizeMake(_contentScroll.frame.size.width, MAXFLOAT)].height;
    self.contentLable.frame = CGRectMake(0, 0, self.contentScroll.frame.size.width, height);
    if (height > 180) {
        limit = 180;
    }else if (height > limit) {
        limit = height;
    }
    self.contentScroll.frame = CGRectMake(20, 30, _whiteBG.frame.size.width - 40, limit);
    self.contentScroll.contentSize = CGSizeMake(_contentScroll.frame.size.width, height);
    [_contentScroll addSubview:_contentLable];

    CGFloat widht = (_whiteBG.frame.size.width - 40 - 15) / self.buttons.count;
    ZHYAlertButtonItem *item = self.buttons[0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.frame = CGRectMake(20, CGRectGetMaxY(_contentScroll.frame) + 20, widht, 30);
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [button setTitleColor:RGBACOLOR(153, 153, 153) forState:UIControlStateNormal];
    [button setTitle:item.title forState:UIControlStateNormal];
    button.layer.borderColor = RGBACOLOR(153, 153, 153).CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBG addSubview:button];

    ZHYAlertButtonItem *item1 = self.buttons[1];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 101;
    button1.frame = CGRectMake(CGRectGetMaxX(button.frame) + 15, CGRectGetMaxY(_contentScroll.frame) + 20, widht, 30);
    button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:item1.title forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor cyanColor]];
    button1.layer.cornerRadius = 5;
    button1.layer.masksToBounds = YES;
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBG addSubview:button1];
    
    self.whiteBG.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(button1.frame) + 20);
    self.whiteBG.center = self.view.center;
}

- (void)buttonAction:(UIButton *)sender {
    ZHYAlertButtonItem *item = self.buttons[sender.tag - 100];
    [self hiddenAlert];
    if (item.buttonBlock) {
        item.buttonBlock();
    }
    
}

- (void)hiddenAlert {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)showAlert {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController addChildViewController:self];
    [rootViewController.view addSubview:self.view];
}

- (void)dealloc {
    NSLog(@"dealloc------>%@", NSStringFromClass([self class]));
}
@end

@implementation ZHYAlertButtonItem



@end

