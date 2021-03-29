//
//  YKChatKeyboardView.m
//  TTDoctor
//
//  Created by YK on 2020/8/10.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatKeyboardView.h"
#import "DKSTextView.h"
#import "UIView+FrameTool.h"
#import "YKRecordAnimation.h"

#define SCREENWIDTH(x)   [UIScreen mainScreen].bounds.size.width * x / 320

//间隙
static float viewMargin = 5.0f;
//按钮的高度
static float buttonHeight = 30.0f;
//按钮的宽度
static float buttonWidth = 50.0f;
//输入框的高度
static float inputHeight = 36.0f;
//输入框距离view的上下间隙
static float inputMargin = 7.0f;
//按钮距离view的上下间隙
static float buttonMargin = 10.0f;

@interface YKChatKeyboardView ()<UITextViewDelegate>

//背景view
@property (nonatomic, strong) UIView *backView;
//语音按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//发送按钮
@property (nonatomic, strong) UIButton *sendBtn;
//输入框
@property (nonatomic, strong) DKSTextView *textView;
//语音发送按钮
@property (nonatomic, strong) UIButton *recordBtn;


@property (nonatomic, assign) float keyboardHeight; //键盘高度

@property (nonatomic, strong) YKRecordAnimation *recordAnimation;


@end

@implementation YKChatKeyboardView
{
    //键盘是否弹起
    BOOL _isShow;
    //是否显示发送语音
    BOOL _isRecord;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        _isShow = NO;
        _isRecord = NO;
        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

        //显示快捷回复
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQuickReply:) name:@"showQuickReply" object:nil];
        //UItableView滑动隐藏键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
    //选择按钮
    self.voiceBtn.frame = CGRectMake(viewMargin, buttonMargin, buttonHeight, buttonHeight);
    
    //输入视图
    self.textView.frame = CGRectMake(viewMargin * 2 + buttonHeight, inputMargin, KWIDTH - (viewMargin * 4 + buttonHeight + buttonWidth), inputHeight);
    
    //语音输入按钮
    self.recordBtn.frame = CGRectMake(viewMargin * 2 + buttonHeight, inputMargin, KWIDTH - (viewMargin * 4 + buttonHeight + buttonWidth), inputHeight);

    //发送按钮
    self.sendBtn.frame = CGRectMake(KWIDTH - buttonWidth - viewMargin, buttonMargin, buttonWidth, buttonHeight);
}

#pragma mark ====== 语音按钮事件 ======
- (void)voiceBtn:(UIButton *)btn {
    if (_isRecord) {
        _isRecord = NO;
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"wzm_chat_voice"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        self.recordBtn.hidden = YES;
        [self.textView becomeFirstResponder];

    }else{
        _isRecord = YES;
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"wzm_chat_board"] forState:UIControlStateNormal];
        self.textView.hidden = YES;
        self.recordBtn.hidden = NO;
        [self.textView resignFirstResponder];
        
    }
//    if ([self.delegate respondsToSelector:@selector(showSendType)]) {
//        [self.delegate showSendType];
//    }
}

//#pragma mark ====== 发送按钮 ======
//- (void)sendMessage {
//    if (_contentStr.length == 0 || [_contentStr empty]) {
//        [YKAlertHelper showErrorMessage:@"请输入消息" inView:[self superview]];
//        return;
//    }
//
//    if (_isShow) {
//        self.frame = CGRectMake(0, KHEIGHT - navBarHeight - _keyboardHeight - 50, KWIDTH, 50);
//        self.backView.frame = CGRectMake(0, 0, self.width, self.height);
//        self.selectBtn.frame = CGRectMake(viewMargin, buttonMargin, buttonHeight, buttonHeight);
//        self.textView.frame = CGRectMake(viewMargin * 2 + buttonHeight, inputMargin, KWIDTH - (viewMargin * 4 + buttonHeight + buttonWidth), inputHeight);
//        self.sendBtn.frame = CGRectMake(KWIDTH - buttonWidth - viewMargin, buttonMargin, buttonWidth, buttonHeight);
//        [self changeTableViewFrame];
//    }else{
//        self.frame = CGRectMake(0, KHEIGHT - navBarHeight - 50, KWIDTH, 50);
//        self.backView.frame = CGRectMake(0, 0, self.width, self.height);
//        self.selectBtn.frame = CGRectMake(viewMargin, buttonMargin, buttonHeight, buttonHeight);
//        self.textView.frame = CGRectMake(viewMargin * 2 + buttonHeight, inputMargin, KWIDTH - (viewMargin * 4 + buttonHeight + buttonWidth), inputHeight);
//        self.sendBtn.frame = CGRectMake(KWIDTH - buttonWidth - viewMargin, buttonMargin, buttonWidth, buttonHeight);
//        [self changeTableViewFrame];
//    }
//
//    if ([self.delegate respondsToSelector:@selector(textViewContentText:)]) {
//        [self.delegate textViewContentText:_contentStr];
//        self.textView.text = @"";
//        _contentStr = @"";
//    }
//}

#pragma mark ===== 输入框相关事件和代理 ======

- (void)changeFrame:(CGFloat)height {
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame; //改变输入框的frame
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, KWIDTH, height + (inputMargin * 2));
    self.frame = CGRectMake(0, KHEIGHT - navBarHeight - self.backView.height - _keyboardHeight, KWIDTH, self.backView.height);
    //改变更多按钮、表情按钮的位置
    self.voiceBtn.frame = CGRectMake(viewMargin, self.backView.height - buttonHeight - buttonMargin, buttonHeight, buttonHeight);
    self.sendBtn.frame = CGRectMake(self.textView.maxX + viewMargin, self.backView.height - buttonHeight - buttonMargin, buttonWidth, buttonHeight);

    //主要是为了改变VC的tableView的frame
    [self changeTableViewFrame];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _isShow = YES;
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的高度
    self.keyboardHeight = endFrame.size.height;
    
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.frame = CGRectMake(0, endFrame.origin.y - self.backView.height - navBarHeight, KWIDTH, self.height);
        [self changeTableViewFrame];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _isShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, KHEIGHT - navBarHeight - self.backView.height, KWIDTH, self.backView.height);
        _keyboardHeight = 0;
        [self changeTableViewFrame];
    }];
}

- (void)changeTableViewFrame {
    CGFloat keyboardHeight = _keyboardHeight + self.frame.size.height - 50;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTableViewFrameWithKeyboardHeight: isShow:)]) {
        [self.delegate changeTableViewFrameWithKeyboardHeight:keyboardHeight isShow:_isShow];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length == 0 || [textView.text empty]) {
            [YKAlertHelper showErrorMessage:@"请输入消息" inView:[self superview]];
        }else if ([self.delegate respondsToSelector:@selector(textViewContentText:)]) {
            [self.delegate textViewContentText:textView.text];
            self.textView.text = @"";
        }
        return NO;
    }
    return YES;
}

#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        [self addSubview:_backView];
    }
    return _backView;
}

//选择按钮
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"wzm_chat_voice"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

//发送按钮
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.backgroundColor = COMMONCOLOR;
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.userInteractionEnabled = NO;
        [self.backView addSubview:_sendBtn];
    }
    return _sendBtn;
}

- (DKSTextView *)textView {
    if (!_textView) {
        _textView = [[DKSTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backView addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _recordBtn.backgroundColor = [UIColor cyanColor];
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.cornerRadius = 2;
        _recordBtn.layer.borderWidth = 0.5;
        _recordBtn.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_recordBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(touchFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_recordBtn addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        _recordBtn.hidden = YES;
        [self.backView addSubview:_recordBtn];
    }
    return _recordBtn;
}

#pragma mark ====== 显示快捷回复 ====

- (void)showQuickReply:(NSNotification *)notification{
    NSDictionary *userInfo = [notification object];
    self.textView.text = [NSString stringWithFormat:@"%@",userInfo[@"content"]];
}

#pragma mark ====== 滑动UITableView隐藏键盘 ======
- (void)keyboardHide {
    _isShow = NO;
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, KHEIGHT - navBarHeight - self.backView.height, KWIDTH, self.backView.height);
    }];
}
 
#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 录音状态变化
- (void)touchDown:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self didChangeRecordType:UIControlEventTouchDown];
    //开始录音
    [self.recordAnimation beginRecord];
}

- (void)touchCancel:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self didChangeRecordType:UIControlEventTouchCancel];
    //取消录音
    [self.recordAnimation cancelRecord];
}

- (void)touchFinish:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if ([self.recordAnimation endRecord]) {
        //结束录音
        [self didChangeRecordType:UIControlEventTouchUpInside];
    }
    else {
        //录音时长小于1秒, 取消录音
        [self didChangeRecordType:UIControlEventTouchCancel];
    }
}

- (void)touchDragOutside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.recordAnimation showVoiceCancel];
}

- (void)touchDragInside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.recordAnimation showVoiceAnimation];
}

- (void)didChangeRecordType:(UIControlEvents)touchEvent {
    WZMRecordType type;
    if (touchEvent == UIControlEventTouchDown) {
        type = WZMRecordTypeBegin;
    }
    else if (touchEvent == UIControlEventTouchUpInside) {
        type = WZMRecordTypeFinish;
    }
    else {
        type = WZMRecordTypeCancel;
    }
    if ([self.delegate respondsToSelector:@selector(toolView:didChangeRecordType:)]) {
        [self.delegate toolView:self didChangeRecordType:type];
    }
}

- (YKRecordAnimation *)recordAnimation {
    if (_recordAnimation == nil) {
        _recordAnimation = [[YKRecordAnimation alloc] init];
    }
    return _recordAnimation;
}

@end
