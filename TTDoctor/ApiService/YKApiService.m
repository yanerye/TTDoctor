//
//  YKApiService.m
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKApiService.h"
#import "YKNetworkManager.h"

NSString * const ResponseCodeKey = @"success";
NSString * const ResponseMessageKey = @"content";
NSString * const ResponseDataKey = @"map";

NSString * const ResponseDataErrorHint = @"数据格式有误";
NSString * const ServerOrNetworkErrorHint = @"网络出了点问题";

#define DOCTORID [YKDoctorHelper doctorID]
#define USERID [YKDoctorHelper userID]

@implementation YKApiService

+ (instancetype)service {
    static YKApiService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

/**
 POST请求处理
 
 @param apiURLString 请求地址
 @param params 请求参数
 @param completion 完成回调
 */
- (void)POST:(NSString *)apiURLString params:(NSDictionary *)params completion:(YKCompletionBlock)completion {
    
    [[YKNetworkManager manager] requestApi:apiURLString method:RequestMethodPOST params:params success:^(id responseObject) {
        
        //判断返回数据是不是字典
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 不是直接回调数据
            completion(responseObject, nil);
        }else{
            //是字典处理数据
            NSDictionary *responseDict = responseObject;
            if([responseDict objectForKey:ResponseCodeKey]) {
                NSInteger responseCode = [responseDict[ResponseCodeKey] integerValue];
                if (responseCode == 1) {
                    completion(responseDict[ResponseDataKey], nil);
                } else {
                    NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:responseCode userInfo:@{NSLocalizedFailureReasonErrorKey:responseDict[ResponseMessageKey]}];
                    completion(responseDict[ResponseDataKey], err);
                }
            } else {
                completion(responseObject, nil);
            }

        }
        
    } failure:^(NSError *error) {
        NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:YKResponseDataErrorCode userInfo:@{NSLocalizedFailureReasonErrorKey:ServerOrNetworkErrorHint}];
        completion(nil, err);
    }];
}




#pragma mark -登录注册忘记密码

/**
 用户登录
 
 */

- (void)loginWithTelephone:(NSString *)telephone passwprd:(NSString *)passwprd completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/user/login.do";
    
    NSDictionary *params = @{@"userName": telephone,
                             @"password": passwprd,
                             };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark -首页


/**
 首页公告
 
 */

- (void)getAnnouncementListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/announcement/list.do";
    
    NSDictionary *params = @{@"category": @"0",
                             @"peopleId":DOCTORID
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 更多公告
 
 */

- (void)getAnnouncementListWithStartPage:(NSString *)startPage completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/announcement/moreList.do";
    
    NSDictionary *params = @{@"category": @"0",
                             @"peopleId":DOCTORID,
                             @"pageSize":@"10",
                             @"start":startPage
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 首页根据患者姓名获取随访列表
 
 */

- (void)getFollowUPListWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime projectId:(NSString *)projectId patientName:(NSString *)patientName Completion:(YKCompletionBlock)completion{
    
    NSString *apiURLString = @"/client/common/doctorHomePageBussiness.do";
    
    NSDictionary *params = @{@"userId":USERID,
                             @"beginTime":beginTime,
                             @"endTime":endTime,
                             @"projectId":projectId,
                             @"patientName":patientName
                             };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark -患者

/**
 患者列表
 
 */

- (void)getPatientListWithPatientName:(NSString *)patientName page:(NSString*)page startpage:(NSString*)startpage tagIds:(NSString *)tagIds primarySymptom:(NSString *)primarySymptom beginAge:(NSString *)beginAge endAge:(NSString *)endAge sex:(NSString *)sex orderParam:(NSString *)orderParam projectId:(NSString *)projectId completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorPatient/listByConditionPageV24.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"patientName":patientName,
                             @"pageNumber":page,
                             @"start":startpage,
                             @"pageSize":@"10",
                             @"tagIds":tagIds,
                             @"primarySymptom":primarySymptom,
                             @"beginAge":beginAge,
                             @"endAge":endAge,
                             @"sex":sex,
                             @"orderParam":orderParam,
                             @"projectId":projectId
                             };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark - 随访列表

/**
我的问卷

*/

- (void)getMyQuestionnaireWithQuestionnaireName:(NSString *)questionnaireName startPage:(NSString *)startPage completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorLibrary/list.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"name":questionnaireName,
                             @"start":startPage,
                             @"pageSize":@"10"
                             };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark - 病例登记

/**
 项目列表
 
 */

- (void)getCaseRecordListWithStartPage:(NSString *)startPage completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/research/getProjectListByDoctorId.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"start":startPage,
                             @"pageSize":@"10"
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 项目详情
 
 */

- (void)getProjectDetailWithIsSpecialMember:(BOOL)isSpecialMember ProjectID:(NSString *)projectID startPage:(NSString *)startPage patientName:(NSString *)patientName groupNumber:(NSString *)groupNumber address:(NSString *)address communityHospital:(NSString *)communityHospital sex:(NSString *)sex minAge:(NSString *)minAge maxAge:(NSString *)maxAge doctorName:(NSString *)doctorName typeName:(NSString *)typeName patientNumber:(NSString *)patientNumber caseRandom:(NSString *)caseRandom nameAbc:(NSString *)nameAbc startDate:(NSString *)startDate endDate:(NSString *)endDate projectPlanMainId:(NSString *)projectPlanMainId orderParam:(NSString *)orderParam status:(NSString *)status completion:(YKCompletionBlock)completion{
    NSString *apiURLString;
    
    if (isSpecialMember) {
        apiURLString = @"/client/vdoctorPatient/listExistByProjectSc.do";
    }else{
        apiURLString = @"/client/vdoctorPatient/listExistByProject.do";
    }
    NSDictionary *params = @{
                          @"userId":USERID,
                          @"projectId":projectID,
                          @"start":startPage,
                          @"pageSize":@"10",
                          @"patientName":patientName,
                          @"groupNumber":groupNumber,
                          @"address":address,
                          @"communityHospital":communityHospital,
                          @"sex":sex,
                          @"minAge":minAge,
                          @"maxAge":maxAge,
                          @"doctorName":doctorName,
                          @"typeName":typeName,
                          @"patientNumber":patientNumber,
                          @"caseRandom":caseRandom,
                          @"nameAbc":nameAbc,
                          @"startDate":startDate,
                          @"endDate":endDate,
                          @"projectPlanMainId":projectPlanMainId,
                          @"orderParam":orderParam,
                          @"status":status
                          };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark - 个人中心 - 账户与安全

/**
 
 更改医生头像
 */

- (void)updateDoctorImageWithImageData:(NSString *)imageData completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/user/alterPic.do";
    
    NSDictionary *params = @{@"userId":USERID,
                             @"data":imageData
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 更改密码
 */

- (void)updatePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/user/alterPwd.do";
    
    NSDictionary *params = @{@"userId":USERID,
                             @"oldPwd":oldPassword,
                             @"newPwd":newPassword
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 省份列表
 */

- (void)getProvinceListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/dictionary/show.do";
    
    NSDictionary *params = @{@"code":@"allcity"
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 医院列表
 */

- (void)getHospitalListWithProvince:(NSString *)province hospitalName:(NSString *)hospitalName completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/hospital/getHospitalByProvince.do";
    
    NSDictionary *params = @{@"province":province,
                             @"hospitalName":hospitalName
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 科室列表
 */

- (void)getDepartMentListWithDeptName:(NSString *)deptName completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/dept/deptList.do";
    
    NSDictionary *params = @{@"deptName":deptName
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 病区列表
 */

- (void)getPatientAreaListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/dictionary/show.do";
    
    NSDictionary *params = @{@"code":@"patientArea"
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 职称列表
 */

- (void)getProfessionalListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/diagnosis/professionRanksList.do";
    
    [self POST:apiURLString params:nil completion:completion];
}

/**
 
 更改基本信息
 */

- (void)updateDoctorBaseInfoWithKeyStr:(NSString *)keyStr valueStr:(NSString *)valueStr completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorInfo/updateSelf.do";
    
    NSDictionary *params = @{keyStr:valueStr,
                             @"id":DOCTORID
                             };
    [self POST:apiURLString params:params completion:completion];
}

#pragma mark - 个人中心 - 服务设置

/**
 
 更改自我介绍
 */

- (void)updateDoctorSelfIntroduceWithContent:(NSString *)content completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorInfo/updateSelfInfo.do";
    
    NSDictionary *params = @{@"selfInfo":content,
                             @"id":DOCTORID
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 更改诊所公告
 */

- (void)updateClinicNoticeWithContent:(NSString *)content completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorInfo/updateSign.do";
    
    NSDictionary *params = @{@"sign":content,
                             @"id":DOCTORID
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 获取病种列表
 */

- (void)getDiseasesTypeListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/common/list.do";
    
    NSDictionary *params = @{@"type":@"0",
                             @"articletypeDate":@"0",
                             @"entitytagsDate":@"0"
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 保存擅长病种
 */

- (void)saveskilledDiseasesWithGoodsIDs:(NSString *)goodIDs completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/doctorInfo/set.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"goodEntity":goodIDs
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 快捷回复列表
 */

- (void)getQuickReplyListCompletion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/answerTemplate/list.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 添加快捷回复
 */

- (void)addQuickReplyWithContent:(NSString *)content completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/answerTemplate/save.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"content":content
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 删除快捷回复
 */

- (void)deleteQuickReplyWithReplyID:(NSString *)replyID completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/answerTemplate/delete.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"id":replyID
                             };
    [self POST:apiURLString params:params completion:completion];
}

/**
 
 修改快捷回复
 */

- (void)updateQuickReplyWithReplyID:(NSString *)replyID content:(NSString *)content completion:(YKCompletionBlock)completion{
    NSString *apiURLString = @"/client/answerTemplate/update.do";
    
    NSDictionary *params = @{@"doctorId":DOCTORID,
                             @"id":replyID,
                             @"content":content
                             };
    [self POST:apiURLString params:params completion:completion];
}

@end
