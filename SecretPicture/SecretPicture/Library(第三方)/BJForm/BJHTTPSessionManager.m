//
//  BJHTTPSessionManager.m
//  LYHttpClient
//
//  Created by bita on 16/1/7.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJHTTPSessionManager.h"

@implementation BJHTTPSessionManager


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    cacheHeader :(NSDictionary*)cacheHeaders
                                     cachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    if ([URLString hasPrefix:@"?"]) {
        
        NSString *baseUrlString = self.baseURL.absoluteString;
       
        if ([baseUrlString hasSuffix:@"/"] && self.baseURL.lastPathComponent) {
            
            //去掉 例如：http://msn.api.app.yiche.com/api.ashx/?method=credit.getsign&token=B2CC6A19217021AF20BA 这样的baseurl最后一个“/”
            NSString *lastPath = self.baseURL.lastPathComponent;
            
            NSURL *temp = [[self.baseURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:lastPath];
            
            request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:temp] absoluteString] parameters:parameters error:&serializationError];
            
        }else
        {
            request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
        }
       

    }else
    {
         request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    }
    
    if (cachePolicy != BJHTTPDownloadCacheUseProtocolCachePolicy) {
         request.cachePolicy =   NSURLRequestReloadIgnoringLocalCacheData;
    }else{
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    
    /**
     *  设置请求头的etag和If-Modified-Since字段，支持服务器根据客户端版本号，返回新数据或者304跳转
     */
    if ([method isEqualToString:@"GET"] && cacheHeaders && (cachePolicy!= BJHTTPClientDontLoadCachePolicy)) {
        NSString *etag = [cacheHeaders objectForKey:@"Etag"];
        if (etag.length) {
            [request setValue:etag
           forHTTPHeaderField:@"If-None-Match"];
        }
        
        NSString *lastModified = [cacheHeaders objectForKey:@"Last-Modified"];
        if (lastModified) {
            [request setValue:lastModified
           forHTTPHeaderField:@"If-Modified-Since"];
        }

    }
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

@end
