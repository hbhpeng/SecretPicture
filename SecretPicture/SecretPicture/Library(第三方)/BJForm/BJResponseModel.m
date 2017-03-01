//
//  BJResponseModel.m
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/27.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJResponseModel.h"

@implementation BJResponseModel

+ (instancetype)responseModelWithData:(id)data
{
    return [[self alloc] initModelWithData:data];
}

- (instancetype)initModelWithData:(id)data
{
    if (self = [super init]) {
       
        if ([data isKindOfClass:[NSDictionary class]]) {
            self.rawData = data;
            if ([data[@"Status"] integerValue] == 2) {
                self.status = BJResponseSucess;
                self.data = data[@"Data"];
            }
            else{
                self.status = BJResponseException;
                self.message = data[@"Message"];
            }
        }
        else if ([data isKindOfClass:[NSError class]]){
            self.error = data;
            self.status = BJResponseError;
        }
        else{
            self.status = BJResponseUnKnownData;
            self.rawData = data;
        }
    }
    return self;
}

- (BOOL)isRequestSuccess
{
    return self.status != BJResponseNone && self.status != BJResponseError;
}

@end
