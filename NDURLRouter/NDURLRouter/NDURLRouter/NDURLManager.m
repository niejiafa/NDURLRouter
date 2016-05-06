//
//  NDURLManager.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLManager.h"
#import "NDURLConfigurableInterceptor.h"
#import "YYModel.h"
#import "NDURLInput.h"
#import "NDURLHandler.h"

@interface NDURLManager ()

@property (nonatomic, strong) NSMutableDictionary *handlersMetaCache;
@property (nonatomic, strong) NSMutableArray *interceptors;

/// For effecient of opening url. All refers of interceptors is from self.interceptors
@property (nonatomic, strong) NSMutableDictionary<NSString *, NDURLInterceptor *> *urlInterceptorsCache;
@property (nonatomic, strong) NSMutableArray<NDURLInterceptor *> *parameterMatchingInterceptors;

@end

@implementation NDURLManager

#pragma mark - lifecycle

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        instance = self.new;
        NSLog(@"duration = %f", [NSDate timeIntervalSinceReferenceDate] - start);
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadConfiguration];
    }
    return self;
}

#pragma mark - public

- (BOOL)canOpenURL:(NSString *)urlString
{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    components.query = nil;
    components.fragment = nil;
    components.user = nil;
    components.password = nil;
    NSString *pattern = components.URL.absoluteString;
    
    BOOL found = pattern && self.handlersMetaCache[pattern];
    if (!found) {
        NSString *scheme = components.scheme.lowercaseString;
        found = scheme && self.handlersMetaCache[scheme];
    }
    return found;
}

- (void)openURL:(NSString *)urlString options:(NDURLOpenOptions *)options completion:(void (^)(NDURLResult *))completion
{
    void (^c2)(NDURLResult *result) = ^(NDURLResult *result) {
        NDURLResult *output = [self processPostInterceptorsWithInput:result.input result:result];
        if (completion) {
            completion(output);
        }
    };
    NDURLInput *input = [self parseURLWithString:urlString options:options];
    if (![self processPreInterceptorsWithInput:input completion:c2]) {
        return;
    }
    
    NSDictionary *meta = self.handlersMetaCache[input.pattern];
    if (!meta) {
        meta = self.handlersMetaCache[input.scheme];
    }
    NDURLHandler *handler = [meta isKindOfClass:[NSDictionary class]] ? [NDURLHandler yy_modelWithJSON:meta] : nil;
    if (!handler) {
        c2([NDURLResult errorResultWithInput:input messsage:@"Create handler failed."]);
        return;
    }
    
    [handler openURLWithInput:input completion:c2];
}

#pragma mark - private

- (void)loadConfiguration
{
    NSURL *configURL = [[NSBundle mainBundle] URLForResource:@"NDURLConfiguration" withExtension:@"plist"];
    NSAssert(configURL, @"Can't find configuration file.");
    [self loadConfigurationWithURL:configURL];
}

- (void)loadConfigurationWithURL:(NSURL *)configurationURL
{
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:configurationURL];
    
    // don't parse parameters for efficient.
    NSMutableDictionary *inputs = [NSMutableDictionary dictionary];
    
    {
        NSDictionary *handlerConfigs = config[@"handlers"];
        NSMutableDictionary *handlers = [NSMutableDictionary dictionary];
        
        void (^block)(NSString *url, NSDictionary *meta) = ^(NSString *url, NSDictionary *meta) {
            handlers[url] = meta;
            NDURLInput *input = [[NDURLInput alloc] init];
            input.url = url;
            NSURLComponents *components = [NSURLComponents componentsWithString:url];
            components.query = nil;
            components.fragment = nil;
            components.user = nil;
            components.password = nil;
            input.scheme = components.scheme.lowercaseString;
            input.pattern = components.URL.absoluteString.lowercaseString;
            inputs[url] = input;
        };
        [handlerConfigs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableDictionary *temp = [obj mutableCopy];
            temp[@"name"] = key;
            NSString *url = temp[@"url"];
            NSArray *urls = temp[@"urls"];
            if (urls) {
                [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop2) {
                    temp[@"url"] = obj2;
                    block(obj2, temp);
                }];
            }
            if (url) {
                block(url, temp);
            }
        }];
        self.handlersMetaCache = handlers;
    }
    {
        NSDictionary *interceptorConfigs = config[@"interceptors"];
        NSMutableArray<NDURLConfigurableInterceptor *> *interceptors = [NSMutableArray array];
        [interceptorConfigs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NDURLConfigurableInterceptor *interceptor = [NDURLConfigurableInterceptor yy_modelWithJSON:obj];
            if (!interceptor) {
                return;
            }
            
            if (!interceptor.name) {
                interceptor.name = key;
            }
            [interceptors addObject:interceptor];
        }];
        
        [interceptors sortUsingComparator:^NSComparisonResult(NDURLConfigurableInterceptor *obj1, NDURLConfigurableInterceptor *obj2) {
            return [obj1.sort compare:obj2.sort];
        }];
        self.interceptors = interceptors;
        
        NSMutableDictionary *urlInterceptorsCache = [NSMutableDictionary dictionary];
        NSMutableArray *parameterMatchingInterceptors = [NSMutableArray array];
        [interceptors enumerateObjectsUsingBlock:^(NDURLConfigurableInterceptor * _Nonnull interceptor, NSUInteger idx, BOOL * _Nonnull stop) {
            if (interceptor.shouldMatchParameters) {
                [parameterMatchingInterceptors addObject:interceptor];
                return;
            }
            
            [inputs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NDURLInput *obj, BOOL * _Nonnull stop) {
                if ([interceptor isMatchURLWithInput:obj]) {
                    NSString *key = obj.url;
                    NSMutableArray *temp = urlInterceptorsCache[key];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        urlInterceptorsCache[key] = temp;
                    }
                    [temp addObject:interceptor];
                }
            }];
        }];
        self.urlInterceptorsCache = urlInterceptorsCache;
        self.parameterMatchingInterceptors = parameterMatchingInterceptors;
    }
}

- (NDURLInput *)parseURLWithString:(NSString *)urlString options:(NDURLOpenOptions *)options
{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    NSString *scheme = components.scheme;
    NSString *query = components.query;
    
    components.query = nil;
    components.fragment = nil;
    components.user = nil;
    components.password = nil;
    NSString *pattern = components.URL.absoluteString;
    
    NSArray *queryItems = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [queryItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *keyValue = [obj componentsSeparatedByString:@"="];
        if (keyValue.count != 2) {
            return;
        }
        
        NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
        if (key.length == 0) {
            return;
        }
        
        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
        if (value.length == 0) {
            return;
        }
        
        id oldValue = parameters[key];
        if (oldValue) {
            if (![oldValue isKindOfClass:[NSMutableArray class]]) {
                oldValue = [NSMutableArray arrayWithObject:oldValue];
                parameters[key] = oldValue;
            }
            [oldValue addObject:value];
        } else {
            parameters[key] = value;
        }
    }];
    
    if (options.parameters.count > 0) {
        [parameters addEntriesFromDictionary:options.parameters];
    }
    
    NDURLInput *inputs = [[NDURLInput alloc] init];
    inputs.url = urlString;
    inputs.scheme = scheme.lowercaseString;
    inputs.pattern = pattern.lowercaseString;
    inputs.parameters = parameters;
    inputs.options = options;
    return inputs;
}

- (BOOL)processPreInterceptorsWithInput:(NDURLInput *)input completion:(void (^)(NDURLResult *result))completion
{
    if (!input.pattern) {
        return YES;
    }
    
    __block BOOL pass = YES;
    void (^block)(NDURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) = ^(NDURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj respondsToSelector:@selector(shouldOpenURLWithInput:completion:)]) {
            return;
        }
        if (![obj shouldOpenURLWithInput:input completion:completion]) {
            pass = NO;
            *stop = YES;
        }
    };
    
    NSArray<NDURLInterceptor *> *interceptors = (NSArray *)self.urlInterceptorsCache[input.pattern];
    [interceptors enumerateObjectsUsingBlock:block];
    if (!pass) {
        return NO;
    }
    
    [self.parameterMatchingInterceptors enumerateObjectsUsingBlock:block];
    return pass;
}


- (NDURLResult *)processPostInterceptorsWithInput:(NDURLInput *)input result:(NDURLResult *)result
{
    if (!input.pattern) {
        return result;
    }
    
    __block NDURLResult *output = result;
    void (^block)(NDURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) = ^(NDURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(didOpenURLWithInput:result:)]) {
            output = [obj didOpenURLWithInput:input result:result];
        }
    };
    NSArray<NDURLInterceptor *> *interceptors = (NSArray *)self.urlInterceptorsCache[input.pattern];
    [interceptors enumerateObjectsUsingBlock:block];
    [self.parameterMatchingInterceptors enumerateObjectsUsingBlock:block];
    return output;
}

@end
