//
//  UIViewController+NDURLRouter.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "UIViewController+NDURLRouter.h"
#import "NDURLRouter.h"

@implementation UIViewController (NDURLRouter)

- (void)openURL:(NSString *)url
{
    [self openURL:url options:nil completion:nil];
}

- (void)openURL:(NSString *)url interceptedFallbackURL:(NSString *)fallbackURL
{
    NDURLOpenOptions *options = [[NDURLOpenOptions alloc] init];
    options.interceptedFallbackURL = fallbackURL;
    [self openURL:url options:options completion:nil];
}

- (void)openURL:(NSString *)url options:(NDURLOpenOptions *)options completion:(void (^)(NDURLResult *))completion
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    if (!options)
    {
        options = [[NDURLOpenOptions alloc] init];
    }
    if (!options.sourceViewController)
    {
        options.sourceViewController = self;
    }
    [NDURLRouter openURL:url options:options completion:completion];
    NSLog(@"open url: %@, duration: %f", url, [NSDate timeIntervalSinceReferenceDate] - start);
}

@end
