//
//  YKSelectMainSymptomVC.h
//  TTDoctor
//
//  Created by YK on 2021/10/21.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^YKSelectMainSymptomBlock)(NSString *goodEntityIds,NSString *goodEntityNames);

@interface YKSelectMainSymptomVC : YKBaseVC

@property (nonatomic, copy)YKSelectMainSymptomBlock block;


@end

