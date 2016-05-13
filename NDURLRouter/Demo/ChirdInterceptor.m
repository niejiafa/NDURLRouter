//
//  ChirdInterceptor.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/12.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "ChirdInterceptor.h"

@implementation ChirdInterceptor

- (BOOL)shouldOpenURLWithInput:(NDURLInput *)input completion:(void (^)(NDURLResult *))completion
{
    BOOL isLogin = NO;
    
    if (!isLogin)
    {
        // 未登录
        [self interceptWithURL:@"nd://jincieryi.com.cn/login?action=present" originalInput:input originalCompletion:completion];
        
        return NO;
    }
    
    return YES;
}

@end
