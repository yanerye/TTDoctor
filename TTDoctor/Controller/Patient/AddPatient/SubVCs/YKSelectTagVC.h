//
//  YKSelectTagVC.h
//  TTDoctor
//
//  Created by YK on 2021/10/20.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^YKSelectTagBlock)(NSString *tagIds,NSString *tagNames);

@interface YKSelectTagVC : YKBaseVC

@property (nonatomic, copy)YKSelectTagBlock block;


@end


