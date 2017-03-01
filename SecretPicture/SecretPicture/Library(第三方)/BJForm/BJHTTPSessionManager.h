//
//  BJHTTPSessionManager.h
//  LYHttpClient
//
//  Created by Bitauto on 16/1/7.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSUInteger, BJHTTPClientRequestCachePolicy){
        
    //带缓存策略，请求失败若有缓存，则返回缓存
    BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy = 0,//缓存过期后才去服务器取新的内容，缓存不过期则不发起请求
    BJHTTPClientAskServerIfModifiedCachePolicy = 1, //去服务器问，有没有更新内容
    
    //离线模式，只返回缓存内容，不发起请求
    BJHTTPClientOffLineCachePolicy = 2,
    
    //不使用缓存
    BJHTTPClientDontLoadCachePolicy = 3, //不带缓存系统，直接发起请求
    
    
    //系统缓存策略
    BJHTTPDownloadCacheUseProtocolCachePolicy = 4,//使用系统缓存，又rquest接口协议指定
    
};

@interface BJHTTPSessionManager : AFHTTPSessionManager
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    cacheHeader :(NSDictionary*)cacheHeaders
                                     cachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
