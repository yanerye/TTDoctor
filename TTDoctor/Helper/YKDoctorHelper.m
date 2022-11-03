//
//  YKDoctorHelper.m
//  TTDoctor
//
//  Created by YK on 2020/6/15.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKDoctorHelper.h"
#import "YKDoctor.h"
#import "YYCache.h"

static NSString *const YKDoctorPath = @"doctor";
static NSString *const YKDoctorCacheKey = @"YKDoctorTMCacheKey";

@implementation YKDoctorHelper

+ (YKDoctor *)shareDoctor
{
    static YKDoctor *doctor = nil;
    
    id docCache = [self dataWithCachekey:YKDoctorCacheKey path:YKDoctorPath];
    if(docCache) {
        doctor =(YKDoctor *)docCache;
    }
    return doctor;
}

+ (void)saveShareDoctorForNet:(NSDictionary *)doctorJSON
{
    YKDoctor *doctor = [[YKDoctor alloc] initDoctorMessgaeWithDictionaty:doctorJSON];
    //缓存在硬盘
    [self setData:doctor withCachekey:YKDoctorCacheKey path:YKDoctorPath];
}


+ (id)dataWithCachekey:(NSString *)cachekey path:(NSString *)path {
    return [[[YYCache alloc] initWithName:path] objectForKey:cachekey];
}


+ (void)setData:(id)data withCachekey:(NSString *)cachekey path:(NSString *)path {
    
    YYCache *cache = [[YYCache alloc] initWithName:path];
    [cache setObject:data forKey:cachekey];
}

+ (NSString *)doctorID{
    YKDoctor *doctor = [self shareDoctor];
    if (doctor.doctorID.length == 0 || doctor == nil) {
        return @"";
    }
    return doctor.doctorID;
}

+(NSString *)userID{
    YKDoctor *doctor = [self shareDoctor];
    if (doctor.userId.length == 0 || doctor == nil) {
        return @"";
    }
    return doctor.userId;
}

+ (void)clearDoctor{
    YYCache *cache = [[YYCache alloc] initWithName:YKDoctorPath];
    [cache removeAllObjects];
}

+(void)updateDoctorWithDoctor:(YKDoctor *)doctor{
    [self setData:doctor withCachekey:YKDoctorCacheKey path:YKDoctorPath];
}



@end
