//
//  NSDate+Additions.m
//  bitautoHd
//
//  Created by haiwei li on 12-2-1.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (NSDateExtensions)


-(NSDateFormatter*)shareDateFormatter{

    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"mydateformatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                //[dateFormatter setDateFormat:@”yyyy-MM-dd HH:mm:ss”];
                //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@”Asia/Shanghai”]];
                threadDictionary[@"mydateformatter"] = dateFormatter;
            }
        }
    }
    return dateFormatter;
}

- (NSString *)stringWithFormat:(NSString *)format{
    
    NSDateFormatter * dateFormatter = [self shareDateFormatter];
	//zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。 
    if (format) {
        [dateFormatter setDateFormat:format]; 
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    }
    
	NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
    
}

+ (NSDate *)dateFromString:(NSString *)string
                withFormat:(NSString*) format{
    
    NSDateFormatter * dateFormatter = [[NSDate date] shareDateFormatter];
	//zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。    
	if (format) {
        [dateFormatter setDateFormat:format]; 
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    }    
	NSDate * destDate = [dateFormatter dateFromString:string];
    return destDate;
}
#pragma mark - dateCompare
-(BOOL) isNeedRefreshDatawithTimeoutInterval:(NSTimeInterval)timeoutInterval{
    
    NSDate *timeOutDate = [NSDate dateWithTimeInterval:timeoutInterval sinceDate:self];
    if ([[[NSDate date] earlierDate:timeOutDate] isEqualToDate:timeOutDate]) {
        return YES;
    }else{
        return NO;
    }

}

-(BOOL)isOutDate{

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:[NSDate date]];
	NSInteger year = [components year];
	NSInteger month = [components month];
	NSInteger day = [components day];


    //targetDate
	components = [gregorian components:unitFlags fromDate:self];
	NSInteger currentYear = [components year];
	NSInteger currentMonth = [components month];
	NSInteger currentDay = [components day];
    
    if (year == currentYear) {
        if (month == currentMonth) {
            if (day <= currentDay) {
                return NO;
            }else{
                return YES;
            }
            
        }else if(month < currentMonth){
            return NO;
        }else{
            return YES;
        }
        
    }else if(year < currentYear){
    
        return NO;
    }else{
        return YES;
    }
    
}

#pragma mark dateformatter
- (NSString *)stringWithLHStyle{
    //要转化为字符的日期时间
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:self];
	NSInteger year = [components year];
	NSInteger month = [components month];
	NSInteger day = [components day];
	
	//现在的日期时间
	NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [gregorian components:unitFlags fromDate:currentDate];
    NSInteger currentYear = [currentComponents year];
	NSString *dateString;
	
	static NSDateFormatter * dateFormatter = nil;
  if (nil == dateFormatter)
  {
    dateFormatter = [[NSDateFormatter alloc] init];
  }
  
    
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self];
    if (timeInterval < 60) {
        dateString = @"刚刚";
    }else if(timeInterval < 60*60){
        dateString = [NSString stringWithFormat:@"%.0f分钟前",timeInterval/60.];
        
    }else if(timeInterval < 60*60*24){
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString = [NSString stringWithFormat:@"%.0f小时前",timeInterval/3600];
    }else if(timeInterval >= 60*60*24 && year == currentYear){
        dateString = [NSString stringWithFormat:@"%02d-%02d",(int)month,(int)day];
    }else{
        dateString = [NSString stringWithFormat:@"%d-%02d-%02d",(int)year,(int)month,(int)day];
    }
    return dateString;
}

- (NSString *)stringWithZJStyle {
    //要转化为字符的日期时间
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:self];
	NSInteger year = [components year];
	NSInteger month = [components month];
	NSInteger day = [components day];
	
	//现在的日期时间
	NSDate *currentDate = [NSDate date];
	components = [gregorian components:unitFlags fromDate:currentDate];
	NSInteger currentYear = [components year];
	NSInteger currentMonth = [components month];
	NSInteger currentDay = [components day];
	NSString *dateString;
	
	NSDateFormatter * dateFormatter = [self shareDateFormatter];
    
	if (currentYear == year) { //不跨年
		if (currentDay == day && currentMonth == month) {//当天
			NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self];
			if (timeInterval < 60) {
                if (timeInterval <= 0) {
                    timeInterval = 1;
                }
				dateString = [NSString stringWithFormat:@"%.0f秒前",timeInterval];
			}
			else if(timeInterval < 60*60)
                {
				dateString = [NSString stringWithFormat:@"%.0f分前",timeInterval/60.];
                }
			else
                {
				[dateFormatter setDateFormat:@"HH:mm"];
				dateString = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:self]];
                }
		}
		else //非当天
            {
			NSDate *yesterday = [currentDate dateByAddingTimeInterval: - (60*60*24)];
			components = [gregorian components:unitFlags fromDate:yesterday];
			NSInteger yesterdayMonth = [components month];
			NSInteger yesterdayDay = [components day];
            NSInteger year = [components year];
			
			[dateFormatter setDateFormat:@"HH:mm"];
			
			if ( yesterdayMonth == month && yesterdayDay == day ) //昨天
                {
				dateString = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:self]];
                }else //当年早于昨天的时间
                    {
                    dateString = [NSString stringWithFormat:@"%d-%d-%d",(int)year,(int)month,(int)day];
                    }
            }
	}
	else //跨年显示，如“2010-10-10”
        {
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		dateString = [dateFormatter stringFromDate:self];
        }
	return dateString;
}

- (NSString *)stringWithLJStyle {
	//要转化为字符的日期时间
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:self];
	NSInteger year = [components year];
	NSInteger month = [components month];
	NSInteger day = [components day];
	
	//现在的日期时间
	NSDate *currentDate = [NSDate date];
	components = [gregorian components:unitFlags fromDate:currentDate];
	NSInteger currentYear = [components year];
	NSInteger currentMonth = [components month];
	NSInteger currentDay = [components day];
	NSString *dateString;
    
	NSDateFormatter * dateFormatter = [self shareDateFormatter];
	
    if (currentDay == day && currentMonth == month && currentYear == year) { //当天
		dateString = @"今天";
	}
	else //非当天
	{
		NSDate *yesterday = [currentDate dateByAddingTimeInterval: - (60*60*24)];
		components = [gregorian components:unitFlags fromDate:yesterday];
		NSInteger yesterdayMonth = [components month];
		NSInteger yesterdayDay = [components day];
		NSInteger yesterdayYear = [components year];
		
		[dateFormatter setDateFormat:@"HH:mm"];
		
		if ( yesterdayDay == day && yesterdayMonth == month && yesterdayYear == year) //昨天
		{
			dateString = @"昨天";
		}else //早于昨天的时间
		{
			dateString = [NSString stringWithFormat:@"%d-%d-%d",(int)year,(int)month,(int)day];
		}
	}
	return dateString;
}

- (NSString *)stringWithQStyle {
    
    NSString *dateStr = nil;
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval dateTime = [self timeIntervalSince1970];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self];
    NSDateComponents *currentComponents = [gregorian components:unitFlags fromDate:currentDate];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSInteger currentYear = [currentComponents year];
    NSInteger currentDay = [currentComponents day];
    NSInteger currentHour = [currentComponents hour];
    NSInteger currentMinute = [currentComponents minute];
    NSInteger currentSecond = [currentComponents second];
    
    int _dateTime = dateTime-hour*60*60-minute*60-second;
    int _currentTime = currentTime-currentHour*60*60-currentMinute*60-currentSecond;
    
    NSString *_hourStr = [NSString stringWithFormat:@"%d", (int)hour];
    if (hour < 10) {
        _hourStr = [NSString stringWithFormat:@"0%d", (int)hour];
    }
    NSString *_minuteStr = [NSString stringWithFormat:@"%d", (int)minute];
    if (minute < 10) {
        _minuteStr = [NSString stringWithFormat:@"0%d", (int)minute];
    }
    
    if ((currentTime - dateTime) <= 60){
        dateStr = [NSString stringWithFormat:@"刚刚"];
        
    }else if ((currentTime - dateTime) <= (60*60) && (currentTime - dateTime) > 60 && day == currentDay) {
        int m = (currentTime - dateTime)/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",m];
        
    }else if ((currentTime - dateTime) <= (60*60*12) && (currentTime - dateTime) > (60*60) && day == currentDay){
        int m = (currentTime - dateTime)/60/60;
        dateStr = [NSString stringWithFormat:@"%d小时前",m];
        
    }else if ((currentTime - dateTime) < (60*60*24) && (currentTime - dateTime) > (60*60*12) && day == currentDay){
        dateStr = [NSString stringWithFormat:@"今天 %@:%@",_hourStr,_minuteStr];
        
    }else if (_currentTime-_dateTime == (60*60*24) && year == currentYear){
        dateStr = [NSString stringWithFormat:@"昨天 %@:%@",_hourStr,_minuteStr];
        
    }else if (_currentTime-_dateTime == (60*60*24*2) && year == currentYear){
        dateStr = [NSString stringWithFormat:@"前天 %@:%@",_hourStr,_minuteStr];
        
    }else if ((_currentTime - _dateTime) >= (60*60*24*3) && year == currentYear){
        dateStr = [NSString stringWithFormat:@"%ld月%ld日 %@:%@",(long)month,(long)day,_hourStr,_minuteStr];
        
    }else{
        dateStr = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)year,(long)month,(long)day];
        
    }
    
    return dateStr;
}


#pragma mark - NSDate
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDate date]shareDateFormatter];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDate date]shareDateFormatter];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


@end
