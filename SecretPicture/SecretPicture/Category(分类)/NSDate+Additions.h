//
//  NSDate+Additions.h
//  bitautoHd
//
//  Created by haiwei li on 12-2-1.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDateExtensions)

- (NSString *) stringWithFormat:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)string 
                 withFormat:(NSString*) format;


//和当前时间比较，是否过期，不超过一天之内都算是不过期
-(BOOL)isOutDate;


//根据过期间隔，比较修改时间和当前时间，判断是否需要刷新数据
-(BOOL) isNeedRefreshDatawithTimeoutInterval:(NSTimeInterval)timeoutInterval;

//返回类似微博的时间各式串
- (NSString *) stringWithZJStyle;

//下拉刷新显示的时间格式
- (NSString *)stringWithLHStyle;

- (NSString *)stringWithLJStyle;

//车管家， 问答时间格式
- (NSString *)stringWithQStyle;

#pragma mark - NSDate
+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)dateString;

@end
