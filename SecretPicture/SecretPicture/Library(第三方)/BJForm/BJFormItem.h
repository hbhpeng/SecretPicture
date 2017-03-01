//
//  BJFormItem.h
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/26.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BJForm.h"

@interface BJFormItem : NSObject <BJFormItemProtocol>

@property (copy, nonatomic) void (^formBegin)(id<BJFormItemProtocol> oldFormItem, id context);

@property (copy, nonatomic) FormEnd formEnd;

@property (copy, nonatomic) NSString *formName;

@property (copy, nonatomic) id (^formValue)(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem);

@property (strong, nonatomic) id defaultValue;

+ (instancetype)itemWithName:(NSString *)name value:(id (^)(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem))value;

- (BJFormItem * (^)(id value))setDefaultValue;

- (void)setFormValue:(id (^)(BOOL *stop,NSString **message, id<BJFormItemProtocol> formItem))formValue;

@end
