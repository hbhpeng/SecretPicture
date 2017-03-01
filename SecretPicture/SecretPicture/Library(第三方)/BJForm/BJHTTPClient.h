//
//  BJHttpClient.h
//  LYHttpClient
//
//  Created by bita on 16/1/8.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJHTTPSessionManager.h"

typedef void(^BJHTTPClientSuccessBlock)(id result,NSDate * fetchdate,BOOL isUsecache);

typedef void(^BJHTTPClientPageSuccessBlock)(id result,NSInteger pageIndex,NSDate * fetchdate);

typedef void(^BJHTTPClientFailureBlock)(NSError * error);

@interface BJHTTPClient : BJHTTPSessionManager


/**
 *
 *
 *  @param URLString
 *  @param parameters  url 参数
 *  @param cachePolicy cache策略
 *  @param age         外部缓存的时间
 *  @param success     成功回调
 *  @param failure     失败回调
 *
 *  @return
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
                       maxAge:(NSTimeInterval)age
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject,BOOL useCache))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  根据baseurl 创建clientManage单例
 *
 *  @param baseURLString
 *
 *  @return 
 */
+(instancetype)shareClientWithBaseURLString:(NSString*)baseURLString;

@end






