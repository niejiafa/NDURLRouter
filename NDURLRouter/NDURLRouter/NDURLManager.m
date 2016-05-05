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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self nd_loadConfiguration];
    }
    return self;
}

#pragma mark - private

- (void)nd_loadConfiguration
{
    NSURL *configURL = [[NSBundle mainBundle] URLForResource:@"NDURLConfiguration" withExtension:@"plist"];
    NSAssert(configURL, @"Can't find configuration file.");
    [self nd_loadConfigurationWithURL:configURL];
}

- (void)nd_loadConfigurationWithURL:(NSURL *)configurationURL
{
    
}

@end
