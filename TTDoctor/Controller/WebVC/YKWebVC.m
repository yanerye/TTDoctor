//
//  YKWebVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/17.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKWebVC.h"
#import <WebKit/WebKit.h>

#define CANNOUCEMENTDETIAL BASE_SERVER@"/announcement/announcement.html?"

@interface YKWebVC ()

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation YKWebVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutAllSubviews];
    
    
    NSString *urlStr;
    
    if ([self.titleString isEqualToString:@"公告详情"]) {
        urlStr = [NSString stringWithFormat:@"%@%@&%@",CANNOUCEMENTDETIAL, self.urlString, [YKDoctorHelper doctorID]];
    }else if ([self.titleString isEqualToString:@"服务条款"]) {
        urlStr = [NSString stringWithFormat:@"%@/doctoragreement.html",BASE_SERVER];
    }else if ([self.titleString isEqualToString:@"关于我们"]) {
        urlStr = [NSString stringWithFormat:@"%@/about_doctor.html?versionNum=v1.0&channelNum=AppStore",BASE_SERVER];
    }else if ([self.titleString isEqualToString:@"问卷详情"]) {
        urlStr = [NSString stringWithFormat:@"%@%@",BASE_SERVER,self.urlString];
    }
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.wkWebView];
    
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];
    
}

#pragma mark - init


- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] init];
    }
    return _wkWebView;
}

@end
