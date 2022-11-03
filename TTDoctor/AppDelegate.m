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
#import "JPUSHService.h"
# ifdef NSFoundationVersionNumber_iOS_9_x_Max
# import <UserNotifications/UserNotifications.h>
# endif
#import "YKTestChatVC.h"
#import "ZAlertViewManager.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

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

    

//    YKGuidePagesVC *guideVC = [[YKGuidePagesVC alloc] init];
//    self.window.rootViewController = guideVC;
    [self.window makeKeyAndVisible];
    [WHDebugToolManager toggleWith:DebugToolTypeAll];

    [YKNetworkManager manager].baseURL = BASE_SERVER;

    //键盘
    [self initKeyBoardManager];
    
    //注册极光
    [self initJPUSHServiceWithOptions:launchOptions];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


    return YES;
}

#pragma mark - 键盘设置
- (void)initKeyBoardManager{
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor colorWithRed:19/255.0 green:125/255.0 blue:252/255.0 alpha:1.0];

}

#pragma mark - 极光推送配置相关

- (void)initJPUSHServiceWithOptions:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"816948b0eb75f60e442ea254" channel:@"App Store" apsForProduction:NO];
    NSString *aliasStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"alias"];
    if (aliasStr.length > 0) {
        //设置别名
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

            } seq:0];
        });
    }

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *nameString = extras[@"title"];
    NSString *contentString = extras[@"content"];
    NSString *tempString = [[NSString stringWithFormat:@"%@",extras[@"timestamp"]] substringToIndex:10];
    NSString *timeString = [[self dateWithString:tempString] substringFromIndex:11];

    UIViewController *vc = [self jsd_getCurrentViewController];
    if ([vc isKindOfClass:[YKTestChatVC class]]) {
        //创建通知对象
        NSNotification *notification = [NSNotification notificationWithName:@"newMessage" object:extras];
         [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        
        [[ZAlertViewManager shareManager] showWithTitle:nameString content:contentString time:timeString];
        [[ZAlertViewManager shareManager] didSelectedAlertViewWithBlock:^{
            YKTestChatVC *chatVC = [[YKTestChatVC alloc] init];
            chatVC.chatId = [NSString stringWithFormat:@"%@",extras[@"data"]];
            chatVC.titleString = nameString;
            chatVC.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:chatVC animated:YES];
        }];
    }

}

-(NSString*)dateWithString:(NSString*)str{
    NSTimeInterval interval = [str doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


- (UIViewController *)jsd_getCurrentViewController{

    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {

            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {

          UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];

        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {

          UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {

            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {

                YKTabBarVC *rootVC = currentViewController.childViewControllers.lastObject;
                UINavigationController *navi = (UINavigationController *)rootVC.selectedViewController;
                currentViewController = [navi.childViewControllers lastObject];
                return currentViewController;
            } else {

                return currentViewController;
            }
        }

    }
    return currentViewController;
}

- (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}



//注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册 APNs 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
      NSLog(@"进入");
  }else{
    //从通知设置界面进入应用
  }
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
  completionHandler();  // 系统要求执行这个方法
}


#pragma mark - 自动登录
- (void)autoLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumberStr = (NSString *)[userDefaults valueForKey:@"phoneNumber"];
    NSString *passWordStr = (NSString *)[userDefaults valueForKey:@"passWord"];
    if([[YKDoctorHelper doctorID] length] > 0 && phoneNumberStr.length > 0 && passWordStr.length > 0) {
        
        [[YKTokenApiService service] loginWithTelephone:phoneNumberStr password:passWordStr requestMethod:@"POST" completion:^(id responseObject, NSError *error) {
           if (!error) {
              //保存token
              NSString *accessToken = responseObject[@"accessToken"];
              [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"accessToken"];
 //                //保存别名
 //                NSString *alias = tempDict[@"alias"];
 //                [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"alias"];

 //                [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
 //
 //                } seq:0];
              
           }
        }];
        
        YKTabBarVC *tabBarVC = [[YKTabBarVC alloc] init];
        self.window.rootViewController = tabBarVC;
    }else{
        YKLoginVC *loginVC = [[YKLoginVC alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
        
    }
}

@end
