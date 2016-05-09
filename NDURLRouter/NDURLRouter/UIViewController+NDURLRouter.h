//
//  UIViewController+NDURLRouter.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDURLOpenOptions.h"
#import "NDURLResult.h"

/// NSDictionary，用于设置open起来的ViewController的属性
extern NSString *const NDURLRouterViewPropertiesKey;

@interface UIViewController (NDURLRouter)

/**
 *  使用自己的navigationController作为额外参数来打开URL
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 */
- (void)openURL:(NSString *)url;

/**
 *  使用自己的navigationController作为额外参数来打开URL
 *
 *  @param url          带 Scheme 的 URL，如 mgj://beauty/4
 *  @param fallbackURL  被拦截后跳转到的URL
 */
- (void)openURL:(NSString *)url interceptedFallbackURL:(NSString *)fallbackURL;

/**
 *  使用自己的navigationController作为额外参数来打开URL
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param options    附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
- (void)openURL:(NSString *)url options:(NDURLOpenOptions *)options completion:(void (^)(NDURLResult *result))completion;

@end
