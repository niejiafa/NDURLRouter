//
//  NDURLInput.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDURLOpenOptions.h"

/*!
 *  OpenURL的输入
 */
@interface NDURLInput : NSObject

/// 需要打开的URL
@property (nonatomic, strong) NSString *url;

/// URL的scheme
@property (nonatomic, strong) NSString *scheme;

/// 用来匹配Handler的pattern，一般为URL的scheme://host/path
@property (nonatomic, strong) NSString *pattern;

/// URL入参。包含从URL解析的, 和options里传来的, 已经URL解码过
@property (nonatomic, strong) NSMutableDictionary *parameters;

/// 打开URL时传入的额外参数, @see NDURLOpenOptions
@property (nonatomic, strong) NDURLOpenOptions *options;

@end
