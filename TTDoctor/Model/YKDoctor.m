//
//  YKDoctor.m
//  TTDoctor
//
//  Created by YK on 2020/6/15.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKDoctor.h"

@implementation YKDoctor

- (instancetype)initDoctorMessgaeWithDictionaty:(NSDictionary *)dict{
    
    if (self == [super init]) {
        if (![dict isKindOfClass:[NSNull class]] && ![dict isEqual:[NSNull null]]) {
            self.doctorID = [NSString stringWithFormat:@"%@",dict[@"id"]];
            self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
            self.familyname = [NSString stringWithFormat:@"%@",dict[@"familyname"]];
            self.contactway = [NSString stringWithFormat:@"%@",dict[@"contactway"]];
            self.picUrl = [NSString stringWithFormat:@"%@",dict[@"picUrl"]];
            self.province = [NSString stringWithFormat:@"%@",dict[@"province"]];
            self.hospitalName = [NSString stringWithFormat:@"%@",dict[@"hospitalName"]];
            self.deptName = [NSString stringWithFormat:@"%@",dict[@"deptName"]];
            self.patientAreaName = [NSString stringWithFormat:@"%@",dict[@"patientAreaName"]];
            self.professionalRanksName = [NSString stringWithFormat:@"%@",dict[@"professionalRanksName"]];
            self.docEntityName = [NSString stringWithFormat:@"%@",dict[@"docEntityName"]];
            self.selfInfo = [NSString stringWithFormat:@"%@",dict[@"selfInfo"]];
            self.sign = [NSString stringWithFormat:@"%@",dict[@"sign"]];
            self.qrUrl = [NSString stringWithFormat:@"%@",dict[@"qrUrl"]];
            self.sexual = [NSString stringWithFormat:@"%@",dict[@"sexual"]];
            self.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
            self.wechatNo = [NSString stringWithFormat:@"%@",dict[@"wechatNo"]];
            self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            self.registerType = [NSString stringWithFormat:@"%@",dict[@"registerType"]];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    if (self == [super init]) {
        self.doctorID = [coder decodeObjectForKey:@"doctorID"];
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.familyname = [coder decodeObjectForKey:@"familyname"];
        self.contactway = [coder decodeObjectForKey:@"contactway"];
        self.picUrl = [coder decodeObjectForKey:@"picUrl"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.hospitalName = [coder decodeObjectForKey:@"hospitalName"];
        self.deptName = [coder decodeObjectForKey:@"deptName"];
        self.patientAreaName = [coder decodeObjectForKey:@"patientAreaName"];
        self.professionalRanksName = [coder decodeObjectForKey:@"professionalRanksName"];
        self.docEntityName = [coder decodeObjectForKey:@"docEntityName"];
        self.selfInfo = [coder decodeObjectForKey:@"selfInfo"];
        self.sign = [coder decodeObjectForKey:@"sign"];
        self.qrUrl = [coder decodeObjectForKey:@"qrUrl"];
        self.sexual = [coder decodeObjectForKey:@"sexual"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.wechatNo = [coder decodeObjectForKey:@"wechatNo"];
        self.type = [coder decodeObjectForKey:@"type"];
        self.registerType = [coder decodeObjectForKey:@"registerType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.doctorID forKey:@"doctorID"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.familyname forKey:@"familyname"];
    [coder encodeObject:self.contactway forKey:@"contactway"];
    [coder encodeObject:self.picUrl forKey:@"picUrl"];
    [coder encodeObject:self.province forKey:@"province"];
    [coder encodeObject:self.hospitalName forKey:@"hospitalName"];
    [coder encodeObject:self.deptName forKey:@"deptName"];
    [coder encodeObject:self.patientAreaName forKey:@"patientAreaName"];
    [coder encodeObject:self.professionalRanksName forKey:@"professionalRanksName"];
    [coder encodeObject:self.docEntityName forKey:@"docEntityName"];
    [coder encodeObject:self.selfInfo forKey:@"selfInfo"];
    [coder encodeObject:self.sign forKey:@"sign"];
    [coder encodeObject:self.qrUrl forKey:@"qrUrl"];
    [coder encodeObject:self.sexual forKey:@"sexual"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.wechatNo forKey:@"wechatNo"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.registerType forKey:@"registerType"];
}

@end
