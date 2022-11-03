//
//  YKChatUserModel.m
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatuserModel.h"

@implementation YKChatUserModel

///默认登录用户
+ (instancetype)shareInfo {
    static YKChatUserModel *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[YKChatUserModel alloc] init];
        userInfo.uid = @"0";
        userInfo.name = [YKDoctorHelper shareDoctor].familyname;
        userInfo.avatar = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,[YKDoctorHelper shareDoctor].picUrl];
    });
    return userInfo;
}

@end
