//
//  YKChatKeyboardView.h
//  TTDoctor
//
//  Created by YK on 2020/8/10.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKChatKeyboardView;

typedef enum : NSInteger {
    WZMRecordTypeBegin = 0, //开始录音
    WZMRecordTypeCancel,    //取消录音
    WZMRecordTypeFinish,    //完成录音
} WZMRecordType;


@protocol DKSKeyboardDelegate <NSObject>

@optional //非必实现的方法

/**
 点击发送时输入框内的文案

 @param textStr 文案
 */
- (void)textViewContentText:(NSString *)textStr;

/**
 键盘的frame改变 以及键盘是否显示
 */
- (void)changeTableViewFrameWithKeyboardHeight:(CGFloat)keyboardHeight isShow:(BOOL)isShow;

/**
 显示发送类型
 */
- (void)showSendType;

/**
发送语音
*/
- (void)toolView:(YKChatKeyboardView *)toolView didChangeRecordType:(WZMRecordType)type;


@end


@interface YKChatKeyboardView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id <DKSKeyboardDelegate>delegate;

@end





