//
//  YKChatBaseCell.h
//  TTDoctor
//
//  Created by YK on 2020/9/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKChatMessageModel.h"

@protocol YKShowOriginalImageDelegate <NSObject>


@optional

/**
 点击查看大图

 */
- (void)showOriginalImageWithCurrentImageURL:(NSString *)currentImageURL;

@end

@interface YKChatBaseCell : UITableViewCell

///其他消息 - 比如：文本、图片消息等
- (void)setConfig:(YKChatMessageModel *)model isShowName:(BOOL)isShowName;

@property (nonatomic, weak) id <YKShowOriginalImageDelegate> delegate;


@end


