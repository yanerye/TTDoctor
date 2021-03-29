//
//  YKChatDBManager.m
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatDBManager.h"
#import "YKChatSqliteManager.h"
#import "YKChatMessageModel.h"

NSString *const WZM_USER    = @"wzm_user";

@implementation YKChatDBManager

+ (instancetype)DBManager {
    static YKChatDBManager *DBManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBManager = [[YKChatDBManager alloc] init];
    });
    return DBManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //创建三张表 user表
        [[YKChatSqliteManager defaultManager] createTableName:WZM_USER modelClass:[YKChatUserModel class]];
    }
    return self;
}

#pragma mark - user表操纵
//所有用户
- (NSMutableArray *)users {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",WZM_USER];
    NSArray *list = [[YKChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *dic in list) {
        YKChatUserModel *model = [YKChatUserModel modelWithDic:dic];
        [arr addObject:model];
    }
    return arr;
}

//添加用户
- (void)insertUserModel:(YKChatUserModel *)model {
    [[YKChatSqliteManager defaultManager] insertModel:model tableName:WZM_USER];
}

//更新用户
- (void)updateUserModel:(YKChatUserModel *)model {
    [[YKChatSqliteManager defaultManager] updateModel:model tableName:WZM_USER primkey:@"uid"];
}

//查询用户
- (YKChatUserModel *)selectUserModel:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = '%@'",WZM_USER,uid];
    NSArray *list = [[YKChatSqliteManager defaultManager] selectWithSql:sql];
    if (list.count > 0) {
        YKChatUserModel *model = [YKChatUserModel modelWithDic:list.firstObject];
        return model;
    }
    return nil;
}

//删除用户
- (void)deleteUserModel:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = '%@'",WZM_USER,uid];
    [[YKChatSqliteManager defaultManager] execute:sql];
    //同时删除对应的会话和消息记录
    [self deleteMessageWithUid:uid];
}

#pragma mark - message表操纵

//删除私聊消息记录
- (void)deleteMessageWithUid:(NSString *)uid {
    NSString *tableName = [self tableNameWithUid:uid];
    [[YKChatSqliteManager defaultManager] deleteTableName:tableName];
}

//私聊消息
- (NSMutableArray *)messagesWithUser:(YKChatUserModel *)model {
    return [self messagesWithModel:model];
}

//private
- (NSMutableArray *)messagesWithModel:(YKChatUserModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY timestmp DESC LIMIT 100",tableName];
    NSArray *list = [[YKChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSInteger i = 0; i < list.count; i ++) {
        NSDictionary *dic = list[i];
        YKChatMessageModel *model = [YKChatMessageModel modelWithDic:dic];
        
        [arr insertObject:model atIndex:i];
    }
    return arr;
}

//插入私聊消息
- (void)insertMessage:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model {
    [self insertMessage:message chatWithModel:model];
}


//private
- (void)insertMessage:(YKChatMessageModel *)message chatWithModel:(YKChatUserModel *)model{
    NSString *tableName = [self tableNameWithModel:model];
    [[YKChatSqliteManager defaultManager] createTableName:tableName modelClass:[message class]];
    [[YKChatSqliteManager defaultManager] insertModel:message tableName:tableName];
}

//更新私聊消息
- (void)updateMessageModel:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    [[YKChatSqliteManager defaultManager] updateModel:message tableName:tableName primkey:@"mid"];
}


//删除私聊消息
- (void)deleteMessageModel:(YKChatMessageModel *)message chatWithUser:(YKChatUserModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    [[YKChatSqliteManager defaultManager] deleteModel:message tableName:tableName primkey:@"mid"];
}

//private
- (NSString *)tableNameWithModel:(YKChatUserModel *)model {
    return [self tableNameWithUid:model.uid];
}

- (NSString *)tableNameWithUid:(NSString *)uid {
    return [NSString stringWithFormat:@"user_%@",uid];
}




@end
