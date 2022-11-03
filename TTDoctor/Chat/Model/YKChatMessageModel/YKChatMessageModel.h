//
//  YKChatMessageModel.h
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatBaseModel.h"

typedef enum : NSInteger {
    YKMessageTypeSystem = 0,         //系统消息
    YKMessageTypeText,               //文本消息
    YKMessageTypeImage,              //图片消息
    YKMessageTypeQuestionnaire,      //问卷信息
    YKMessageTypeVoice,              //声音消息
    YKMessageTypeVideo,              //视频消息
}YKMessageType;

typedef enum : NSInteger {
    YKMessageSendTypeWaiting = 0,//正在发送
    YKMessageSendTypeSuccess,    //发送成功
    YKMessageSendTypeFailed,     //发送失败
}YKMessageSendType;

@interface YKChatMessageModel : YKChatBaseModel

#pragma mark - 消息基本信息
///消息id
@property (nonatomic, strong) NSString *mid;
///发送人id
@property (nonatomic, strong) NSString *uid;
///发送人昵称
@property (nonatomic, strong) NSString *name;
///发送人头像
@property (nonatomic, strong) NSString *avatar;
///是否是自己发送
@property (nonatomic, assign, getter=isSender) BOOL sender;
///文本内容
@property (nonatomic, strong) NSString *message;
///消息发送时间戳 <该字段参与数据排序, 不要修改字段名, 为了避开数据库关键字, 故意拼错>
@property (nonatomic, assign) NSInteger timestmp;
///消息类型
@property (nonatomic, assign) YKMessageType msgType;
///消息发送结果
@property (nonatomic, assign) YKMessageSendType sendType;
///缓存model宽, 优化列表滑动
@property (nonatomic, assign) NSInteger modelW;
///缓存model高, 优化列表滑动
@property (nonatomic, assign) NSInteger modelH;

#pragma mark - 图片消息
//图片宽高
@property (nonatomic, assign) NSInteger imgW;
@property (nonatomic, assign) NSInteger imgH;
//原图和缩略图的地址
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *thumbnail;

//#pragma mark - 问卷信息
////问卷地址
//@property (nonatomic, strong) NSString *questionnaireUrl;

#pragma mark - 声音消息
//声音地址
@property (nonatomic, strong) NSString *voiceUrl;
//声音时长
@property (nonatomic, assign) NSInteger duration;

#pragma mark - 视频消息
//视频地址
@property (nonatomic, strong) NSString *videoUrl;
//视频封面地址
@property (nonatomic, strong) NSString *coverUrl;

#pragma mark - 消息的自定义处理
///缓存model尺寸
- (void)cacheModelSize;

///富文本
- (NSAttributedString *)attributedString;

@end


