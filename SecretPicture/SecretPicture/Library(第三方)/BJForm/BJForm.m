//
//  BJForm.m
//  autoPrice
//
//  Created by 鹏 侯 on 16/12/26.
//  Copyright © 2016年 Bitauto. All rights reserved.
//

#import "BJForm.h"

#import "BJResponseModel.h"

#import "BJFormItem.h"

#define kNormalDatatimeoutInterval 5*60

@interface BJForm ()

@property (assign, nonatomic) BOOL beginForm;

@property (strong, nonatomic) NSMutableArray <id <BJFormItemProtocol>> *itemArray;

//@property (strong, nonatomic) RACCommand *formCommand;

@end

@implementation BJForm

- (void)dealloc
{
    
}

+ (instancetype)formWithMethod:(NSString *)method path:(NSString *)url context:(id)context
{
    return [[BJForm alloc] initWithMethod:method path:url context:context];
}

- (instancetype)initWithMethod:(NSString *)method path:(NSString *)url context:(id)context
{
    if (self = [super init]) {
        self.method = method;
        self.url = url;
        self.context = context;
        self.itemArray = [NSMutableArray array];
        self.cachePolicy = 0xFFF0;
    }
    return self;
}

- (void)begin
{
    _beginForm = YES;
}

- (void)clear
{
    [self.itemArray removeAllObjects];
}

- (void)addItem:(id<BJFormItemProtocol>)formItem
{
    [self.itemArray addObject:formItem];
}

- (void)addItems:(id<BJFormItemProtocol>)formItem,... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *tempArray = [NSMutableArray array];
    va_list argList;
    va_start(argList, formItem);
    for (id currentObject = formItem; currentObject != nil; currentObject = va_arg(argList, id)) {
        [tempArray addObject:currentObject];
    }
    va_end(argList);
    [self.itemArray addObjectsFromArray:tempArray];
}

- (void)initItems:(id<BJFormItemProtocol>)formItem,... NS_REQUIRES_NIL_TERMINATION
{
    [self clear];
    NSMutableArray *tempArray = [NSMutableArray array];
    va_list argList;
    va_start(argList, formItem);
    for (id currentObject = formItem; currentObject != nil; currentObject = va_arg(argList, id)) {
        [tempArray addObject:currentObject];
    }
    va_end(argList);
    [self.itemArray addObjectsFromArray:tempArray];
}

- (void)addValue:(id)value forKey:(id)key
{
    [self addItem:[BJFormItem itemWithName:key value:^id(BOOL *stop, NSString *__autoreleasing *message, id<BJFormItemProtocol> formItem) {
        return value;
    }]];
}

- (void)addValue:(id)value forKey:(id)key constraint:(BOOL (^)(NSString **message, id value))constraint
{
    [self addItem:[BJFormItem itemWithName:key value:^id(BOOL *stop, NSString *__autoreleasing *message, id<BJFormItemProtocol> formItem) {
        if(constraint)
        {
            *stop = !constraint(message,value);
        }
        return value;
    }]];
}

- (void)form
{
    id<BJFormItemProtocol> oldItem = nil;
    for (id<BJFormItemProtocol> item in self.itemArray) {
        if ([item formBegin])
        {
            [item formBegin](oldItem,self.context);
        }
    }
    if([[self.itemArray lastObject] formEnd])
    {
        [[self.itemArray lastObject] formEnd](self.context);
    }
}

- (RACCommand *)formCommand
{
//    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            @strongify(self);
            BJHTTPClientRequestCachePolicy policy =  BJHTTPClientAskServerIfModifiedWhenStaleCachePolicy;
            if(!(self.cachePolicy & 0xFFF0))
            {
                policy = self.cachePolicy;
            }
            else{
                if (self.force) {
                    policy = BJHTTPClientDontLoadCachePolicy;
                }
            }
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            NSString *message = nil;
            BOOL stop = NO;
            for (id<BJFormItemProtocol>item in self.itemArray) {
                if([[item formName] length] && [item formValue])
                {
                    id object = [item formValue](&stop,&message,item);
                    if (stop) {
                        if (!message.length) {
                            message = @"";
                        }
                        BJResponseModel *model = [[BJResponseModel alloc] init];
                        model.status = BJResponseNone;
                        model.message = message;
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                        return nil;
                    }
                    if (object) {
                        [paramDic setObject:object forKey:[item formName]];
                    }
                }
            }
            
            NSURLSessionDataTask *task = nil;
            NSString *infoString = [paramDic queryString];
            
            if (_maxAge <= 0)
            {
                _maxAge = kNormalDatatimeoutInterval;
            }
            
            void (^successHandler)(id jsonValue, BOOL) = ^(id jsonValue, BOOL isUseCache){
                BJResponseModel *model = [BJResponseModel responseModelWithData:jsonValue];
                model.isUseCache = isUseCache;
                model.cachePolicy = policy;
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            };
            
            void (^errorHandler)(NSError *error) = ^(NSError *error){
                BJResponseModel *model = [BJResponseModel responseModelWithData:error];
                model.cachePolicy = policy;
                [subscriber sendNext:model];
                [subscriber sendError:error];
            };
            
            
            BJHTTPClient *client = [BJHTTPClient shareClientWithBaseURLString:self.url];
            if (self.timeoutIntervalForRequest > 0) {
                client.requestSerializer.timeoutInterval = self.timeoutIntervalForRequest;
            }
            else{
                client.requestSerializer.timeoutInterval = 60.f;
            }
            
            if ([self.method compare:@"get" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                task = [client GET:[NSString stringWithFormat:@"%@&sign=%@",infoString,[infoString md5]] parameters:nil cachePolicy:policy maxAge:_maxAge success:^(NSURLSessionDataTask *task, id responseObject, BOOL useCache) {
                    NSString *responseStr = [[NSString alloc]initWithData:responseObject
                                                                 encoding:NSUTF8StringEncoding];
                    id jsonValue = nil;
                    if (!_responseStringHandler)
                    {
                        jsonValue = [responseStr BJJSONValue];
                    }
                    else{
                        jsonValue = _responseStringHandler(responseStr);
                    }
                    
                    successHandler(jsonValue, useCache);
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    errorHandler(error);
                }];
            }
            else{
                //post
                paramDic[@"sign"] = [infoString md5];
                task = [client POST:self.url parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *responseStr = [[NSString alloc]initWithData:responseObject
                                                                 encoding:NSUTF8StringEncoding];
                    id jsonValue = nil;
                    if (!_responseStringHandler)
                    {
                        jsonValue = [responseStr BJJSONValue];
                    }
                    else{
                        jsonValue = _responseStringHandler(responseStr);
                    }
                    successHandler(jsonValue, NO);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    errorHandler(error);
                }];
            }
            
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }];
//    return self.formCommand;
}

@end
