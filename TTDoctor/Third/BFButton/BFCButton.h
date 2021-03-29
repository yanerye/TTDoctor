//
//  BFCButton.h
//  MusicClass
//
//  Created by 张建林 on 15/12/3.
//  Copyright © 2015年 bigfacecat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BFCButtonAlignType){
    BFCButtonAlignTypeNone,
    BFCButtonAlignTypeTextRight,
    BFCButtonAlignTypeTextLeft,
    BFCButtonAlignTypeTextTop,
    BFCButtonAlignTypeTextBottom,
};

@interface BFCButton : UIButton
@property (nonatomic, assign) BFCButtonAlignType alignType;
@property (nonatomic, assign) CGFloat imageviewRatio;
@property (nonatomic, assign) CGFloat labelRatio;
@end
