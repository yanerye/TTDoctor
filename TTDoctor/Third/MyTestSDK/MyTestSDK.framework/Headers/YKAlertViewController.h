//
//  YKAlertViewController.h
//  MyTestSDK
//
//  Created by YK on 2021/2/1.
//  Copyright © 2021 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHYAlertButtonItem;

@interface YKAlertViewController : UIViewController

- (instancetype)initWithAlertTitle:(NSString *)title contentText:(NSString *)contentText actionButtons:(NSArray <ZHYAlertButtonItem *> *)buttons;

- (void)showAlert;

@end

@interface ZHYAlertButtonItem : NSObject
@property (nonatomic,   copy)NSString *title;
@property (nonatomic, assign)int color;
@property (nonatomic,   copy)void(^ buttonBlock)(void);
@end


