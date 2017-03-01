//
//  BJHttpDownloadCache.m
//  LYHttpClient
//
//  Created by bita on 16/1/7.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJHttpDownloadCache.h"
#import "YYCache.h"
#import "NSURLSessionDataTask+CachePolicy.h"

@interface BJHTTPDownloadCache ()
{

    YYCache * _yycache;
}
@end

@implementation BJHTTPDownloadCache

#pragma  - init

-(instancetype)initWithCacheName:(NSString*)cacheName
{
    self = [super init];
    if (self) {
        _yycache = [[YYCache alloc] initWithName:cacheName];
        _yycache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _yycache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        _httpClientManage = [NSMutableDictionary dictionaryWithCapacity:0];
    }

    return self;
}

+ (instancetype)cache
{
 
    return [[BJHTTPDownloadCache alloc] initWithCacheName:@"bjshare_http_cache"];
}


+ (instancetype) shareHttpDownloadCache
{
    static BJHTTPDownloadCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [BJHTTPDownloadCache cache];
    });
    
    return sharedCache;

}

-(NSString*)storeDateKeyForKey:(NSString*)key
{

    return [key stringByAppendingString:@"_storedata_key"];
}

#pragma mark - public
-(void)storeResponseForTask:(NSURLSessionDataTask*)dataDask  responseObject:(id)object;
{

    
    NSString *urlKey = dataDask.bjCacheKey;
    NSTimeInterval maxAge = dataDask.bjMaxAge;
    
   
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)dataDask.response;
    NSInteger statusCode = response.statusCode;
    
    NSDictionary *responseHeader = response.allHeaderFields;
    NSMutableDictionary *mutableHeader = [NSMutableDictionary dictionaryWithDictionary:responseHeader];
    
    NSDate *expires = [[NSDate date] dateByAddingTimeInterval:maxAge];;
    if (!expires) {
        return;
    }
    [mutableHeader setObject:[NSNumber numberWithDouble:[expires timeIntervalSince1970]] forKey:@"X-ASIHTTPRequest-Expires"];
    
    if (statusCode == 200) {
        NSString *storeDateKey = [self storeDateKeyForKey:urlKey];
        [_yycache   setObject:object
                       forKey:storeDateKey];
       
        [_yycache   setObject:mutableHeader forKey:urlKey];
    }
    else if(statusCode == 304){
        [_yycache   setObject:mutableHeader forKey:urlKey];
    }
}

- (NSDictionary*)cacheHeadersForKey:(NSString*)key
{

    NSDictionary *header = (NSDictionary*)[_yycache objectForKey:key];
    return header;
}

-(BOOL)canUseCacheForKey:(NSString*)key maxAge:(NSTimeInterval)age
{
    NSDictionary *cacheHeaders = [self cacheHeadersForKey:key];
    if (!cacheHeaders) {
        return NO;
    }else{
      
        NSNumber *expires = [cacheHeaders objectForKey:@"X-ASIHTTPRequest-Expires"];
        if (expires) {
            if ([[NSDate dateWithTimeIntervalSince1970:[expires doubleValue]] timeIntervalSinceNow] >= 0) {
                return YES;
            }
            else
            {
                return NO;
            }
        }else{
            return NO;
        }
    }
}

- (id)cacheResponObjectForKey:(NSString *)key
{
    NSString *storeDateKey = [self storeDateKeyForKey:key];
    return [_yycache objectForKey:storeDateKey];

}
@end
