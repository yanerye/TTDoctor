//
//  YKBaseVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/5.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKBaseVC : UIViewController

- (void)addLeftBackNavigationItemWithImageName:(NSString *)imageName;
- (void)addLeftCloseNavigationItemWithImageName:(NSString *)imageName;

- (void)createRefreshWithTableView:(UITableView *)myTable;
-(void)startRefresh;


@end


