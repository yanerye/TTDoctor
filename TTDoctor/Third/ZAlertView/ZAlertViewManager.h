//
//  ZAlertViewManager.h
//  顶部提示
//
//  Created by YYKit on 2017/5/27.
//  Copyright © 2017年 YZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAlertView.h"

typedef void(^SelectedAlertView)();
@interface ZAlertViewManager : NSObject
@property (nonatomic,strong)ZAlertView *alertView;
+ (ZAlertViewManager *)shareManager;

@property (nonatomic,assign) NSInteger dismissTime;
- (void)showWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time;

@property (nonatomic,copy) SelectedAlertView didselectedAlertViewBlock;
- (void)didSelectedAlertViewWithBlock:(SelectedAlertView) didselectedAlertViewBlock;
@end
