//
//  YKChatSqliteManager.h
//  TTDoctor
//
//  Created by YK on 2020/9/2.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKChatSqliteManager : NSObject

+ (instancetype)defaultManager;
- (BOOL)createTableName:(NSString *)tableName modelClass:(Class)modelClass;
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName;
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;

- (long)execute:(NSString *)sql;
- (BOOL)deleteDataBase:(NSError **)error;
- (BOOL)deleteTableName:(NSString *)tableName;
- (NSMutableArray *)selectWithSql:(NSString *)sql;

@end


