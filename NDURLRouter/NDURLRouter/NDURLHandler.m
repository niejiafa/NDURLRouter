//
//  NDURLHandler.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/5.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NDURLHandler.h"
#import "NDURLRouter.h"
#import "NDURLSupport.h"
#import <objc/runtime.h>

static int NDURLHandlerKey;

@interface NDURLHandler ()

@property (nonatomic, strong) NSDictionary *viewProperties;

@end

@implementation NDURLHandler

#pragma mark - YYModel

+ (Class)modelCustomClassForDictionary:(NSDictionary *)dic
{
    NSString *className = dic[@"class"];
    if (className.length > 0) {
        Class clz = NSClassFromString(className);
        if (clz) {
            return clz;
        }
    }
    return self.class;
}

#pragma mark - public

- (void)openURLWithInput:(NDURLInput *)input completion:(void (^)(NDURLResult *))completion
{
    if (self.redirectURL) {
        NDURLOpenOptions *options = input.options ?: [[NDURLOpenOptions alloc] init];
        if (!options.sourceURL) {
            options.sourceURL = input.url;
        }
        [NDURLRouter openURL:self.redirectURL options:options completion:completion];
        return;
    }
    
    Class clz = NSClassFromString(self.viewController);
    if (clz == nil) {
        if (completion) {
            completion([NDURLResult errorResultWithInput:input messsage:[NSString stringWithFormat:@"Class not found: %@", self.viewController]]);
        }
        return;
    }
    
    UIViewController *vc = [[clz alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (vc == nil) {
        if (completion) {
            completion([NDURLResult errorResultWithInput:input messsage:[NSString stringWithFormat:@"Creating viewController failed: %@", self.viewController]]);
        }
        return;
    }
    
    if ([vc respondsToSelector:@selector(prepareWithURLInput:)]) {
        [(id<NDURLSupport>)vc prepareWithURLInput:input];
    }
    
    NSDictionary *vps = input.options.viewProperties;
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if (self.viewProperties.count > 0) {
        [properties addEntriesFromDictionary:self.viewProperties];
    }
    if (vps.count > 0) {
        [properties addEntriesFromDictionary:vps];
    }
    if (properties.count > 0) {
        @try {
            [properties enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [vc setValue:obj forKeyPath:key];
            }];
        } @catch (NSException *exception) {
            if (completion) {
                completion([NDURLResult resultWithInput:input source:nil destination:vc error:nil]);
            }
            return;
        } @finally {
        }
    }
    
    UIViewController *sourceViewController = input.options.sourceViewController;
    UIViewController *oldVc = vc; /// for error
    if (input.options.preparation) {
        __weak typeof(input) winput = input;
        vc = input.options.preparation(sourceViewController, vc, winput);
    }
    if (!vc) {
        if (completion) {
            completion([NDURLResult errorResultWithInput:input messsage:[NSString stringWithFormat:@"preparation cancelled: %@", oldVc]]);
        }
        return;
    }
    
    [self openViewController:vc withInput:input completion:completion];
}

#pragma mark - protected

- (void)setViewProperty:(id)object forKey:(NSString *)key
{
    NSMutableDictionary *params = nil;
    if ([self.viewProperties isKindOfClass:[NSMutableDictionary class]]) {
        params = (NSMutableDictionary *)self.viewProperties;
    } else {
        params = [NSMutableDictionary dictionary];
        if (self.viewProperties.count > 0) {
            [params addEntriesFromDictionary:self.viewProperties];
        }
    }
    if (object) {
        params[key] = object;
    } else {
        [params removeObjectForKey:key];
    }
    self.viewProperties = params;
}

- (void)setOwner:(id)owner
{
    if (_owner != owner) {
        if (_owner) {
            objc_setAssociatedObject(_owner, &NDURLHandlerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        _owner = owner;
        if (_owner) {
            objc_setAssociatedObject(_owner, &NDURLHandlerKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)openViewController:(UIViewController *)vc withInput:(NDURLInput *)input completion:(void (^)(NDURLResult *))completion
{
    UIViewController *sourceViewController = input.options.sourceViewController;
    
    if (!vc) {
        if (completion) {
            completion([NDURLResult errorResultWithInput:input messsage:[NSString stringWithFormat:@"destination viewController null!"]]);
        }
        return;
    }
    
    NSString *action = input.options.action ?: self.action;
    if (action == nil) {
        action = NDURLOpenActionPush;
    }
    BOOL animated = input.options ? input.options.animated : YES;
    
    if ([action isEqualToString:NDURLOpenActionPush]) {
        UINavigationController *nav = nil;
        
        // check if tabbar
        if ([sourceViewController isKindOfClass:[UITabBarController class]]) {
            nav = (UINavigationController *)[(UITabBarController *)sourceViewController selectedViewController];
        }
        
        // check normal source
        if (!nav) {
            nav = [sourceViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)sourceViewController : sourceViewController.navigationController;
        }
        
        // check root
        if (!nav) {
            UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if ([tab isKindOfClass:[UINavigationController class]]) {
                tab = [(UINavigationController *)tab viewControllers].firstObject;
            }
            if ([tab isKindOfClass:[UITabBarController class]]) {
                nav = [tab.selectedViewController isKindOfClass:[UINavigationController class]] ? tab.selectedViewController : nil;
            }
        }
        
        NSError *error = nil;
        if (nav) {
            [nav pushViewController:vc animated:animated];
        } else {
            error = [NSError errorWithDomain:NDURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Can't find navigation controller"}];
        }
        
        if (completion) {
            completion([NDURLResult resultWithInput:input source:sourceViewController ?: nav destination:vc error:error]);
        }
    } else if ([action isEqualToString:NDURLOpenActionPresent]) {
        UIViewController *presentingViewController = sourceViewController ?: [UIApplication sharedApplication].delegate.window.rootViewController;
        if (![vc isKindOfClass:[UINavigationController class]] && ![vc isKindOfClass:[UITabBarController class]]) {
            vc = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        [presentingViewController presentViewController:vc animated:animated completion:^{
            if (completion) {
                completion([NDURLResult resultWithInput:input source:presentingViewController destination:vc error:nil]);
            }
        }];
    } else {
        if (completion) {
            completion([NDURLResult errorResultWithInput:input messsage:[NSString stringWithFormat:@"Unsupported action: %@", action]]);
        }
    }
}

- (void)dealloc
{
    NSLog(@"handler dealloc: %@, %@", self, self.url);
}

@end
