//
//  NDURLResult.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const NDURLErrorDomain;
extern NSString *const NDURLExceptionKey;

@class NDURLInput;

/**
 *  OpenURL的结果，会在openURL之后通过completion返回。
 */
@interface NDURLResult : NSObject

/// 是否成功
@property (nonatomic) BOOL success;

/// 源viewController
@property (nonatomic, weak) UIViewController *sourceViewController;
/// 跳向的viewController
@property (nonatomic, weak) UIViewController *destinationViewController;

/// 返回的结果（有请求的时候）
@property (nonatomic, strong) id response;

/// 错误信息
@property (nonatomic, strong) NSError *error;

/// 自定义信息
@property (nonatomic, strong) NSDictionary *userInfo;

/// OpenURL的输入
@property (nonatomic, strong) NDURLInput *input;

/// 引用的结果，目前可可能是被interceptor打断后interceptor跳转的结果
@property (nonatomic, strong) NDURLResult *refer;

+ (instancetype)resultWithInput:(NDURLInput *)input source:(UIViewController *)source destination:(UIViewController *)destination error:(NSError *)error;
+ (instancetype)errorResultWithInput:(NDURLInput *)input messsage:(NSString *)message;

@end
