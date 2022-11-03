//
//  YKModifyTagVC.h
//  TTDoctor
//
//  Created by YK on 2021/10/9.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^YKUpdateTagBlock)(void);

@interface YKModifyTagVC : YKBaseVC

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, copy)YKUpdateTagBlock block;

@end


