//
//  YKChatHelper.h
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKChatHelper : NSObject

///聊天气泡
+ (UIImage *)senderBubble;
+ (UIImage *)receiverBubble;

///获取当前时间戳
+ (NSTimeInterval)nowTimestamp;

//#pragma mark - 图片缓存处理
/////加载网络图片(同步)
//+ (UIImage *)getImageWithUrl:(NSString *)url;
/////加载网络图片(异步)
//+ (void)getImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion;
/////存图片
//+ (NSString *)storeImage:(UIImage *)image forKey:(NSString *)key;
/////取图片
//+ (UIImage *)imageForKey:(NSString *)key;
/////清理内存
//+ (void)clearMemory;
/////清理所有数据
//+ (void)clearImageCacheCompletion:(void(^)(void))completion;

@end


