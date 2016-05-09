//
//  NDURLInterceptor.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDURLInput.h"
#import "NDURLResult.h"

@protocol NDURLInterceptor <NSObject>

@optional
/// 执行前拦截，返回YES表示中断后续处理

/**
 *  执行前处理，判断是否要打开URL，并可以对打开参数进行修改
 *
 *  @param routerParameters Router参数，详见｀NDURLRouter｀
 *  @return 是否要继续打开URL
 */
- (BOOL)shouldOpenURLWithInput:(NDURLInput *)input completion:(void (^)(NDURLResult *result))completion;

/**
 *  执行后处理
 *
 *  @param input OpenURL的输入，详见｀NDURLInput｀
 *  @param result OpenURL的结果，详见｀NDURLResult｀
 */
- (NDURLResult *)didOpenURLWithInput:(NDURLInput *)input result:(NDURLResult *)result;

@end

/**
 * 用来拦截NDURLRouter的block操作，实现简单的面向切片的功能
 */
@interface NDURLInterceptor : NSObject <NDURLInterceptor>

/// 拦截器的名字，可用来调试
@property (nonatomic, strong) NSString *name;

/// 顺序，用于多个interceptor排序
@property (nonatomic, strong) NSNumber *sort;

/**
 *  检查当前拦截器是否匹配一个URL
 *
 *  @param urlPattern 待匹配的URL
 *  @param parameters 待匹配的参数
 */
- (BOOL)isMatchURLWithInput:(NDURLInput *)input;

/**
 *  protected method. used for subclass.
 */
- (void)interceptWithURL:(NSString *)url originalInput:(NDURLInput *)originalInput originalCompletion:(void (^)(NDURLResult *result))originalCompletion;

@end