//
//  NSString+BFCAddition.h
//  BFCFoundation
//
//  Created by 张建林 on 15/8/8.
//  Copyright (c) 2015年 BigFaceCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (BFCAddition)

- (NSString *)localizedString;
- (BOOL)empty;
- (NSString *)urlQueryValueForKey:(NSString *)key;
- (NSString *)urlWithQuery:(NSDictionary *)query;
- (NSString *)timeIntervalDisplayString;
/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (NSString *)MD5;
+ (NSString *)randomString:(NSUInteger)length;

- (NSString *)underlineFromCamel;
- (NSString *)camelFromUnderline;


- (BOOL)isTelephone;
- (BOOL)isEmail;


- (BOOL)isNumber;
- (BOOL)isNumberWithUnit:(NSString *)unit;
- (BOOL)isUrl;
- (BOOL)isIPAddress;


- (BOOL)isIdentity;
- (BOOL)isBankCard;
- (BOOL)isNumberOrAlpha;

- (NSString *)rawIdentity;
- (NSString *)decorateIdentity;


- (NSString *)rawTelephone;
- (NSString *)decorateTelephone;

-(NSString *)toPinyin;

-(NSNumber *)filterFirstNumber;

- (NSString *)decorateNameWithRange:(NSInteger)range;

- (BOOL)isPureInt;
- (BOOL)isDivised;
@end

