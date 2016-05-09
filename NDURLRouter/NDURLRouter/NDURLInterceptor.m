//
//  NDURLInterceptor.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLInterceptor.h"
#import "NDURLRouter.h"

@interface NDURLInterceptor ()

@end

@implementation NDURLInterceptor

+ (Class)modelCustomClassForDictionary:(NSDictionary *)dic
{
    NSString *className = dic[@"class"];
    if (className.length > 0) {
        Class clz = NSClassFromString(className);
        if (clz) {
            return clz;
        }
    }
    return self.class;
}

- (BOOL)isMatchURLWithInput:(NDURLInput *)input
{
    return NO;
}

- (void)interceptWithURL:(NSString *)url originalInput:(NDURLInput *)originalInput originalCompletion:(void (^)(NDURLResult *))originalCompletion
{
    NDURLOpenOptions *options = originalInput.options ?: [[NDURLOpenOptions alloc] init];
    if (!options.sourceURL) {
        options.sourceURL = originalInput.url;
    }
    [NDURLRouter openURL:url options:options completion:^(NDURLResult *r2) {
        if (originalCompletion) {
            NDURLResult *result = [NDURLResult resultWithInput:originalInput source:nil destination:nil error:nil];
            result.refer = r2;
            originalCompletion(result);
        }
    }];
}

@end