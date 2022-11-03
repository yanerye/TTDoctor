//
//  YKChatQuestionnaireMessageCell.m
//  TTDoctor
//
//  Created by YK on 2020/9/14.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatQuestionnaireMessageCell.h"

@implementation YKChatQuestionnaireMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setConfig:(YKChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];


}


@end
