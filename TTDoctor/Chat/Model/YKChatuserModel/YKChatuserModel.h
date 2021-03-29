//
//  YKChatUserModel.h
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatBaseModel.h"

@interface YKChatUserModel : YKChatBaseModel

///用户id
@property (nonatomic, strong) NSString *uid;
///用户昵称
@property (nonatomic, strong) NSString *name;
///用户头像
@property (nonatomic, strong) NSString *avatar;
///聊天界面是否显示用户昵称
@property (nonatomic, assign, getter=isShowName) BOOL showName;

///默认登录用户
+ (instancetype)shareInfo;

@end


