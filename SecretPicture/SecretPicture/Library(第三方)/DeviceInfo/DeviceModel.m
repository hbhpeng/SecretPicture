//
//  DeviceModel.m
//  autoPrice
//
//  Created by sky on 14-1-15.
//  Copyright (c) 2014年 Bitauto. All rights reserved.
//
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#import "DeviceModel.h"
#import "SFHFKeychainUtils.h"
#import <AdSupport/AdSupport.h>

NSString const * kDeviceModelServiceName = @"bitautoDevice";
NSString const * kDeviceIdKey = @"deviceId";

@implementation DeviceModel

#pragma mark - device id related
/*deviceid生成方式，7.0 以下，取设备的mac地址的md5
 7.0以上系统，取idfv值的md5. 生成的deviceid 存贮到keychain中，同个开发商下面的app
 共享设备Id
 */

+ (NSString*)deviceId{
    
    NSString *deviceIdStr = [SFHFKeychainUtils getPasswordForUsername:(NSString*)kDeviceIdKey
                                                       andServiceName:(NSString*)kDeviceModelServiceName
                                                                error:nil];
    if (!deviceIdStr.length) {
        
        if ([self systemFloatVersion]< 7.0) {
            deviceIdStr = [[self macaddress] md5_origin];
            
        }else{
            
            deviceIdStr = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] md5_origin];
        }
        
        
        [SFHFKeychainUtils storeUsername:(NSString*)kDeviceIdKey
                             andPassword:deviceIdStr
                          forServiceName:(NSString*)kDeviceModelServiceName
                          updateExisting:YES
                                   error:nil];
    }
    //若还为空，则从生成uuid
    if (!deviceIdStr.length) {
        
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        deviceIdStr =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        
        [SFHFKeychainUtils storeUsername:(NSString*)kDeviceIdKey
                             andPassword:deviceIdStr
                          forServiceName:(NSString*)kDeviceModelServiceName
                          updateExisting:YES
                                   error:nil];
    }
    
    return deviceIdStr;
}

+ (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

+ (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark - systerm information
+(float)systemFloatVersion{
    
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(BOOL)isSystemVersionMoreThanIOS8
{
    if ([DeviceModel systemFloatVersion]>=8.0) {
        return YES;
    }
    return NO;
}

+ (NSString*) currentResolutionString{
    CGSize  resolutionSize = [[UIScreen mainScreen] bounds].size;
    resolutionSize = CGSizeMake(resolutionSize.width * [UIScreen mainScreen].scale, resolutionSize.height * [UIScreen mainScreen].scale);
    return [NSString stringWithFormat:@"%dx%d",((int)resolutionSize.width),((int)resolutionSize.height)];
}

+ (NSString *) osNameAndVersionString{

    return [NSString stringWithFormat:@"%@%@",[[UIDevice currentDevice]systemName],
            [[UIDevice currentDevice] systemVersion]];
}


+ (float)screenWidth{
    
    return [UIScreen mainScreen].bounds.size.width;
}

+ (float)screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (float)screenPortraitWidth{
    float height = [UIScreen mainScreen].bounds.size.height;
    float width = [UIScreen mainScreen].bounds.size.width;
    return width<height? width:height ;
}

@end
