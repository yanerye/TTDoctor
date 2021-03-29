//
//  YKApiService.h
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YKCompletionBlock)(id responseObject, NSError *error);

typedef NS_ENUM(NSUInteger, ESErrorCode) {
    YKResponseDataErrorCode = -2003,
    YKServerOrNetworkErrorCode = -2004
};

@interface YKApiService : NSObject

+ (instancetype)service;

#pragma mark -登录注册忘记密码

/**
 用户登录
 
 */

- (void)loginWithTelephone:(NSString *)telephone passwprd:(NSString *)passwprd completion:(YKCompletionBlock)completion;

#pragma mark -首页

/**
 首页公告
 
 */

- (void)getAnnouncementListCompletion:(YKCompletionBlock)completion;

/**
 更多公告
 
 */

- (void)getAnnouncementListWithStartPage:(NSString *)startPage completion:(YKCompletionBlock)completion;

/**
 首页根据患者姓名获取随访列表
 
 */

- (void)getFollowUPListWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime projectId:(NSString *)projectId patientName:(NSString *)patientName Completion:(YKCompletionBlock)completion;

#pragma mark -患者

/**
 患者列表
 
 */

- (void)getPatientListWithPatientName:(NSString *)patientName page:(NSString*)page startpage:(NSString*)startpage tagIds:(NSString *)tagIds primarySymptom:(NSString *)primarySymptom beginAge:(NSString *)beginAge endAge:(NSString *)endAge sex:(NSString *)sex orderParam:(NSString *)orderParam projectId:(NSString *)projectId completion:(YKCompletionBlock)completion;


#pragma mark - 随访列表


/**
 我的问卷
 
 */

- (void)getMyQuestionnaireWithQuestionnaireName:(NSString *)questionnaireName startPage:(NSString *)startPage completion:(YKCompletionBlock)completion;

#pragma mark - 病例登记

/**
 项目列表
 
 */

- (void)getCaseRecordListWithStartPage:(NSString *)startPage completion:(YKCompletionBlock)completion;

/**
 项目详情
 
 */

- (void)getProjectDetailWithIsSpecialMember:(BOOL)isSpecialMember ProjectID:(NSString *)projectID startPage:(NSString *)startPage patientName:(NSString *)patientName groupNumber:(NSString *)groupNumber address:(NSString *)address communityHospital:(NSString *)communityHospital sex:(NSString *)sex minAge:(NSString *)minAge maxAge:(NSString *)maxAge doctorName:(NSString *)doctorName typeName:(NSString *)typeName patientNumber:(NSString *)patientNumber caseRandom:(NSString *)caseRandom nameAbc:(NSString *)nameAbc startDate:(NSString *)startDate endDate:(NSString *)endDate projectPlanMainId:(NSString *)projectPlanMainId orderParam:(NSString *)orderParam status:(NSString *)status completion:(YKCompletionBlock)completion;


#pragma mark - 个人中心 - 账户与安全


/**
 
 更改医生头像
 */

- (void)updateDoctorImageWithImageData:(NSString *)imageData completion:(YKCompletionBlock)completion;


/**
 
 更改密码
 */

- (void)updatePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(YKCompletionBlock)completion;

/**
 
 省份列表
 */

- (void)getProvinceListCompletion:(YKCompletionBlock)completion;

/**
 
 医院列表
 */

- (void)getHospitalListWithProvince:(NSString *)province hospitalName:(NSString *)hospitalName completion:(YKCompletionBlock)completion;

/**
 
 科室列表
 */

- (void)getDepartMentListWithDeptName:(NSString *)deptName completion:(YKCompletionBlock)completion;

/**
 
 病区列表
 */

- (void)getPatientAreaListCompletion:(YKCompletionBlock)completion;

/**
 
 职称列表
 */

- (void)getProfessionalListCompletion:(YKCompletionBlock)completion;

/**
 
 更改基本信息
 */

- (void)updateDoctorBaseInfoWithKeyStr:(NSString *)keyStr valueStr:(NSString *)valueStr completion:(YKCompletionBlock)completion;

#pragma mark - 个人中心 - 服务设置

/**
 
 更改自我介绍
 */

- (void)updateDoctorSelfIntroduceWithContent:(NSString *)content completion:(YKCompletionBlock)completion;

/**
 
 更改诊所公告
 */

- (void)updateClinicNoticeWithContent:(NSString *)content completion:(YKCompletionBlock)completion;

/**
 
 获取病种列表
 */

- (void)getDiseasesTypeListCompletion:(YKCompletionBlock)completion;

/**
 
 保存擅长病种
 */

- (void)saveskilledDiseasesWithGoodsIDs:(NSString *)goodIDs completion:(YKCompletionBlock)completion;

/**
 
 快捷回复列表
 */

- (void)getQuickReplyListCompletion:(YKCompletionBlock)completion;

/**
 
 添加快捷回复
 */

- (void)addQuickReplyWithContent:(NSString *)content completion:(YKCompletionBlock)completion;

/**
 
 删除快捷回复
 */

- (void)deleteQuickReplyWithReplyID:(NSString *)replyID completion:(YKCompletionBlock)completion;

/**
 
 修改快捷回复
 */

- (void)updateQuickReplyWithReplyID:(NSString *)replyID content:(NSString *)content completion:(YKCompletionBlock)completion;

@end


