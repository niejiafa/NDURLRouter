//
//  NDURLManager.h
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDURLOpenOptions.h"
#import "NDURLResult.h"

@interface NDURLManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)canOpenURL:(NSString *)url;
- (void)openURL:(NSString *)url options:(NDURLOpenOptions *)options completion:(void (^)(NDURLResult *result))completion;

@end
