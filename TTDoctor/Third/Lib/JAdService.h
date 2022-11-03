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


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIView;

typedef void (^JAdInMssageCompletion)(NSInteger iResCode);

typedef NS_ENUM(NSInteger,JAdInMessageContentType){
    JAdInMessageAdContentType = 1,         //广告类型的inMessage
    JAdInMessageNotiContentType = 2,       //通知类型的inMessage
};

typedef NS_OPTIONS(NSUInteger, JAdInMessageType) {
    JAdInMessageTypeBanner    = (1 << 0),   // 横幅
    JAdInMessageTypeModal     = (1 << 1),   // 模态
    JAdInMessageTypeFloat     = (1 << 2),   // 小浮窗
};


@protocol JAdInMessageDelegate <NSObject>

@optional
/**
 *是否允许应用内消息弹出,默认为允许
*/
- (BOOL)jAdInMessageIsAllowedInMessagePop;

/**
 *应用内消息展示的回调
*/
- (void)jAdInMessageAlreadyPop __attribute__((deprecated("JPush 3.4.0 版本已过期")));

/**
 *应用内消息已消失
*/
- (void)jAdInMessageAlreadyDisappear;

/**
 inMessage展示的回调
 
 @param messageType inMessage
 @param content 下发的数据，广告类的返回数据为空时返回的信息

 */
- (void)jAdInMessageAlreadyPopInMessageType:(JAdInMessageContentType)messageType Content:(NSDictionary *)content;

/**
 inMessage点击的回调
 
 @param messageType inMessage
 @param content 下发的数据，广告类的返回数据为空时返回的信息

 */
- (void)jAdInMessagedidClickInMessageType:(JAdInMessageContentType)messageType Content:(NSDictionary *)content;

@end

@interface JAdService : NSObject

/*!
* @abstract 设置应用内消息的代理
*
* @discussion 遵守JAdInMessageDelegate的代理对象
*
*/
+ (void)setInMessageDelegate:(id<JAdInMessageDelegate>)inMessageDelegate;

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
* @param adPosition 广告位
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithAdPosition:(NSString *)adPosition completion:(JAdInMssageCompletion)completion;


/*!
* @abstract 主动拉取应用内消息的接口
*
* @param params 拉取条件 可传参数: @"adPosition" -> 广告位 NSString, @"event" -> 事件 NSString
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithParams:(NSDictionary *)params completion:(JAdInMssageCompletion)completion;


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
* @abstract 主动拉取应用内消息的接口
*
* @discussion 拉取结果的回调
*
*/
+ (void)pullInMessageCompletion:(JAdInMssageCompletion)completion __attribute__((deprecated("JPush 3.7.0 版本已过期")));


/*!
* @abstract 主动拉取应用内消息的接口
*
* @param types 应用内消息样式
*
* @discussion 拉取结果的回调
*/
+ (void)pullInMessageWithTypes:(NSUInteger)types completion:(JAdInMssageCompletion)completion __attribute__((deprecated("JPush 3.7.0 版本已过期")));


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



#pragma mark ============================= 智能运营 自渲染 ========================

typedef NS_ENUM(NSInteger,JAdType) {
  JAdTypeUnknown = 0,    // 未知
  JAdTypeBanner = 1,     //横幅
  JAdTypeModal = 2,      //模态
  JAdTypeFloat = 3,      //悬浮
};

@class JAdNativeAd;
@class JAdNativeAdManager;
@class UIViewController;

@protocol JAdNativeAdDelegate <NSObject>

@optional

/// 自渲染广告视图可见
- (void)nativeAdDidBecomeVisible:(JAdNativeAd *)nativeAd;

/// 点击自渲染广告视图
- (void)nativeAdDidClick:(JAdNativeAd *)nativeAd withView:(UIView *_Nullable)view;

@end


@protocol JAdNativeAdManagerDelegate <NSObject>

@optional

/// 加载成功
- (void)nativeAdsManagerSuccessToLoad:(JAdNativeAdManager *)adsManager nativeAds:(NSArray<JAdNativeAd *> *_Nullable)nativeAdDataArray;

/// 加载失败
- (void)nativeAdsManager:(JAdNativeAdManager *)adsManager didFailWithError:(NSError *_Nullable)error;

@end


@interface JAdSlot : NSObject

/// 广告位 必填
@property (nonatomic, copy) NSString * adCode;

/// 广告样式 必填
@property (nonatomic, assign) JAdType adType;

@end


@interface JAdImage : NSObject

/// imageURL
@property (nonatomic, copy) NSString *imageURL;

@end


@interface JAdNativeAd : NSObject

/// 标题
@property (nonatomic, copy) NSString *adTitle;

/// 描述
@property (nonatomic, copy) NSString *adDescription;

/// 图片数组
@property (nonatomic, strong) NSArray <JAdImage *>*imageList;

/// 代理方法
@property (nonatomic, weak, readwrite, nullable) id<JAdNativeAdDelegate> delegate;

/**
 将自渲染广告视图注册给SDK

 @param containerView 广告渲染视图 required
 @param clickableViews 可点击视图 optional
 @param rootViewController 广告点击跳转根视图,跳转方式为present, required
 */
- (void)registerContainer:(UIView *)containerView withClickableViews:(NSArray<UIView *> *)clickableViews rootViewController:(UIViewController *)rootViewController;

@end


@interface JAdNativeAdManager : NSObject

/// 广告位信息
@property (nonatomic, strong, readwrite, nullable) JAdSlot *adslot;

/// 超时时间,默认3秒超时
@property (nonatomic, assign) NSTimeInterval timeout;

/// 请求的条数，默认为1
@property (nonatomic, assign) NSInteger adCount;

/// 代理方法
@property (nonatomic, weak, readwrite, nullable) id<JAdNativeAdManagerDelegate> delegate;

- (instancetype)initWithSlot:(JAdSlot *)slot;

/// 请求广告
- (void)loadAdData;

@end

NS_ASSUME_NONNULL_END
