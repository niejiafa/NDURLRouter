//
//  NDURLManager.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLManager.h"

@implementation NDURLManager

#pragma mark - life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        instance = [[self alloc] init];
        NSLog(@"duration = %f", [NSDate timeIntervalSinceReferenceDate] - start);
    });
    return instance;
}

@end
