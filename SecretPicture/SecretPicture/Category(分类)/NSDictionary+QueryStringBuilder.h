//
//  NSDictionary+QueryStringBuilder.h
//  SelfDrivingTour
//
//  Created by haiwei li on 12-4-19.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (escapeString)

- (NSString *)escapeString;

@end

@interface NSDictionary (QueryStringBuilder)

- (NSString *)queryString;

- (NSString *)postString;

- (NSString*)queryPayString;

- (NSString *)AFQueryString;

@end
