//
//  NDURLSupport.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDURLInput.h"

/**
 *  此接口用来支持URL跳转时的自定义处理
 */
@protocol NDURLSupport <NSObject>

@optional

/**
 *  一个ViewController实现此接口用来接收URL的传参
 *  
 *  @param input  打开URL时的入参
 */
- (void)prepareWithURLInput:(NDURLInput *)input;

@end
