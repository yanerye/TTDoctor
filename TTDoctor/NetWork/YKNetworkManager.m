//
//  YKNetworkManager.m
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKNetworkManager.h"

@implementation YKNetworkManager


+ (instancetype)manager {
    static YKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)requestApi:(NSString *)apiURL method:(RequestMethod)method params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
//    manager.requestSerializer.timeoutInterval = 15.f;
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, apiURL];

    switch (method) {
        case RequestMethodGET: {
            [manager GET:fullURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
            break;
        }
        case RequestMethodPOST: {
            [manager POST:fullURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}



@end
