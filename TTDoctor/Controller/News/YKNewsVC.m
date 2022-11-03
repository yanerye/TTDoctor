//
//  YKNewsVC.m
//  TTDoctor
//
//  Created by YK on 2022/4/19.
//  Copyright © 2022 YK. All rights reserved.
//

#import "YKNewsVC.h"
#import "YKNewsListVC.h"

@interface YKNewsVC ()<ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic , strong) NSArray *titleArray;

@end

@implementation YKNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"科研资讯";
    [self getTitles];
}

- (void)getTitles{
    [[YKBaseApiSeivice service] getNewsTitlesCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            self.titleArray = responseObject[@"articleType"];
            [self reloadData];
        }else{
            NSLog(@"有错误");
        }
            
    }];
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.titleArray.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    NSDictionary *dict = self.titleArray[index];
    
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"%@", dict[@"name"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    YKNewsListVC *vc = [[YKNewsListVC alloc] init];;
    vc.labelString = [NSString stringWithFormat:@"这是第 #%lu 个页面", index];

    return vc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab://可不写
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab://可不写
            return 0.0;
            break;
        case ViewPagerOptionTabLocation://1.0 tab在上面 0.0 tab在下面
            return 1.0;//(默认的tab就在上面) 也可不写
            break;
        case ViewPagerOptionTabWidth://新闻头的宽度
            return 106;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor redColor];//[UIColorFromRGB(0x0146ad) colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}



@end
