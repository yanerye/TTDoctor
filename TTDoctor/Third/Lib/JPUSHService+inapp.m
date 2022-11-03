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

#import "JPUSHService+inapp.h"

@implementation JPUSHServiceDelegate

static JPUSHServiceDelegate *serviceDelegate = nil;
+ (instancetype)sharedInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    serviceDelegate = [[JPUSHServiceDelegate alloc] init];
  });
  return serviceDelegate;
}

- (void)jAdInMessageAlreadyDisappear {
  if (self.delegate && [self.delegate respondsToSelector:@selector(jPushInMessageAlreadyDisappear)]) {
    [self.delegate jPushInMessageAlreadyDisappear];
  }
}

- (void)jAdInMessageAlreadyPopInMessageType:(JAdInMessageContentType)messageType Content:(NSDictionary *)content {
  if (self.delegate && [self.delegate respondsToSelector:@selector(jPushInMessageAlreadyPopInMessageType:Content:)]) {
    [self.delegate jPushInMessageAlreadyPopInMessageType:(JPushInMessageContentType)messageType Content:content];
  }
}

- (BOOL)jAdInMessageIsAllowedInMessagePop {
  if (self.delegate && [self.delegate respondsToSelector:@selector(jPushInMessageIsAllowedInMessagePop)]) {
    return [self.delegate jPushInMessageIsAllowedInMessagePop];
  }
  return YES;
}

- (void)jAdInMessagedidClickInMessageType:(JAdInMessageContentType)messageType Content:(NSDictionary *)content {
  if (self.delegate && [self.delegate respondsToSelector:@selector(jpushInMessagedidClickInMessageType:Content:)]) {
    return [self.delegate jpushInMessagedidClickInMessageType:(JPushInMessageContentType)messageType Content:content];
  }
}

- (void)jAdInMessageAlreadyPop {
  if (self.delegate && [self.delegate respondsToSelector:@selector(jPushInMessageAlreadyPop)]) {
    return [self.delegate jPushInMessageAlreadyPop];
  }
}

@end


@implementation JPUSHService (inapp)

#pragma mark - InMessage
+ (void)setInMessageDelegate:(id<JPushInMessageDelegate>)inMessageDelegate{
  JPUSHServiceDelegate *serviceDelegate = [JPUSHServiceDelegate sharedInstance];
  serviceDelegate.delegate = inMessageDelegate;
  [JAdService setInMessageDelegate:serviceDelegate];
}

+ (void)pullInMessageCompletion:(JPUSHInMssageCompletion)completion{
  [JAdService pullInMessageCompletion:completion];
}

+ (void)pullInMessageWithTypes:(NSUInteger)types completion:(JPUSHInMssageCompletion)completion{
  [JAdService pullInMessageWithTypes:types completion:completion];
}

+ (void)setInMessageSuperView:(UIView *)view{
  [JAdService setInMessageSuperView:view];
}

+ (void)pullInMessageWithAdPosition:(NSString *)adPosition completion:(JPUSHInMssageCompletion)completion{
  [JAdService pullInMessageWithAdPosition:adPosition completion:completion];
}

+ (void)pullInMessageWithParams:(NSDictionary *)params completion:(JPUSHInMssageCompletion)completion {
  [JAdService pullInMessageWithParams:params completion:completion];
}

+ (void)triggerInMessageByEvent:(NSString *)event {
  [JAdService triggerInMessageByEvent:event];
}

+ (void)triggerInMessageByPageChange:(NSString *)pageName {
  [JAdService triggerInMessageByPageChange:pageName];
}

+ (void)currentViewControllerName:(NSString *)className{
  [JAdService currentViewControllerName:className];
}

@end
