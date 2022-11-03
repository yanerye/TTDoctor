//
//  YKTestChatVC.h
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"
#import "YKChatUserModel.h"
@interface YKTestChatVC : YKBaseVC

@property (nonatomic, copy) NSString * chatId;
@property (nonatomic, copy) NSString * titleString;
@property (nonatomic, copy) NSString * patientImage;

@property (nonatomic, strong) YKChatUserModel *userModel;

@end

