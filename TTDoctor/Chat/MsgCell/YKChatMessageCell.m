//
//  YKChatMessageCell.m
//  TTDoctor
//
//  Created by YK on 2020/9/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatMessageCell.h"
#import "UIView+WZMChat.h"
#import "YKChatHelper.h"

@implementation YKChatMessageCell{
    UIButton *_retryBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 20;
        [self addSubview:_avatarImageView];
        
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = [UIColor grayColor];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nickLabel];
        
        _bubbleImageView = [[UIImageView alloc] init];
        [self addSubview:_bubbleImageView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        _retryBtn = [[UIButton alloc] init];
        [_retryBtn setImage:[UIImage imageNamed:@"wzm_chat_retry"] forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retryBtn];
    }
    return self;
}

- (void)setConfig:(YKChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];
    
    if (model.isSender) {
        //头像
        _avatarImageView.frame = CGRectMake(KWIDTH-50, 10, 40, 40);

        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] completed:nil];

        
        //昵称
        _nickLabel.frame = CGRectMake(_avatarImageView.chat_minX-110, 5, 100, 20);
        _nickLabel.text = model.name;
        _nickLabel.textAlignment = NSTextAlignmentRight;
        
        if (isShowName) {
            _nickLabel.hidden = NO;
            //聊天气泡
            _bubbleImageView.frame = CGRectMake(_avatarImageView.chat_minX-model.modelW-22, _nickLabel.chat_maxY, model.modelW+17, model.modelH+10);
        }
        else {
            _nickLabel.hidden = YES;
            //聊天气泡
            _bubbleImageView.frame = CGRectMake(_avatarImageView.chat_minX-model.modelW-22, _avatarImageView.chat_minY, model.modelW+17, model.modelH+10);
        }
        _bubbleImageView.image = [YKChatHelper senderBubble];
        
        //消息内容
        CGRect rect = _bubbleImageView.frame;
        if (model.msgType == YKMessageTypeText) {
            rect.origin.x += 5;
            rect.size.width -= 17;
        }
        _contentRect = rect;
        
        //正在发送菊花动画
        _activityView.frame = CGRectMake(_bubbleImageView.chat_minX-40, _bubbleImageView.chat_minY+(_bubbleImageView.chat_height-40)/2, 40, 40);
        
        if (model.sendType == YKMessageSendTypeWaiting) {
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _retryBtn.hidden = YES;
        }
        else if (model.sendType == YKMessageSendTypeSuccess) {
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            _retryBtn.hidden = YES;
        }
        else {
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            _retryBtn.hidden = NO;
        }
        
        //发送失败感叹号
        _retryBtn.frame = CGRectMake(_activityView.chat_minX, _bubbleImageView.chat_maxY - 30, 15, 15);
    }
    else {
        _avatarImageView.frame = CGRectMake(10, 10, 40, 40);

        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] completed:nil];

        _nickLabel.frame = CGRectMake(_avatarImageView.chat_maxX+10, 5, 100, 20);
        _nickLabel.text = model.name;
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        
        if (isShowName){
            _nickLabel.hidden = NO;
            //聊天气泡
            _bubbleImageView.frame = CGRectMake(_avatarImageView.chat_maxX+5, _nickLabel.chat_maxY, model.modelW+17, model.modelH+10);
        }
        else {
            _nickLabel.hidden = YES;
            //聊天气泡
            _bubbleImageView.frame = CGRectMake(_avatarImageView.chat_maxX+5, _avatarImageView.chat_minY, model.modelW+17, model.modelH+10);
        }
        _bubbleImageView.image = [YKChatHelper receiverBubble];
        
        CGRect rect = _bubbleImageView.frame;
        if (model.msgType == YKMessageTypeText) {
            rect.origin.x += 12;
            rect.size.width -= 17;
        }
        _contentRect = rect;
        
        _activityView.hidden = YES;
        [_activityView stopAnimating];
        _activityView.frame = CGRectMake(_bubbleImageView.chat_maxX, _bubbleImageView.chat_minY+(_bubbleImageView.chat_height-40)/2, 40, 40);
        
        _retryBtn.hidden = YES;
        _retryBtn.frame = CGRectMake(_activityView.chat_minX, _bubbleImageView.chat_maxY-30, 40, 40);
    }
}

- (void)retryBtnClick:(UIButton *)btn {

}
@end
