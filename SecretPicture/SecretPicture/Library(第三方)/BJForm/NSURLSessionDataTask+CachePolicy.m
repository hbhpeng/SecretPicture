//
//  NSURLSessionDataTask+cachePolicy.m
//  BJHttpClient
//
//  Created by bita on 16/1/8.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "NSURLSessionDataTask+cachePolicy.h"
#import <objc/runtime.h>

@implementation NSObject (CachePolicy)

-(BJHTTPClientRequestCachePolicy)bjCachePolicy
{
    
    NSNumber *policy = objc_getAssociatedObject(self, @selector(bjCachePolicy));
    
    return [policy unsignedIntegerValue];
}

-(void)setBjCachePolicy:(BJHTTPClientRequestCachePolicy)cachePolicy
{

    objc_setAssociatedObject(self, @selector(bjCachePolicy), @(cachePolicy), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSTimeInterval)bjMaxAge
{

    NSNumber *age = objc_getAssociatedObject(self, @selector(bjMaxAge));
    return [age doubleValue];
}

-(void)setBjMaxAge:(NSTimeInterval)maxAge
{

    objc_setAssociatedObject(self,@selector(bjMaxAge),@(maxAge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSString*)bjCacheKey
{

    return objc_getAssociatedObject(self, @selector(bjCacheKey));
}

-(void)setBjCacheKey:(NSString *)cacheKey{

    objc_setAssociatedObject(self, @selector(bjCacheKey), cacheKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
