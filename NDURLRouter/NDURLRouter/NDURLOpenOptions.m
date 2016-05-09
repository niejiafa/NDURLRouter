//
//  NDURLOpenOptions.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLOpenOptions.h"

NSString *const NDURLOpenActionPush = @"push";
NSString *const NDURLOpenActionPresent = @"present";

@implementation NDURLOpenOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animated = YES;
    }
    return self;
}

+ (instancetype)optionsWithViewProperties:(NSDictionary *)viewProperties
{
    NDURLOpenOptions *options = self.new;
    options.viewProperties = viewProperties;
    return options;
}

+ (instancetype)optionsWithParameters:(NSDictionary *)parameters
{
    NDURLOpenOptions *options = self.new;
    options.parameters = parameters;
    return options;
}

@end
