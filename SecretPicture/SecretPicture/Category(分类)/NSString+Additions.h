//
//  NSString+Additions.h
//  SelfDrivingTour
//
//  Created by haiwei li on 12-3-30.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

//签到功能用到的签名方法，动态key，按照日期取不同的key
- (NSString *)checkInMd5;

- (NSString *)md5;
- (NSString *)md5_origin;
- (NSString *)sha1;

- (BOOL) isValidEmail:(BOOL)stricterFilter;
- (BOOL) isMobilePhone;
- (BOOL)isEmptyOrWhitespace;

//itunes版本号转化为浮点数
- (float)floatValueFromItunesAppVersionString;

//判断是否是纯数字组成的字符串
- (BOOL) isdigitalString;

+ (NSString*)decryptStr:(NSString *)desStr;

+ (int)getStringLines:(NSString *)string withFont:(UIFont *)font withWidth:(int)width;

+ (CGSize)getStringSize:(NSString *)string withFont:(UIFont *)font withWidth:(int)width;

+ (float)getStringWidth:(NSString *)string withFont:(UIFont *)font;

//将数据与科学计数法的转换 ，比如1234567，科学计数法123，456，7
+(NSString *)changeToScientificNotation:(NSString *)text DecimalStyle:(BOOL)isDecimalStyle;
//url.query to dic
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 *  去除字符串尾部的包含于某字符集的字符
 *
 *  @param characterSet 字符集
 *
 *  @return 去除后的字符串
 */
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

@end

@interface NSString (JSONValue)
- (id)JSONValue;
@end
