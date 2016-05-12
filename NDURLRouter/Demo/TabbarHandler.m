//
//  TabbarHandler.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/12.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "TabbarHandler.h"

@implementation TabbarHandler

#pragma mark - overwrite

- (void)openURLWithInput:(NDURLInput *)input completion:(void (^)(NDURLResult *))completion
{
    NSInteger tab = [input.parameters[@"tab"] integerValue];
    UITabBarController *tabController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabController isKindOfClass:[UINavigationController class]]) {
        tabController = [(UINavigationController *)tabController viewControllers].lastObject;
    }
    if ([tabController isKindOfClass:[UITabBarController class]]) {
        if (tab < tabController.viewControllers.count) {
            tabController.selectedIndex = tab;
            return;
        }
    }
}

@end
