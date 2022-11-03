/*
 *  | |    | |  \ \  / /  | |    | |   / _______|
 *  | |____| |   \ \/ /   | |____| |  / /
 *  | |____| |    \  /    | |____| |  | |   _____
 *   | |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2017 Shenzhen HXHG. All rights reserved.
 */

#import "JPUSHService.h"
#import "JAdService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^JPUSHInMssageCompletion)(NSInteger iResCode);

typedef NS_ENUM(NSInteger,JPushInMessageContentType){
    JPushAdContentType = 1,         //广告类型的inMessage
    JPushNotiContentType = 2,       //通知类型的inMessage
};

typedef NS_OPTIONS(NSUInteger, JPInMessageType) {
    JPInMessageTypeBanner    = (1 << 0),   // 横幅
    JPInMessageTypeModal     = (1 << 1),   // 模态
    JPInMessageTypeFloat     = (1 << 2),   // 小浮窗
};

@protocol JPushInMessageDelegate <NSObject>

@optional
/**
 *是否允许应用内消息弹出,默认为允许
*/
- (BOOL)jPushInMessageIsAllowedInMessagePop;

/**
 *应用内消息展示的回调
*/
- (void)jPushInMessageAlreadyPop __attribute__((deprecated("JPush 3.4.0 版本已过期")));

/**
 *应用内消息已消失
*/
- (void)jPushInMessageAlreadyDisappear;


/**
 inMessage展示的回调

 @param messageType inMessage
 @param content 下发的数据，广告类的返回数据为空时返回的信息

 */
- (void)jPushInMessageAlreadyPopInMessageType:(JPushInMessageContentType)messageType Content:(NSDictionary *)content;

/**
 inMessage点击的回调

 @param messageType inMessage
 @param content 下发的数据，广告类的返回数据为空时返回的信息

 */
- (void)jpushInMessagedidClickInMessageType:(JPushInMessageContentType)messageType Content:(NSDictionary *)content;

@end


@interface JPUSHServiceDelegate : NSObject <JAdInMessageDelegate>

@property (nonatomic, weak) id <JPushInMessageDelegate> delegate;

@end


@interface JPUSHService (inapp)

/*!
* @abstract 设置应用内消息的代理
*
* @discussion 遵守JPushInMessageDelegate的代理对象
*
*/
+ (void)setInMessageDelegate:(id<JPushInMessageDelegate>)inMessageDelegate;

/*!
* @abstract 设置应用内消息的inMessageView的父控件
*
* @discussion 建议设置成当前展示的window，SDK默认取当前APP顶层的Window。
*
*/
+ (void)setInMessageSuperView:(UIView *)view;


/*!
* @abstract 主动拉取应用内消息的接口
*
* @discussion 拉取结果的回调
*
*/
+ (void)pullInMessageCompletion:(JPUSHInMssageCompletion)completion __attribute__((deprecated("JPush 3.7.0 版本已过期")));


/*!
* @abstract 主动拉取应用内消息的接口
*
* @param types 应用内消息样式
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithTypes:(NSUInteger)types completion:(JPUSHInMssageCompletion)completion __attribute__((deprecated("JPush 3.7.0 版本已过期")));


/*!
* @abstract 主动拉取应用内消息的接口
*
* @param adPosition 广告位
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithAdPosition:(NSString *)adPosition completion:(JPUSHInMssageCompletion)completion;


/*!
* @abstract 主动拉取应用内消息的接口
*
* @param params 拉取条件 可传参数: @"adPosition" -> 广告位 NSString, @"event" -> 事件 NSString
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithParams:(NSDictionary *)params completion:(JPUSHInMssageCompletion)completion;


/*!
* @abstract 通过事件触发应用内消息下发
*
* @param event 事件
*
*/
+ (void)triggerInMessageByEvent:(NSString *)event;


/*!
* @abstract  在页面切换的时候调用，告诉sdk当前切换到的页面名称
*
* @param className 当前页面的类名
*
* @discussion
 通过定向页面触发应用内消息下发的功能、黑名单功能、inapp页面延迟展示等功能都依赖于该接口调用。
 请在页面切换的时候调用此方法。确保在所有页面的viewDidAppear中调用此方法。不然可能会造成inapp部分功能不完善。建议在viewController的基类中调用，或者使用method swizzling方法交换viewController的viewDidAppear方法。
*
*/
+ (void)currentViewControllerName:(NSString *)className;


/*!
* @abstract 通过定向页面触发应用内消息下发
*
* @param pageName 当前页面的类名
*
* @discussion 请在页面切换的时候调用此方法。确保在所有页面的viewDidAppear中调用此方法。不然可能会造成该功能不完善。建议在viewController的基类中调用，或者使用method swizzling方法交换viewController的viewDidAppear方法。
*
*/
+ (void)triggerInMessageByPageChange:(NSString *)pageName __attribute__((deprecated("JPush 3.7.4 版本已过期")));


@end

NS_ASSUME_NONNULL_END
