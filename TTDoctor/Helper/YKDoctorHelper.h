//
//  YKDoctorHelper.h
//  TTDoctor
//
//  Created by YK on 2020/6/15.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKDoctor.h"

@interface YKDoctorHelper : NSObject

+(YKDoctor *)shareDoctor;//读取医生信息
+(void)saveShareDoctorForNet:(NSDictionary *)doctorJSON;//缓存医生信息

+(NSString *)doctorID;//获取医生ID
+(NSString *)userID;//获取userID
+(void)clearDoctor;//清理缓存

+(void)updateDoctorWithDoctor:(YKDoctor *)doctor;//更新信息

@end


