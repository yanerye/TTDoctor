//
//  YKChatDBManager.h
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKChatUserModel.h"
#import "YKChatMessageModel.h"

@interface YKChatDBManager : NSObject

+ (instancetype)DBManager;

#pragma mark - user表操纵
///所有用户
- (NSMutableArray *)users;
///添加用户
- (void)insertUserModel:(YKChatUserModel *)model;
///更新用户
- (void)updateUserModel:(YKChatUserModel *)model;
///查询用户
- (YKChatUserModel *)selectUserModel:(NSString *)uid;
///删除用户
- (void)deleteUserModel:(NSString *)uid;

#pragma mark - message表操纵
///删除私聊消息记录
- (void)deleteMessageWithUid:(NSString *)uid;
//私聊消息列表
- (NSMutableArray *)messagesWithUser:(YKChatUserModel *)model;
///插入私聊消息
- (void)insertMessage:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model;
///更新私聊消息
- (void)updateMessageModel:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model;
///删除私聊消息
- (void)deleteMessageModel:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model;

@end


