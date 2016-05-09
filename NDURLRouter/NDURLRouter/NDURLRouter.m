//
//  NDURLRouter.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLRouter.h"
#import "YYModel.h"
#import "MGJRouter.h"
#import "NDURLInterceptor.h"
#import "NDURLHandler.h"
#import "NDURLManager.h"

@implementation NDURLRouter

#pragma mark - public
+ (void)loadConfiguration
{
    [NDURLManager sharedInstance];
}

+ (BOOL)canOpenURL:(NSString *)URL
{
    if (![URL isKindOfClass:[NSString class]] || [URL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    
    return [[NDURLManager sharedInstance] canOpenURL:URL];
}

+ (void)openURL:(NSString *)URL
{
    return [self openURL:URL options:nil completion:nil];
}

+ (void)openURL:(NSString *)url options:(NDURLOpenOptions *)options completion:(void (^)(NDURLResult *))completion
{
    if (![self canOpenURL:url]) {
        return;
    }
    
    [[NDURLManager sharedInstance] openURL:url options:options completion:completion];
}

@end