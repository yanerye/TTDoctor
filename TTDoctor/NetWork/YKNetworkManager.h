//
//  YKNetworkManager.h
//  TTDoctor
//
//  Created by YK on 2020/6/8.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
};


@interface YKNetworkManager : NSObject

@property (nonatomic, copy) NSString *baseURL;

+ (instancetype)manager;

- (void)requestApi:(NSString * )apiURL method:(RequestMethod)method params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end


