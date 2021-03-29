//
//  BFCButton.m
//  MusicClass
//
//  Created by 张建林 on 15/12/3.
//  Copyright © 2015年 bigfacecat. All rights reserved.
//

#import "BFCButton.h"

@implementation BFCButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.imageviewRatio = 0.7;
    self.labelRatio = 0.3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (self.alignType != BFCButtonAlignTypeNone) {
        if (self.alignType == BFCButtonAlignTypeTextRight) {
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, 0, 0, contentRect.size.width * (1-self.imageviewRatio)));
        } else if (self.alignType == BFCButtonAlignTypeTextLeft){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, contentRect.size.width * (1-self.imageviewRatio), 0, 0));
        } else if (self.alignType == BFCButtonAlignTypeTextTop){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(contentRect.size.height * (1-self.imageviewRatio), 0, 0, 0));
        } else if (self.alignType == BFCButtonAlignTypeTextBottom){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, 0, contentRect.size.height * (1-self.imageviewRatio), 0));
        }
    }
    
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (self.alignType != BFCButtonAlignTypeNone) {
        if (self.alignType == BFCButtonAlignTypeTextRight) {
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, contentRect.size.width * (1 - self.labelRatio), 0, 0));
        } else if (self.alignType == BFCButtonAlignTypeTextLeft){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, 0, 0, contentRect.size.width * (1 - self.labelRatio)));
        } else if (self.alignType == BFCButtonAlignTypeTextTop){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(0, 0, contentRect.size.height * (1 - self.labelRatio), 0));
        } else if (self.alignType == BFCButtonAlignTypeTextBottom){
            return UIEdgeInsetsInsetRect(contentRect,  UIEdgeInsetsMake(contentRect.size.height * (1 - self.labelRatio), 0, 0, 0));
        }
    }
    return contentRect;
}

@end
