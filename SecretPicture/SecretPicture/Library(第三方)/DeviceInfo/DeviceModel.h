//
//  DeviceModel.h
//  autoPrice
//
//  Created by sky on 14-1-15.
//  Copyright (c) 2014年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
+ (NSString *)deviceId;
+ (NSString *) macaddress;
+ (NSString *)idfvString;
+ (NSString *)idfaString;


+(float)systemFloatVersion;
+ (NSString *) currentResolutionString;
+ (NSString *) osNameAndVersionString;


+(BOOL)isSystemVersionMoreThanIOS8;

+ (float)screenWidth;
+ (float)screenHeight;

+ (float)screenPortraitWidth ;

@end
