//
//  NSString+BFCAddition.m
//  BFCFoundation
//
//  Created by 张建林 on 15/8/8.
//  Copyright (c) 2015年 BigFaceCat. All rights reserved.
//

#import "NSString+BFCAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BFCAddition)

static char characters[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (NSString *)localizedString
{
    return NSLocalizedString(self, nil);
}

- (BOOL)empty{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [string isEqualToString:@""];
}

- (NSString *)urlQueryValueForKey:(NSString *)key
{
    NSArray *array = [self componentsSeparatedByString:@"&"];
    if (key && array && [array count] > 0) {
        for (NSString *ele in array) {
            NSArray *eleArray = [ele componentsSeparatedByString:@"="];
            if ([eleArray count] == 2 && [[eleArray objectAtIndex:0] isEqualToString:key]) {
                return [eleArray objectAtIndex:1];
            }
        }
    }
    return nil;
}

- (NSString *)urlWithQuery:(NSDictionary *)query{
    if (!query) {
        return self;
    }
    NSString *url = self;
    NSString *seperator = @"?";
    if ([self rangeOfString:@"?"].location != NSNotFound) {
        seperator = @"&";
    }
    for (NSString *key in query) {
        url = [url stringByAppendingFormat:@"%@%@=%@", seperator, key, query[key]];
        seperator = @"&";
    }
    return url;
}


- (NSString *)timeIntervalDisplayString{
    double d = [self doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = now - d;
    NSString *str;
    if (interval < 0) {
        str = @"来自未来";
    } else if(interval < 3600){
        if (interval < 5 * 60) {
            str = @"刚刚";
        } else if(interval < 10 * 60){
            str = [NSString stringWithFormat:@"%ld分钟前", (NSInteger)(interval/60)];
        } else{
            str = [NSString stringWithFormat:@"%ld0分钟前", (NSInteger)(interval/600)];
        }
    } else if(interval < 3600 * 24){
        str = [NSString stringWithFormat:@"%ld小时前", (NSInteger)(interval/3600)];
    } else if(interval < 3600 * 24 * 30){
        str = [NSString stringWithFormat:@"%ld天前", (NSInteger)(interval/(3600 * 24))];
    } else if(interval < 3600 * 24 * 30 * 12 ){
        str = [NSString stringWithFormat:@"%ld个月前", (NSInteger)(interval/(3600 * 24 * 30))];
    } else{
        str = [NSString stringWithFormat:@"%ld年前", (NSInteger)(interval/(3600 * 24 * 30 * 12))];
    }
    return str;
}

//返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

+(NSString *)randomString:(NSUInteger)length
{
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i = 0; i < length; i++) {
        [str appendFormat:@"%c", characters[arc4random()%sizeof(characters)]];
    }
    return str;
}

- (NSString *)MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i = 0;i < CC_MD5_DIGEST_LENGTH ; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (NSString *)underlineFromCamel
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)camelFromUnderline
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|8[0-9]|77)\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    NSString * CT = @"^1(349|(33|53|8[09]|77)\\d)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *		regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *		regex = @"-?[0-9.]+";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumberWithUnit:(NSString *)unit
{
    NSString *		regex = [NSString stringWithFormat:@"-?[0-9.]+%@", unit];
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress
{
    NSArray *			components = [self componentsSeparatedByString:@"."];
    NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( 0 == [part1 length] ||
            0 == [part2 length] ||
            0 == [part3 length] ||
            0 == [part4 length] )
        {
            return NO;
        }
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] <= 255 &&
                [part2 intValue] <= 255 &&
                [part3 intValue] <= 255 &&
                [part4 intValue] <= 255 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

//- (BOOL)isIdentity{
//    if (self.length != 18) return NO;
//    // 正则表达式判断基本 身份证号是否满足格式
//    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
//    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
//    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    //如果通过该验证，说明身份证格式正确，但准确性还需计算
//    if(![identityStringPredicate evaluateWithObject:self]) return NO;
//    
//    //** 开始进行校验 *//
//    
//    //将前17位加权因子保存在数组里
//    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
//    
//    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
//    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
//    
//    //用来保存前17位各自乖以加权因子后的总和
//    NSInteger idCardWiSum = 0;
//    for(int i = 0;i < 17;i++) {
//        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
//        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
//        idCardWiSum+= subStrIndex * idCardWiIndex;
//    }
//    
//    //计算出校验码所在数组的位置
//    NSInteger idCardMod=idCardWiSum%11;
//    //得到最后一位身份证号码
//    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
//    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
//    if(idCardMod==2) {
//        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
//            return NO;
//        }
//    }
//    else{
//        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
//        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
//            return NO;
//        }
//    }
//    return YES;
//}

- (BOOL)isIdentity{
    if (self.length <= 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)isBankCard{
    int oddSum = 0;     // 奇数和
    int evenSum = 0;    // 偶数和
    int allSum = 0;     // 总和
    
    // 循环加和
    for (NSInteger i = 1; i <= self.length; i++)
    {
        NSString *theNumber = [self substringWithRange:NSMakeRange(self.length-i, 1)];
        int lastNumber = [theNumber intValue];
        if (i%2 == 0)
        {
            // 偶数位
            lastNumber *= 2;
            if (lastNumber > 9)
            {
                lastNumber -=9;
            }
            evenSum += lastNumber;
        }
        else
        {
            // 奇数位
            oddSum += lastNumber;
        }
    }
    allSum = oddSum + evenSum;
    // 是否合法
    if (allSum%10 == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isNumberOrAlpha{
    NSString *regex = @"^[a-zA-Z0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (NSString *)rawIdentity{
    return self;
}
- (NSString *)decorateIdentity{
    return self;
}

- (NSString *)rawTelephone{
    return self;
}
- (NSString *)decorateTelephone{
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
 

-(NSString *)toPinyin
{
    NSMutableString *pinyin = [[NSMutableString alloc] initWithString:self];
    //1.先转换为带声调的拼音
    if(!CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"转换为带声调的拼音出错");
    }
    //2.再转换为不带声调的拼音
    if (!CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"转换为不带声调的拼音");
    }
    //3.去除掉首尾的空白字符和换行字符
    NSString *pinyinStr = [pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //4.去除掉其它位置的空白字符和换行字符
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return pinyinStr;
}

-(NSNumber *)filterFirstNumber{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    int number;
    if ([scanner scanInt:&number]) {
        return @(number);
    }
    return nil;
}

- (NSString *)decorateNameWithRange:(NSInteger)range{
    return [self stringByReplacingCharactersInRange:NSMakeRange(1, range) withString:@"****"];
}

- (BOOL)isPureInt{
    NSScanner * scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isDivised{
    int tempNumber = [self intValue];
    if (tempNumber % 100 == 0) {
        return YES;
    }
    return NO;
}

@end

