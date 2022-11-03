//
//  YKChatBaseCell.m
//  TTDoctor
//
//  Created by YK on 2020/9/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatBaseCell.h"

@implementation YKChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setConfig:(YKChatMessageModel *)model isShowName:(BOOL)isShowName {
    
}

@end
