//
//  BJHttpClient.m
//  LYHttpClient
//
//  Created by bita on 16/1/8.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJHTTPClient.h"
#import "BJHTTPDownloadCache.h"
#import "NSURLSessionDataTask+CachePolicy.h"

@interface BJHTTPClient ()
{
    
}

@property (nonatomic ,weak) BJHTTPDownloadCache *shareCache;
@property (nonatomic,copy) NSString *baseUrlString;
@end

@implementation BJHTTPClient


#pragma mark  - init

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        _shareCache = [BJHTTPDownloadCache shareHttpDownloadCache];
        _baseUrlString = url.absoluteString;
        
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
        self.securityPolicy = securityPolicy;
        
        [self.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            NSMutableDictionary *tempParameters = [parameters mutableCopy];
            
            NSString *signValue = parameters[@"sign"];
            [tempParameters removeObjectForKey:@"sign"];
            
            NSString *query = AFQueryStringFromParameters(tempParameters);
            
            if (signValue != nil) {
                return [NSString stringWithFormat:@"%@&sign=%@",query,signValue];
            } else {
                return query;
            }
            
        }];
    }

    return self;
}

#pragma mark - api
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
                       maxAge:(NSTimeInterval)age
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject,BOOL useCache))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{

    BOOL needSendRequest = NO;
    
    NSString *cacheKey = URLString;
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) return nil;//参数不是json类型
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [URLString stringByAppendingString:paramStr];
        cacheKey = [self.baseUrlString stringByAppendingString:cacheKey];
        cacheKey = [cacheKey md5_origin];
    }else
    {
        cacheKey = [self.baseUrlString stringByAppendingString:cacheKey];
        cacheKey = [cacheKey md5_origin];
    }

    NSDictionary *cacheHeader = [_shareCache cacheHeadersForKey:cacheKey];
    
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        cachePolicy = BJHTTPClientOffLineCachePolicy;
    }
    
    switch (cachePolicy) {
        case BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy: {
            needSendRequest = ![self.shareCache canUseCacheForKey:cacheKey maxAge:age];
            if (!needSendRequest) {
                success(nil,[self.shareCache cacheResponObjectForKey:cacheKey],YES);
            }

            break;
        }
        case BJHTTPClientAskServerIfModifiedCachePolicy: {
            
            needSendRequest = YES;
            break;
        }
        case BJHTTPClientOffLineCachePolicy: {
            id cacheObject = [self.shareCache cacheResponObjectForKey:cacheKey];
            if (cacheObject) {
                success(nil,cacheObject,YES);
            }else{
                failure(nil,nil);
            }
            break;
        }
        
        case BJHTTPClientDontLoadCachePolicy: {
            needSendRequest = YES;
            break;
        }
            
        case BJHTTPDownloadCacheUseProtocolCachePolicy:{
        
            needSendRequest = YES;
            break;
        }
            
    }
    
    if (needSendRequest) {
        NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                                      cacheHeader:cacheHeader
                                                      cachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
                                                          success:^(NSURLSessionDataTask *task , id responseObject) {
                                                          if (task.bjCachePolicy == BJHTTPClientAskServerIfModifiedCachePolicy || task.bjCachePolicy == BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy) {
                                                              
                                                              //更新缓存内容
                                                              [self.shareCache storeResponseForTask:task
                                                                                     responseObject:responseObject];
                                                          }
                                                          
                                                          success(task,responseObject,NO);
                                                          
                                                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          if (task.bjCachePolicy == BJHTTPClientAskServerIfModifiedCachePolicy || task.bjCachePolicy == BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy) {
                                                             
                                                              [self.shareCache storeResponseForTask:task
                                                                                     responseObject:nil];
                                                              
                                                              id cacheObjet = [self.shareCache cacheResponObjectForKey:task.bjCacheKey];
                                                              if (cacheObjet) {
                                                                  //带缓存的请求，请求失败后会返回缓存内容
                                                                  success(task,[self.shareCache cacheResponObjectForKey:task.bjCacheKey],YES);
                                                              }
                                                              else
                                                              {
                                                                  failure(task,error);
                                                              }
                                                              
                                                            
                                                              
                                                              
                                                          }else{
                                                              failure(task,error);
                                                          }
                                                          
                                                      }];
        task.bjCachePolicy = cachePolicy;
        task.bjMaxAge = age;
        task.bjCacheKey = cacheKey;
        
        [task resume];
        
        return task;

    }else{
        return nil;
    }
}

#pragma mark - 
+(instancetype)shareClientWithBaseURLString:(NSString *)baseURLString
{

    NSString *baseMd5 = [baseURLString md5_origin];
    BJHTTPClient *client = [BJHTTPDownloadCache shareHttpDownloadCache].httpClientManage[baseMd5];
    if (!client) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //configuration.URLCache = nil;
        client =  [[BJHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]
                                   sessionConfiguration:configuration];
        [[BJHTTPDownloadCache shareHttpDownloadCache].httpClientManage setObject:client
                                                                          forKey:baseMd5];
    }
    return client;
   
}

#pragma mark -
@end
