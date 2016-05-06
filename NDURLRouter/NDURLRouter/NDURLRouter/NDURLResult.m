//
//  NDURLResult.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLResult.h"
#import "NDURLInput.h"
#import "NDURLOpenOptions.h"

NSString *const NDURLErrorDomain = @"NDURLErrorDomain";

@implementation NDURLResult

+ (instancetype)resultWithInput:(NDURLInput *)input source:(UIViewController *)source destination:(UIViewController *)destination error:(NSError *)error
{
    NDURLResult *result = [[self alloc] init];
    result.input = input;
    result.success = error == nil;
    result.sourceViewController = source ?: input.options.sourceViewController;
    result.destinationViewController = destination;
    result.error = error;
    return result;
}

+ (instancetype)errorResultWithInput:(NDURLInput *)input messsage:(NSString *)message
{
    NSString *desc = [NSString stringWithFormat:@"url: %@, message: %@", input.url, message];
    NSError *error = [NSError errorWithDomain:NDURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: desc}];
    return [self resultWithInput:input source:nil destination:nil error:error];
}

@end
