//
//  YKInputBase64.h
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WZMInputBase64)

+ (NSData *)input_dataWithBase64EncodedString:(NSString *)string;
- (NSString *)input_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)input_base64EncodedString;

@end

@interface NSString (WZMInputBase64)

+ (NSString *)input_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)input_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)input_base64EncodedString;
- (NSString *)input_base64DecodedString;
- (NSData *)input_base64DecodedData;

@end

