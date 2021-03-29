//
//  YKChatMessageManager.m
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatMessageManager.h"
#import "YKChatUserModel.h"
#import "SDImageCache.h"

@implementation YKChatMessageManager

#pragma mark - 创建消息模型
//创建系统消息
+ (YKChatMessageModel *)createSystemMessage:(YKChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender {
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType = YKMessageTypeSystem;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建文本消息
+ (YKChatMessageModel *)createTextMessage:(YKChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender {
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType = YKMessageTypeText;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建录音消息
+ (YKChatMessageModel *)createVoiceMessage:(YKChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender {
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType = YKMessageTypeVoice;
    msgModel.message = @"[语音]";
    msgModel.duration = duration;
    msgModel.voiceUrl = voiceUrl;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建图片消息
+ (YKChatMessageModel *)createImageMessage:(YKChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender {
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType   = YKMessageTypeImage;
    msgModel.message   = @"[图片]";
    msgModel.thumbnail = thumbnail;
    msgModel.original  = original;
    msgModel.imgW = oriImage.size.width;
    msgModel.imgH = oriImage.size.height;

    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建视频消息
+ (YKChatMessageModel *)createVideoMessage:(YKChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender {
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType   = YKMessageTypeVideo;
    msgModel.message   = @"[视频]";
    msgModel.videoUrl = videoUrl;
    msgModel.coverUrl  = coverUrl;
    msgModel.imgW = coverImage.size.width;
    msgModel.imgH = coverImage.size.height;
    //将封面图片保存到本地
    [[SDImageCache sharedImageCache] storeImage:coverImage forKey:coverUrl completion:nil];

    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

///创建问卷消息
+ (YKChatMessageModel *)createQuestionnaireMessage:(YKChatUserModel *)userModel
                                 message:(NSString *)message
                                 questionnaireURL:(NSString *)questionnaireURL
                                          isSender:(BOOL)isSender{
    YKChatMessageModel *msgModel = [[YKChatMessageModel alloc] init];
    msgModel.msgType = YKMessageTypeQuestionnaire;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

#pragma mark - pravite

+ (void)setConfig:(YKChatMessageModel *)msgModel userModel:(YKChatUserModel *)userModel isSender:(BOOL)isSender {
    if (isSender) {
        msgModel.uid    = [YKChatUserModel shareInfo].uid;
        msgModel.name   = [YKChatUserModel shareInfo].name;
        msgModel.avatar = [YKChatUserModel shareInfo].avatar;
    }
    else {
        msgModel.uid    = userModel.uid;
        msgModel.name   = userModel.name;
        msgModel.avatar = userModel.avatar;
    }
    msgModel.sender  = isSender;
    msgModel.sendType  = YKMessageSendTypeWaiting;
//    msgModel.timestmp  = [YKChatHelper nowTimestamp];
}


@end
