//
//  NSURLSessionDataTask+cachePolicy.h
//  BJHttpClient
//
//  Created by bita on 16/1/8.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJHttpClient.h"

@interface NSURLSessionTask (CachePolicy)

@property (nonatomic, assign)BJHTTPClientRequestCachePolicy bjCachePolicy;
@property (nonatomic, assign) NSTimeInterval bjMaxAge;
@property (nonatomic,copy) NSString *bjCacheKey;
@end
