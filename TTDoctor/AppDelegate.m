//
//  AppDelegate.m
//  TTDoctor
//
//  Created by YK on 2020/6/5.
//  Copyright © 2020 YK. All rights reserved.
//

#import "AppDelegate.h"
#import "YKGuidePagesVC.h"
#import "YKLoginVC.h"
#import "YKTabBarVC.h"
#import "IQKeyboardManager.h"
#import "YKNetworkManager.h"
#import "WHDebugToolManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //首次push带有UITextView的页面卡顿
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.window addSubview:textView];
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [userDefault boolForKey:@"isFirst"];
    if (isFirst == NO) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:@"isFirst"];
        YKGuidePagesVC *guideVC = [[YKGuidePagesVC alloc] init];
        self.window.rootViewController = guideVC;
    }else{
        [self autoLogin];
    }
    [self.window makeKeyAndVisible];
    [WHDebugToolManager toggleWith:DebugToolTypeAll];

    [YKNetworkManager manager].baseURL = BASE_SERVER;

    [self initKeyBoardManager];

    return YES;
}

#pragma mark - 键盘设置
- (void)initKeyBoardManager{
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor colorWithRed:19/255.0 green:125/255.0 blue:252/255.0 alpha:1.0];

}

#pragma mark - 自动登录
- (void)autoLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumberStr = (NSString *)[userDefaults valueForKey:@"phoneNumber"];
    NSString *passWordStr = (NSString *)[userDefaults valueForKey:@"passWord"];
    if([[YKDoctorHelper doctorID] length] > 0 && phoneNumberStr.length > 0 && passWordStr.length > 0) {
        
        //保存token
        NSString *accessPath = [NSString stringWithFormat:@"%@/app/auth/v2.0/login",TOKEN_SERVER];
        NSDictionary *params = @{@"client":@"2",@"mobile":phoneNumberStr,@"password":passWordStr};
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:accessPath parameters:params error:nil];
        request.timeoutInterval = 10.f;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSDictionary *tempDict = responseObject[@"data"];
            if (!error) {
                if ([tempDict isKindOfClass:[NSNull class]] || [tempDict isEqual:[NSNull null]]) {
                    
                }else{
                    //保存token
                    NSString *accessToken = tempDict[@"accessToken"];
                    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"accessToken"];
    //                //保存别名
    //                NSString *alias = tempDict[@"alias"];
    //                [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"alias"];

    //                [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //
    //                } seq:0];
                }
            } else {
                
            }
                        
        }];
        [task resume];
        
        YKTabBarVC *tabBarVC = [[YKTabBarVC alloc] init];
        self.window.rootViewController = tabBarVC;
    }else{
        YKLoginVC *loginVC = [[YKLoginVC alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
    }
}

@end
