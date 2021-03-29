//
//  YKChatHelper.m
//  TTDoctor
//
//  Created by YK on 2020/9/1.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatHelper.h"
#import "YKInputBase64.h"

@interface YKChatHelper ()
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) UIImage *senderBubbleImage;
@property (nonatomic, strong) UIImage *receiverBubbleImage;
@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@end


@implementation YKChatHelper

+ (instancetype)helper {
    static YKChatHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YKChatHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDirectoryAtPath:self.cachePath];
    }
    return self;
}

+ (UIImage *)senderBubble {
    return [YKChatHelper helper].senderBubbleImage;
}

+ (UIImage *)receiverBubble {
    return [YKChatHelper helper].receiverBubbleImage;
}

//获取当前时间戳
+ (NSTimeInterval)nowTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    return time;
}

#pragma mark - 图片缓存处理
/**
 获取网络图片(同步)
 */
+ (UIImage *)getImageWithUrl:(NSString *)url {
    UIImage *image = [self getImageFromCacheWithUrl:url];
    if (image == nil) {
        image = [self getImageFromNetworkWithUrl:url];
    }
    return image;
}

+ (UIImage *)getImageFromCacheWithUrl:(NSString *)url {
    //1、从内存存获取
    YKChatHelper *helper = [YKChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:urlKey];
    if (image) {
        return image;
    }
    //2、从本地获取
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    if ([helper fileExistsAtPath:cachePath]) {
        image = [UIImage imageWithContentsOfFile:cachePath];
        if (image) {
            //存到内存
            [helper.memoryCache setValue:image forKey:urlKey];
            return image;
        }
    }
    return nil;
}

+ (UIImage *)getImageFromNetworkWithUrl:(NSString *)url {
    //3、从网络获取
    YKChatHelper *helper = [YKChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (imageData) {
        UIImage *urlImage = [UIImage imageWithData:imageData];
        if (urlImage) {
            //存到内存
            [helper.memoryCache setValue:urlImage forKey:urlKey];
            //存到本地
            [helper writeFile:imageData toPath:cachePath];
            return urlImage;
        }
    }
    return nil;
}

/**
 获取网络图片(异步)
 */
+ (void)getImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    if (!completion) return;
    [self getImageFromCacheWithUrl:url placeholder:placeholder completion:^(UIImage *image) {
        if (image) {
            completion(image);
        }
        else {
            [self getImageFromNetworkWithUrl:url placeholder:placeholder completion:completion];
        }
    }];
}

+ (void)getImageFromCacheWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    //1、从内存获取
    YKChatHelper *helper = [YKChatHelper helper];
    NSString *urlKey = [url input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:urlKey];
    if (image) {
        completion(image);
        return;
    }
    //2、从本地获取
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
    if ([helper fileExistsAtPath:cachePath]) {
        image = [UIImage imageWithContentsOfFile:cachePath];
        if (image) {
            //存到内存
            [helper.memoryCache setValue:image forKey:urlKey];
            completion(image);
            return;
        }
    }
    completion(nil);
}

+ (void)getImageFromNetworkWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion {
    completion(placeholder);
    //3、从网络获取
    YKChatHelper *helper = [YKChatHelper helper];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlKey = [url input_base64EncodedString];
        NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:urlKey];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (imageData) {
            UIImage *urlImage = [UIImage imageWithData:imageData];
            if (urlImage) {
                //存到内存
                [helper.memoryCache setValue:urlImage forKey:urlKey];
                //存到本地
                [helper writeFile:imageData toPath:cachePath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(urlImage);
                });
            }
        }
    });
}

+ (NSString *)storeImage:(UIImage *)image forKey:(NSString *)key {
    if (image == nil || key.length == 0) {
        NSLog(@"键值不能为空");
        return @"";
    }
    YKChatHelper *helper = [YKChatHelper helper];
    NSString *tureKey = [key input_base64EncodedString];
    //存到内存
    [helper.memoryCache setValue:image forKey:tureKey];
    //存到本地
    NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:tureKey];
    if ([helper writeFile:UIImagePNGRepresentation(image) toPath:cachePath]) {
        return cachePath;
    }
    return @"";
}

+ (UIImage *)imageForKey:(NSString *)key {
    YKChatHelper *helper = [YKChatHelper helper];
    NSString *tureKey = [key input_base64EncodedString];
    UIImage *image = [helper.memoryCache objectForKey:tureKey];
    if (image == nil) {
        NSString *cachePath = [helper.cachePath stringByAppendingPathComponent:tureKey];
        if ([helper fileExistsAtPath:cachePath]) {
            image = [UIImage imageWithContentsOfFile:cachePath];
            //存到内存
            [helper.memoryCache setValue:image forKey:key];
        }
    }
    return image;
}

+ (void)clearMemory {
    YKChatHelper *helper = [YKChatHelper helper];
    [helper.memoryCache removeAllObjects];
}

+ (void)clearImageCacheCompletion:(void(^)(void))completion {
    YKChatHelper *helper = [YKChatHelper helper];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearMemory];
        if ([helper deleteFileAtPath:helper.cachePath error:nil]) {
            [helper createDirectoryAtPath:helper.cachePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

#pragma mark - 文件管理
- (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    NSLog(@"fileExistsAtPath:文件未找到");
    return NO;
}

- (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists && isDirectory) {
        return YES;
    }
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    if (error) {
        NSLog(@"创建文件夹失败:%@",error);
    }
    return result;
}

- (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    NSLog(@"文件存储路径为:%@",path);
    return isOK;
}

- (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
    }
    NSLog(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

#pragma mark - getter
- (NSString *)cachePath {
    if (_cachePath == nil) {
        _cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatCache"];
    }
    return _cachePath;
}

- (NSMutableDictionary *)memoryCache {
    if (_memoryCache == nil) {
        _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _memoryCache;
}

//聊天气泡
- (UIImage *)senderBubbleImage {
    if (_senderBubbleImage == nil) {
        UIImage *image = [UIImage imageNamed:@"wzm_chat_bj2"];
        CGSize size = image.size;
        _senderBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _senderBubbleImage;
}

- (UIImage *)receiverBubbleImage {
    if (_receiverBubbleImage == nil) {
        UIImage *image = [UIImage imageNamed:@"wzm_chat_bj1"];
        CGSize size = image.size;
        _receiverBubbleImage = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height*0.8];
    }
    return _receiverBubbleImage;
}



@end
