//
//  YKiPhoneGlobalConfig.m
//  TTDoctor
//
//  Created by YK on 2021/9/29.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKiPhoneGlobalConfig.h"

@implementation YKiPhoneGlobalConfig

+ (BOOL)hasNotch {
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?
            //iphoneX  iphoneXS iphoneX11 Pro
            ((CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)) ||
             //iphone11 iphoneXR
             (CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)) ||
             //iphoneXS_Max iphone11Pro_Max
             (CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)) ||
             //iphone12_Mini
             (CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size)) ||
             //iphone12 iphone12_Pro
             (CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size)) ||
             //iphone12Pro_Max
             (CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size)) )
            : NO);
}

+ (CGFloat)bottomSafeArea {
    return [YKiPhoneGlobalConfig hasNotch] ? 34.0f : 0;
}

+ (CGFloat)statusBarHight {
    return [YKiPhoneGlobalConfig hasNotch] ? 44.0f : 20.0f;
}

+ (CGFloat)navigationBarHight {
    return [YKiPhoneGlobalConfig hasNotch] ? 88.0f : 64.0f;
}


@end
