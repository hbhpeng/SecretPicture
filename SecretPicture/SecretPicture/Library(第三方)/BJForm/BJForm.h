//
//  BJForm.h
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/26.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BJHTTPClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol BJFormItemProtocol;

typedef void (^FormBegin)(id<BJFormItemProtocol> oldFormItem, id context);

typedef void (^FormEnd)(id context);

typedef void (^FormSubmit)(NSDictionary *param);

@protocol BJFormItemProtocol <NSObject>

@property (copy, nonatomic) FormBegin formBegin;
//- (void)setFormBegin:(void (^)(id<BJFormItemProtocol> oldFormItem, id context))formBegin;
//
//- (void (^)(id<BJFormItemProtocol> oldFormItem, id context))formBegin;

@property (copy, nonatomic) FormEnd formEnd;
//- (void)setFormEnd:(void (^)(id context))formEnd;
//
//- (void (^)(id context))formEnd;

@property (copy, nonatomic) NSString *formName;

@property (copy, nonatomic) id (^formValue)(BOOL *stop, NSString **message, id<BJFormItemProtocol> formItem);
//- (void)setFormValue:(id (^)(BOOL *stop, id<BJFormItemProtocol> formItem))formValue;
//
//- (id (^)(BOOL *stop, id<BJFormItemProtocol> formItem))formValue;

@optional
@property (copy, nonatomic) FormSubmit formSubmit; //暂时没用

@end

@interface BJForm : NSObject

@property (strong, nonatomic) NSString *method;

@property (strong, nonatomic) NSString *url;

@property (weak, nonatomic) id context;

@property (assign, nonatomic) BOOL force; //default BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy

@property (assign, nonatomic) BJHTTPClientRequestCachePolicy cachePolicy; //defalut BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy

@property (assign, nonatomic) NSTimeInterval maxAge;

@property (assign, nonatomic) NSTimeInterval timeoutIntervalForRequest;

@property (copy, nonatomic) id (^responseStringHandler)(id responseString);

+ (instancetype)formWithMethod:(NSString *)method path:(NSString *)url context:(id)context;

- (void)form;

- (void)addItem:(id<BJFormItemProtocol>)formItem;

- (void)addItems:(id<BJFormItemProtocol>)formItem,... NS_REQUIRES_NIL_TERMINATION;

- (void)initItems:(id<BJFormItemProtocol>)formItem,... NS_REQUIRES_NIL_TERMINATION;

- (void)addValue:(id)value forKey:(id)key;

- (void)addValue:(id)value forKey:(id)key constraint:(BOOL (^)(NSString **message, id value))constraint;

- (RACCommand *)formCommand;

@end
