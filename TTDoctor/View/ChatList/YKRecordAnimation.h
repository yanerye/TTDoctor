//
//  YKRecordAnimation.h
//  TTDoctor
//
//  Created by YK on 2021/2/25.
//  Copyright © 2021 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKRecordAnimation : UIImageView

///设置声音大小 (0 ~ 1)
@property (nonatomic, assign) CGFloat volume;
///录音时长
@property (nonatomic, assign, readonly) CGFloat duration;

///录音开始
- (BOOL)beginRecord;
///录音结束, 只用录音时长大于1秒才返回YES
- (BOOL)endRecord;
///录音取消
- (BOOL)cancelRecord;

- (void)showVoiceCancel;
- (void)showVoiceShort;
- (void)showVoiceAnimation;

@end

