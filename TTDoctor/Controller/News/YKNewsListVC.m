//
//  YKNewsListVC.m
//  TTDoctor
//
//  Created by YK on 2022/4/19.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKNewsListVC.h"

@interface YKNewsListVC ()

@end

@implementation YKNewsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLabel];
    
}


- (void)addLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = self.labelString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    [self.view addSubview:label];
}



@end
