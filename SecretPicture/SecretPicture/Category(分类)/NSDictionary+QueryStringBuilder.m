//
//  NSDictionary+QueryStringBuilder.m
//  SelfDrivingTour
//
//  Created by haiwei li on 12-4-19.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import "NSDictionary+QueryStringBuilder.h"

#import <AFURLRequestSerialization.h>

NSString * escapeString(NSString *unencodedString)
{
   __autoreleasing NSString *s = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)unencodedString,
                                                                      NULL,
                                                                      (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                                    kCFStringEncodingUTF8));
    return s;
}

@implementation NSString (escapeString)

- (NSString *)escapeString{
    return escapeString(self);
}

@end

@implementation NSDictionary (QueryStringBuilder)

- (NSString *)queryString
{
    NSMutableString *queryString = nil;
    NSArray *keys = [self allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    if ([keys count] > 0) {
        for (id key in keys) {
            
            
            id value = [self objectForKey:key];
            if (nil == queryString) {
                queryString = [[NSMutableString alloc] init];
                [queryString appendFormat:@"?"];
            } else {
                [queryString appendFormat:@"&"];
            }
            
            if (nil != key && nil != value) {
                [queryString appendFormat:@"%@=%@", escapeString(key), escapeString(value)];
            } else if (nil != key) {
                [queryString appendFormat:@"%@", escapeString(key)];
            }
        }
}
return queryString;
}

- (NSString *)AFQueryString
{
    NSString *query = AFQueryStringFromParameters(self);
    return [NSString stringWithFormat:@"?%@",query];
}

- (NSString *)postString
{
    return [self queryString];
    NSMutableString *postString = nil;
    NSArray *keys = [self allKeys];
    
    if ([keys count] > 0)
    {
        for (id key in keys)
        {
            
            id value = [self objectForKey:key];
            if (nil == postString) {
                postString = [[NSMutableString alloc] init];
            } else {
                [postString appendFormat:@"&"];
            }
            
            if (nil != key && nil != value && ![key isKindOfClass:[NSNull class]] && ![value isKindOfClass:[NSNull class]]) {
                [postString appendFormat:@"%@=%@", key, [value description]];
            } else if (nil != key) {
                [postString appendFormat:@"%@", key];
            }
        }
    }
    return postString;
}

- (NSString *)queryPayString {
    NSMutableString *queryString = nil;
    NSArray *keys = [self allKeys];
    
    if ([keys count] > 0) {
        for (id key in keys) {
            
            id value = [self objectForKey:key];
            if (nil == queryString) {
                queryString = [[NSMutableString alloc] init];
            } else {
                [queryString appendFormat:@";"];
            }
            
            if (nil != key && nil != value) {
                [queryString appendFormat:@"%@={%@}",key,value];
            }else if (nil != key) {
                [queryString appendFormat:@"%@",key];
            }
        }
    }
    return queryString;
}



@end
