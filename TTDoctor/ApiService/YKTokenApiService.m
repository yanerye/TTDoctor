//
//  YKTokenApiService.m
//  TTDoctor
//
//  Created by YK on 2022/4/12.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKTokenApiService.h"


@implementation YKTokenApiService

+ (instancetype)service {
    static YKTokenApiService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (void)requestWithMethod:(NSString *)method fullURL:(NSString *)fullURL params:(NSDictionary *)params completion:(YKTokenCompletionBlock)completion{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:fullURL parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    if (accessToken.length > 0) {
        [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            completion(responseObject[@"data"],nil);
        }else{
            NSString *errorStr = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:YKResponseDataErrorCode userInfo:@{NSLocalizedFailureReasonErrorKey:errorStr}];
            completion(nil,err);
        }
     }];
     [task resume];
}



#pragma mark -登录

/**
 用户登录
 
 */

- (void)loginWithTelephone:(NSString *)telephone password:(NSString *)password requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion{
    NSString *apiURL = @"/app/auth/v2.0/login";
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",TOKEN_SERVER,apiURL];
    NSDictionary *params = @{
        @"client":@"2",
        @"mobile": telephone,
        @"password": password,
    };
    [self requestWithMethod:requestMethod fullURL:fullURL params:params completion:completion];
}

#pragma mark -个人中心

/**
 退出登录
 
 */

- (void)loginOutWithRequestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion{
    NSString *apiURL = @"/app/auth/v2.0/logout";
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",TOKEN_SERVER,apiURL];
    [self requestWithMethod:requestMethod fullURL:fullURL params:nil completion:completion];
}

#pragma mark - 聊天

/**
 发送文字
 
 */

- (void)sendMessageWithChatId:(NSString *)chatId content:(NSString *)content requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion{
    NSString *apiURL = @"/app/chat-record/v2.0/send";
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",TOKEN_SERVER,apiURL];
    NSDictionary *params = @{
        @"chatId":chatId,
        @"client":@"1",
        @"quessionId": @"",
        @"type": @"2",
        @"content":content
    };
    [self requestWithMethod:requestMethod fullURL:fullURL params:params completion:completion];
}

/**
 发送图片
 
 */

- (void)sendImageWithChatId:(NSString *)chatId content:(NSString *)content suffix:(NSString *)suffix requestMethod:(NSString *)requestMethod completion:(YKTokenCompletionBlock)completion{
    NSString *apiURL = @"/app/chat-record/v2.0/send";
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",TOKEN_SERVER,apiURL];
    NSDictionary *params = @{
        @"chatId":chatId,
        @"client":@"1",
        @"quessionId": @"",
        @"type": @"1",
        @"content":content,
        @"suffix":suffix
    };
    [self requestWithMethod:requestMethod fullURL:fullURL params:params completion:completion];
}

@end
