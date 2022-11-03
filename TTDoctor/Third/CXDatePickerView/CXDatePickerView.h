//
//  CXDatePickerView.h
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXDatePickerStyle.h"

@interface CXDatePickerView : UIView
/**
 *  日期单位样式
 */
@property (nonatomic, assign) CXDateLabelUnitStyle dateLabelUnitStyle; // 默认0.25

/**
 *  弹出动画时间
 */
@property (nonatomic, assign) CGFloat showAnimationTime; // 默认0.25

/**
 *  展示时背景透明度
 */
@property (nonatomic, assign) CGFloat shadeViewAlphaWhenShow; //默认0.5


/**
 *  滚轮日期选中颜色(默认橙色)
 */
@property (nonatomic, strong) UIColor *datePickerSelectColor;
/**
 *  滚轮日期选中字体
 */
@property (nonatomic, strong) UIFont *datePickerSelectFont;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic, strong) UIColor *datePickerColor;
/**
 *  滚轮日期字体
 */
@property (nonatomic, strong) UIFont *datePickerFont;
/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, strong) NSDate *minLimitDate;

/**
 *  隐藏每行年月日文字
 */
@property (nonatomic, assign) BOOL hideDateNameLabel;

/**
 *  隐藏每行分割线
 */
@property (nonatomic, assign) BOOL hideSegmentedLine;

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle completeBlock:(void(^)(NSDate *date))completeBlock;


/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *date))completeBlock;


/**
  定制日时分选择器
 */
- (instancetype)initWithZeroDayCompleteBlock:(void(^)(NSInteger days,NSInteger hours,NSInteger minutes))completeBlock;


- (void)show;


@end
