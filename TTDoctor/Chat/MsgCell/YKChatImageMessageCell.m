//
//  YKChatImageMessageCell.m
//  TTDoctor
//
//  Created by YK on 2020/9/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatImageMessageCell.h"

@implementation YKChatImageMessageCell {
    UIImageView *_contentImageView;
    NSString *_originalImageURL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.layer.cornerRadius = 5;
        _contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOriginalImage)];
        [_contentImageView addGestureRecognizer:tapGst];
        [self addSubview:_contentImageView];
    }
    return self;
}

- (void)setConfig:(YKChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];
    _originalImageURL = model.original;
    _contentImageView.frame = _contentRect;
    //完成网络请求之前显示base64字符串转化的UIImage
    if (model.thumbnail.length > 100) {
        NSData * imageData =[[NSData alloc] initWithBase64EncodedString:model.thumbnail options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _contentImageView.image = [UIImage imageWithData:imageData ];
    }else{
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] completed:nil];
    }
}

- (void)showOriginalImage{
    if ([self.delegate respondsToSelector:@selector(showOriginalImageWithCurrentImageURL:)]) {
        [self.delegate showOriginalImageWithCurrentImageURL:_originalImageURL];
    }
}

@end
