//
//  BJResponseModel.h
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/27.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BJForm.h"

typedef NS_ENUM(NSUInteger, BJResponseStatus) {
    BJResponseNone, //未发出请求
    BJResponseSucess, //成功 Status = 2
    BJResponseException, //成功 Status != 2
    BJResponseUnKnownData, //成功 数据类型无法解析
    BJResponseError, //失败 error
};

@interface BJResponseModel : NSObject

@property (assign, nonatomic) BJResponseStatus status; //rawData[@"Status"]

@property (copy, nonatomic) NSString *message; //rawData[@"Message"]

@property (strong, nonatomic) id data; //rawData[@"Data"]

@property (strong, nonatomic) NSError *error; //response error

@property (strong, nonatomic) id rawData;

@property (assign, nonatomic) BJHTTPClientRequestCachePolicy cachePolicy;

@property (assign, nonatomic) BOOL isUseCache;

+ (instancetype)responseModelWithData:(id)data;

@end
