//
//  YKTokenApiService.h
//  TTDoctor
//
//  Created by YK on 2022/4/12.
//  Copyright © 2022 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YKTokenCompletionBlock)(id responseObject, NSError *error);


@interface YKTokenApiService : NSObject

+ (instancetype)service;


#pragma mark -登录

/**
 用户登录
 
 */

- (void)loginWithTelephone:(NSString *)telephone password:(NSString *)password requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion;


#pragma mark -个人中心

/**
 退出登录
 
 */

- (void)loginOutWithRequestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion;

#pragma mark - 聊天

/**
 发送文字
 
 */

- (void)sendMessageWithChatId:(NSString *)chatId content:(NSString *)content requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion;


/**
 发送图片
 
 */

- (void)sendImageWithChatId:(NSString *)chatId content:(NSString *)content suffix:(NSString *)suffix requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion;

@end


