//
//  BJFormItem.m
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/26.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJFormItem.h"

@interface BJFormItem ()

@end

@implementation BJFormItem

+ (instancetype)itemWithName:(NSString *)name value:(id (^)(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem))value
{
    return [[self alloc] initWithName:name value:value];
}

- (instancetype)initWithName:(NSString *)name value:(id (^)(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem))value
{
    if (self = [super init]) {
        self.formName = name;
        if(value)
        {
            self.formValue = value;
        }
        else{
            @weakify(self);
            self.formValue = ^(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem){
                @strongify(self);
                return self.defaultValue;
            };
        }
    }
    return self;
}

- (BJFormItem * (^)(id value))setDefaultValue
{
    return ^BJFormItem * (id value){
        self.defaultValue = value;
        return self;
    };
}

@end
