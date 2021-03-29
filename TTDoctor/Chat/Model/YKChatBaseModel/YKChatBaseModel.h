//
//  YKChatBaseModel.h
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKChatBaseModel : NSObject

///将字典转化为model
+ (instancetype)modelWithDic:(NSDictionary *)dic;

///将model转化为字典
- (NSDictionary *)transfromDictionary;

///获取类的所有属性名称与类型, 使用YKChatBaseModel的子类调用
+ (NSArray *)allPropertyName;

///解档
+ (instancetype)chat_unarchiveObjectWithData:(NSData *)data;

@end

@interface NSData (YKChatBaseModel)

///归档
+ (NSData *)chat_archivedDataWithModel:(YKChatBaseModel *)model;

@end

