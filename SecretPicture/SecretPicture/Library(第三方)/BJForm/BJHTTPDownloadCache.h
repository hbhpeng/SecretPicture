//
//  BJHttpDownloadCache.h
//  LYHttpClient
//
//  Created by bita on 16/1/7.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJHTTPDownloadCache : NSObject


@property(nonatomic,strong) NSMutableDictionary *httpClientManage;


+ (instancetype) shareHttpDownloadCache;

- (void)storeResponseForTask:(NSURLSessionDataTask*)dataDask responseObject:(id)object;

- (NSDictionary*)cacheHeadersForKey:(NSString*)key;

-(BOOL)canUseCacheForKey:(NSString*)key maxAge:(NSTimeInterval)age;

- (id)cacheResponObjectForKey:(NSString *)key;

@end
