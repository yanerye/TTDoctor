//
//  YKDoctor.h
//  TTDoctor
//
//  Created by YK on 2020/6/15.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKDoctor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *doctorID;//ID
@property (nonatomic, copy) NSString *userId;//userID
@property (nonatomic, copy) NSString *familyname;//姓名
@property (nonatomic, copy) NSString *contactway;//手机号
@property (nonatomic, copy) NSString *picUrl;//头像地址
@property (nonatomic, copy) NSString *province;//省份
@property (nonatomic, copy) NSString *hospitalName;//医院
@property (nonatomic, copy) NSString *deptName;//科室
@property (nonatomic, copy) NSString *patientAreaName;//病区
@property (nonatomic, copy) NSString *professionalRanksName;//职称
@property (nonatomic, copy) NSString *selfInfo;//自我介绍
@property (nonatomic, copy) NSString *docEntityName;//擅长病种
@property (nonatomic, copy) NSString *sign;//公告
@property (nonatomic, copy) NSString *qrUrl;//微信二维码
@property (nonatomic, copy) NSString *sexual;//性别
@property (nonatomic, copy) NSString *email;//邮箱
@property (nonatomic, copy) NSString *wechatNo;//微信号
@property (nonatomic, copy) NSString *type;//医生类型 （0代表正常录入的医生、1代表免费义诊的医生、2代表心肺专家医生 3、代表注册的医生 4、审核未通过） 有可能同时为1和2    如果type为3判断registerType  1为审核中  不是1为未开通 （不是3 不需要去判断）
@property (nonatomic, copy) NSString *registerType;//审核状态 1为审核中  不是1为未开通


- (instancetype )initDoctorMessgaeWithDictionaty:(NSDictionary *)dict;

@end

