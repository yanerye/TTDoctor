//
//  YKMessageModel.m
//  TTDoctor
//
//  Created by YK on 2020/8/14.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKMessageModel.h"

//文字大小
#define FONT_SIZE 15

@implementation YKMessageModel

- (CGRect)logoFrame{
    CGRect rect = CGRectZero;
    if (self.messageSenderType == MessageSenderTypeMe) {
        rect = CGRectMake(KWIDTH - 50, 10, 40, 40);
    }else{
        rect = CGRectMake(10, 10, 40, 40);
    }
    
    return rect;
}

- (CGRect)messageFrame{
    CGRect rect = CGRectZero;
    CGFloat maxWidth = KWIDTH * 0.65 ;
    CGSize size = [self labelAutoCalculateRectWith:self.content Font:[UIFont systemFontOfSize:FONT_SIZE] MaxSize:CGSizeMake(maxWidth, MAXFLOAT)];
    if (self.messageType == MessageTypeText) {
        if (self.messageSenderType == MessageSenderTypeMe) {
            rect = CGRectMake(KWIDTH - size.width - 65, 30, size.width, size.height > 20 ? size.height : 20);
        }else{
            rect = CGRectMake(65 , 30 , size.width, size.height > 20 ? size.height : 20);
        }
    }
    return rect;
}

- (CGRect)imageFrame{

    __block CGRect rect = CGRectZero;
    UIImageView * view = [UIImageView new];
    [view sd_setImageWithURL:[NSURL URLWithString:self.smallImg] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (self.messageSenderType == MessageSenderTypeMe) {
            rect = CGRectMake(KWIDTH - image.size.width / 2 - 60, 30, image.size.width / 2, image.size.height / 2);
        }else{
            rect = CGRectMake(60, 30, image.size.width / 2, image.size.height / 2);
        }
    }];

    return rect;

}

- (CGRect)bubbleFrame{
    CGRect rect = CGRectZero;
    
    switch (self.messageType) {
        case MessageTypeText:
            rect = [self messageFrame];
            rect.origin.x = rect.origin.x + (self.messageSenderType == MessageSenderTypeMe ? -10 : -15);
            rect.origin.y = rect.origin.y - 10;
            rect.size.width = rect.size.width + 25;
            rect.size.height = rect.size.height + 20;
            break;
        default:
            break;
    }
    
    return rect;
}

- (CGRect)quessionFrame{
    CGRect rect = CGRectZero;
    if (self.messageType == MessageTypeQuession) {
        rect = CGRectMake(KWIDTH - 210 - 50, 30, 210, 78);
    }
    return rect;
}

- (CGRect)teachFrame{
    CGRect rect = CGRectZero;
    if (self.messageType == MessageTypeTeach) {
        rect = CGRectMake(KWIDTH - 210 - 50, 30, 210, 65);
    }
    return rect;
}

- (CGFloat)cellHeight{
    return [self messageFrame].size.height + [self quessionFrame].size.height + [self teachFrame].size.height + [self imageFrame].size.height + 50;
}

//获取文字的size
- (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)textFont MaxSize:(CGSize)maxSize
{
    NSDictionary *attributes = @{NSFontAttributeName: textFont};
    CGRect rect = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}



@end
