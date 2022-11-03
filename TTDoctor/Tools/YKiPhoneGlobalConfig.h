//
//  YKiPhoneGlobalConfig.h
//  TTDoctor
//
//  Created by YK on 2021/9/29.
//  Copyright © 2021 YK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YKiPhoneGlobalConfig : NSObject

+ (BOOL)hasNotch;

+ (CGFloat)bottomSafeArea;

+ (CGFloat)statusBarHight;

+ (CGFloat)navigationBarHight;

@end


