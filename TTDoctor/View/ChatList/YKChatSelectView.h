//
//  YKChatSelectView.h
//  TTDoctor
//
//  Created by YK on 2020/7/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTypeDelegate<NSObject>

-(void)showQuickReplyView;
-(void)jumpToMyQuestionnaire;
-(void)jumpToTeach;
-(void)jumpToImage;

@end

@interface YKChatSelectView : UIView

@property (nonatomic,weak) id<SelectTypeDelegate> delegate;


@end


