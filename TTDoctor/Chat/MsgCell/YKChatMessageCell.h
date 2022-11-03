//
//  YKChatMessageCell.h
//  TTDoctor
//
//  Created by YK on 2020/9/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatBaseCell.h"

@interface YKChatMessageCell : YKChatBaseCell {
    UILabel *_nickLabel;
    UIImageView *_avatarImageView;
    UIImageView *_bubbleImageView;
    UIActivityIndicatorView *_activityView;
    
    CGRect _contentRect;
}

@end


