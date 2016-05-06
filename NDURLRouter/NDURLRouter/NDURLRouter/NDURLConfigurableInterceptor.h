//
//  NDURLConfigurableInterceptor.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLInterceptor.h"

@interface NDURLConfigurableInterceptor : NDURLInterceptor

@property (strong, nonatomic) NSArray<NSString *> *urls;
@property (strong, nonatomic) NSArray<NSString *> *urlPrefixs;
@property (strong, nonatomic) NSArray<NSString *> *except;
@property (strong, nonatomic) NSArray<NSString *> *exceptPrefixs;

/// url的参数是否参与匹配
@property (nonatomic) BOOL shouldMatchParameters;

@end
