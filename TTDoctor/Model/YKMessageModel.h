//
//  YKMessageModel.h
//  TTDoctor
//
//  Created by YK on 2020/8/14.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageTypeImage=1,
    MessageTypeText,
    MessageTypeQuession,
    MessageTypeTeach
};


/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderTypeOther=0,
    MessageSenderTypeMe
    
};

@interface YKMessageModel : NSObject

@property (nonatomic, assign) MessageType      messageType;
@property (nonatomic, assign) MessageSenderType messageSenderType;

/*
 消息内容
 */
@property (nonatomic, copy) NSString *content;


/*
 小图片的网址
 */
@property (nonatomic, copy) NSString *smallImg;


/*
 大图片的网址
 */
@property (nonatomic, copy) NSString *orignImg;


/*
 问卷的网址
 */
@property (nonatomic, copy) NSString *quessionUrl;

/*
 患教的网址
 */
@property (nonatomic, copy) NSString *materialUrl;


- (CGRect)logoFrame;
- (CGRect)messageFrame;
- (CGRect)bubbleFrame;
- (CGRect)imageFrame;
- (CGRect)quessionFrame;
- (CGRect)teachFrame;
- (CGFloat)cellHeight;

@end


