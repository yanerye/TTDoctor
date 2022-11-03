//
//  CXDatePickerView.m
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "CXDatePickerView.h"
#import "CXDatePickerViewManager.h"
#import "NSDate+CXCategory.h"


#define ShowViewHeight  200
#define TitleViewHeight   45
#define ShadeViewAlphaWhenShow  0.4

typedef void(^doneBlock)(NSDate *date);
typedef void(^doneZeroDayBlock)(NSInteger days,NSInteger hours,NSInteger minutes);

@interface CXDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UIView *titleView;


@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, copy) doneBlock doneBlock;
@property (nonatomic, copy) doneZeroDayBlock doneZeroDayBlock;
@property (nonatomic, strong) UILabel *backYearView;


@property (nonatomic, strong) CXDatePickerViewManager *manager;

@end

@implementation CXDatePickerView

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    _maxLimitDate = maxLimitDate;
    self.manager.maxLimitDate = maxLimitDate;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    self.manager.minLimitDate = minLimitDate;
}

- (void)setDatePickerSelectColor:(UIColor *)datePickerSelectColor {
    _datePickerSelectColor = datePickerSelectColor;
    [self.datePicker reloadAllComponents];
}

- (void)setDatePickerSelectFont:(UIFont *)datePickerSelectFont {
    _datePickerSelectFont = datePickerSelectFont;
    [self.datePicker reloadAllComponents];
}

- (void)setDatePickerColor:(UIColor *)datePickerColor {
    _datePickerColor = datePickerColor;
    [self.datePicker reloadAllComponents];
}

- (void)setDatePickerFont:(UIFont *)datePickerFont {
    _datePickerFont = datePickerFont;
    [self.datePicker reloadAllComponents];
}


- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, TitleViewHeight, KWIDTH - 100, 160)];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (UILabel *)backYearView {
    if (!_backYearView) {
        _backYearView = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleViewHeight, KWIDTH, 160)];
        _backYearView.textAlignment = NSTextAlignmentCenter;
        _backYearView.font = [UIFont systemFontOfSize:20];
        _backYearView.textColor =  [UIColor clearColor];
    }
    return _backYearView;
}


#pragma mark - 默认滚动到当前时间

- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle completeBlock:(void(^)(NSDate *date))completeBlock {
    if (self = [super init]) {
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:datePickerStyle scrollToDate:nil];
        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

#pragma mark - 滚动到指定的的日期
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *))completeBlock {
    if (self = [super init]) {
        
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:datePickerStyle scrollToDate:scrollToDate];
        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

#pragma mark - 天-时-分
- (instancetype)initWithZeroDayCompleteBlock:(void(^)(NSInteger days,NSInteger hours,NSInteger minutes))completeBlock {
    if (self = [super init]) {
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:CXDateDayHourMinute scrollToDate:nil];
        self.manager.isZeroDay = YES;
        [self setupUI];
        if (completeBlock) {
            self.doneZeroDayBlock = ^(NSInteger days, NSInteger hours, NSInteger minutes) {
                completeBlock(days,hours,minutes);
            };
        }
    }
    return self;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.showAnimationTime = 0.25;
    self.shadeViewAlphaWhenShow = ShadeViewAlphaWhenShow;
    self.datePickerColor = [UIColor blackColor];
    self.datePickerFont = [UIFont systemFontOfSize:15];

    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(0,KHEIGHT,KWIDTH, ShowViewHeight)];
    self.buttomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.buttomView];
    
    [self.buttomView addSubview:self.backYearView];
    [self.buttomView addSubview:self.datePicker];
    
    self.manager.datePicker = self.datePicker;
    self.manager.backYearView = self.backYearView;
    
    [self initTitleView];

    
    [self layoutIfNeeded];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)initTitleView {
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, TitleViewHeight)];
    self.titleView.backgroundColor = RGBACOLOR(241, 241, 241);
    [self.buttomView addSubview:self.titleView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 0.5)];
    lineView.backgroundColor = RGBACOLOR(51, 51, 51);
    [self.titleView addSubview:lineView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, TitleViewHeight)];
    [cancelButton setTitleColor:RGBACOLOR(66, 116, 214) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleView addSubview:cancelButton];

    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(KWIDTH - 65, 0, 65, TitleViewHeight)];
    [sureButton setTitleColor:RGBACOLOR(66, 116, 214) forState:UIControlStateNormal];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:sureButton];

}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.backYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (_hideDateNameLabel || _dateLabelUnitStyle != CXDateLabelUnitFixed) {
        return;
    }
    
    for (int i = 0; i < nameArr.count; i++) {
        CGFloat labelX = 50 +(KWIDTH - 100)/(nameArr.count * 2) + 12 + (KWIDTH - 100) / nameArr.count * i;
        if (i == 0 && [self.manager.unitArray containsObject:@"年"]) {
            labelX =  50 + (KWIDTH - 100)/(nameArr.count * 2) + 20;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.backYearView.frame.size.height / 2 - 15 / 2.0, 15, 15)];
        
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];;
        label.textColor = RGBACOLOR(24, 24, 24);
        label.backgroundColor = [UIColor clearColor];
        [label adjustsFontSizeToFitWidth];
        [self.backYearView addSubview:label];
    }
}


#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = ShowViewHeight;
        self.buttomView.frame = CGRectMake(0, KHEIGHT - buttomViewHeight, KWIDTH, buttomViewHeight);
        self.backgroundColor = [UIColor colorWithRed:(0 / 255.0) green:(0 / 255.0) blue:(0 / 255.0) alpha:self.shadeViewAlphaWhenShow];
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = ShowViewHeight;
        self.buttomView.frame = CGRectMake(0, KHEIGHT, KWIDTH, buttomViewHeight);
        self.backgroundColor = [UIColor colorWithRed:(0 / 255.0) green:(0 / 255.0) blue:(0 / 255.0) alpha:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)confirm {
    NSDate *date = [self.manager.scrollToDate cx_dateWithFormatter:self.manager.dateFormatter];
    if (self.doneZeroDayBlock) {
        self.doneZeroDayBlock(self.manager.dayIndex, self.manager.hourIndex, self.manager.minuteIndex);
    }
    if (self.doneBlock) {
        self.doneBlock(date);
    }
    [self dismiss];
}

- (void)cancel {
    [self dismiss];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [self addLabelWithName:self.manager.unitArray];
    return self.manager.unitArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self.manager getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    NSString *title;
    
    switch (self.manager.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:
            if (component == 0) {
                title = self.manager.yearArray[row];
            }
            if (component == 1) {
                title = self.manager.monthArray[row];
            }
            if (component == 2) {
                title = self.manager.dayArray[row];
            }
            if (component == 3) {
                title = self.manager.hourArray[row];
            }
            if (component == 4) {
                title =  self.manager.minuteArray[row];
            }
            if (component == 5) {
                title =  self.manager.secondArray[row];
            }
            break;
        case CXDateYearMonthDayHourMinute:
            if (component == 0) {
                title = self.manager.yearArray[row];
            }
            if (component == 1) {
                title = self.manager.monthArray[row];
            }
            if (component == 2) {
                title = self.manager.dayArray[row];
            }
            if (component == 3) {
                title = self.manager.hourArray[row];
            }
            if (component == 4) {
                title =  self.manager.minuteArray[row];
            }
            break;
        case CXDateYearMonthDay:
            if (component == 0) {
                title = self.manager.yearArray[row];
            }
            if (component == 1) {
                title =  self.manager.monthArray[row];
            }
            if (component == 2) {
                title =  self.manager.dayArray[row];
            }
            break;
        case CXDateDayHourMinute:
            if (component == 0) {
                title = self.manager.dayArray[row];
            }
            if (component == 1) {
                title = self.manager.hourArray[row];
            }
            if (component == 2) {
                title = self.manager.minuteArray[row];
            }
            break;
        case CXDateYearMonth:
            
            if (component == 0) {
                title =  self.manager.yearArray[row];
            }
            if (component == 1) {
                title = self.manager.monthArray[row];
            }
            break;
        case CXDateMonthDayHourMinute:
            if (component == 0) {
                title = self.manager.monthArray[row % 12];
            }
            if (component == 1) {
                title = self.manager.dayArray[row];
            }
            if (component == 2) {
                title = self.manager.hourArray[row];
            }
            if (component == 3) {
                title = self.manager.minuteArray[row];
            }
            break;
        case CXDateMonthDay:
            if (component == 0) {
                title = self.manager.monthArray[row%12];
            }
            if (component == 1) {
                title = self.manager.dayArray[row];
            }
            break;
        case CXDateHourMinuteSecond:
            if (component == 0) {
                title = self.manager.hourArray[row];
            }
            if (component == 1) {
                title = self.manager.minuteArray[row];
            }
            if (component == 2) {
                title = self.manager.secondArray[row];
            }
            break;
        case CXDateHourMinute:
            if (component == 0) {
                title = self.manager.hourArray[row];
            }
            if (component == 1) {
                title = self.manager.minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    customLabel.text = title;
    customLabel.textColor = self.datePickerColor;
    customLabel.font = self.datePickerFont;
    
    if (!_hideDateNameLabel && _dateLabelUnitStyle == CXDateLabelTextAllUnit) {
        customLabel.text = [NSString stringWithFormat:@"%@%@", title, self.manager.unitArray[component]];
    }
    
    if (self.manager.indexArray.count && (self.datePickerSelectFont || self.datePickerSelectColor)) {
        for (int i = 0; i < self.manager.indexArray.count; i++) {
            if (component == i) {
                if (
                    ((self.manager.datePickerStyle == CXDateMonthDayHourMinute || self.manager.datePickerStyle == CXDateMonthDay) && self.manager.monthIndex == row % 12 && component == 0) ||
                    [self.manager.indexArray[i] intValue] == row
                    ) {
                    customLabel.textColor = _datePickerSelectColor;
                    customLabel.font = _datePickerSelectFont;
                    if (!_hideDateNameLabel && _dateLabelUnitStyle == CXDateLabelTextSelectUnit) {
                        customLabel.text = [NSString stringWithFormat:@"%@%@", title, self.manager.unitArray[component]];
                    }
                }
            }
        }
    }
    
    if(_hideSegmentedLine) {
        for (UIView *view in self.datePicker.subviews) {
            if (view.frame.size.height <= 1) {
                view.backgroundColor = UIColor.clearColor;
            }
        }
    }
    return customLabel;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.manager.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:{
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 3) {
                self.manager.hourIndex = row;
            }
            if (component == 4) {
                self.manager.minuteIndex = row;
            }
            if (component == 5) {
                self.manager.secondIndex = row;
            }
            if (component == 0 || component == 1){
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
            }
        }
            break;
        case CXDateYearMonthDayHourMinute:{
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 3) {
                self.manager.hourIndex = row;
            }
            if (component == 4) {
                self.manager.minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
                
            }
        }
            break;
        case CXDateYearMonthDay:{
            
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
            }
        }
            break;
            
        case CXDateDayHourMinute:{
            
            if (component == 0) {
                self.manager.dayIndex = row;
            }
            if (component == 1) {
                self.manager.hourIndex = row;
            }
            if (component == 2) {
                self.manager.minuteIndex = row;
            }
        }
            break;
            
        case CXDateYearMonth:{
            
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            [self.manager refreshDayArray];
            if (self.manager.dayArray.count-1<self.manager.dayIndex) {
                self.manager.dayIndex = self.manager.dayArray.count - 1;
            }
        }
            
            break;
            
            
        case CXDateMonthDayHourMinute:{
            
            if (component == 1) {
                self.manager.dayIndex = row;
            }
            if (component == 2) {
                self.manager.hourIndex = row;
            }
            if (component == 3) {
                self.manager.minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self.manager yearChange:row];
                [self.manager refreshDayArray];
                if (self.manager.dayCount - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
            }
            [self.manager refreshDayArray];
            
        }
            break;
            
        case CXDateMonthDay:{
            if (component == 1) {
                self.manager.dayIndex = row;
            }
            if (component == 0) {
                [self.manager yearChange:row];
                [self.manager refreshDayArray];
                if (self.manager.dayCount - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count-1;
                }
            }
            [self.manager refreshDayArray];
        }
            break;
            
        case CXDateHourMinuteSecond:{
            if (component == 0) {
                self.manager.hourIndex = row;
            }
            if (component == 1) {
                self.manager.minuteIndex = row;
            }
            if (component == 2) {
                self.manager.secondIndex = row;
            }
        }
            break;
            
        case CXDateHourMinute:{
            if (component == 0) {
                self.manager.hourIndex = row;
            }
            if (component == 1) {
                self.manager.minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    [self.manager  refreshScrollToDate];
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}


@end
