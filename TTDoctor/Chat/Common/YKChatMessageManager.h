//
//  YKChatMessageManager.h
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKChatMessageModel.h"
#import "YKChatUserModel.h"

@interface YKChatMessageManager : NSObject

#pragma mark - 创建消息模型
//创建系统消息
+ (YKChatMessageModel *)createSystemMessage:(YKChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender;

///创建文本消息
+ (YKChatMessageModel *)createTextMessage:(YKChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender;

///创建录音消息
+ (YKChatMessageModel *)createVoiceMessage:(YKChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender;

///创建图片消息
+ (YKChatMessageModel *)createImageMessage:(YKChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender;

///创建视频消息
+ (YKChatMessageModel *)createVideoMessage:(YKChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender;

///创建问卷消息
+ (YKChatMessageModel *)createQuestionnaireMessage:(YKChatUserModel *)userModel
                                 message:(NSString *)message
                                 questionnaireURL:(NSString *)questionnaireURL
                                 isSender:(BOOL)isSender;


@end


