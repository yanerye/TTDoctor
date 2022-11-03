//
//  YKTabBarVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/11.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKTabBarVC.h"
#import "YKHomeVC.h"
#import "YKPatientVC.h"
#import "YKChatListVC.h"
#import "YKProjectVC.h"
#import "YKMineVC.h"
#import "YKDoctorListVC.h"
#import "YKNewsVC.h"

@interface YKTabBarVC ()

@end

@implementation YKTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]];
    if (@available(iOS 13.0, *)) {
          [[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightGrayColor]];
    } else {

    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COMMONCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153),NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [self setUpAllChildVC];
}


- (void)setUpAllChildVC
{
    YKHomeVC * homeVC = [[YKHomeVC alloc] init];
    [self setUpOneChildVcWithVc:homeVC Image:@"tabBar_home_unSelected" selectedImage:@"tabBar_home_selected" title:@"首页"];

    YKPatientVC * patientVC = [[YKPatientVC alloc] init];
    [self setUpOneChildVcWithVc:patientVC Image:@"tabBar_patient_unSelected" selectedImage:@"tabBar_patient_selected" title:@"患者"];

    YKChatListVC * chatListVC = [[YKChatListVC alloc] init];
    [self setUpOneChildVcWithVc:chatListVC Image:@"tabBar_chat_unSelected" selectedImage:@"tabBar_chat_selected" title:@"随访"];

//    YKProjectVC * projectVC = [[YKProjectVC alloc] init];
//    [self setUpOneChildVcWithVc:projectVC Image:@"tabBar_project_unSelected" selectedImage:@"tabBar_project_selected" title:@"病历登记"];
    
    YKMineVC * mineVC = [[YKMineVC alloc] init];
    [self setUpOneChildVcWithVc:mineVC Image:@"tabBar_mine_unSelected" selectedImage:@"tabBar_mine_selected" title:@"个人中心"];
    
    
    YKNewsVC * newsVC = [[YKNewsVC alloc] init];
    [self setUpOneChildVcWithVc:newsVC Image:@"tabBar_mine_unSelected" selectedImage:@"tabBar_mine_selected" title:@"科研资讯"];
    
//    YKDoctorListVC * mineVC = [YKDoctorListVC init];
//    [self setUpOneChildVcWithVc:mineVC Image:@"底部_个人中心未选" selectedImage:@"底部_个人中心选中" title:@"个人中心"];
}

- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    
    [self addChildViewController:nav];
    
}

- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
