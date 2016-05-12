//
//  TabbarViewController.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/10.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "TabbarViewController.h"

#import "ThirdViewController.h"
#import "UIViewController+NDURLRouter.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nd_createViewControllers];
    [self nd_createItems];
}

#pragma mark - private

- (void)nd_createItems
{
    NSArray*titleArray = @[@"First",@"Second",@"Third"];
    
    for (int i=0; i<self.tabBar.items.count; i++)
    {
        UITabBarItem*item = self.tabBar.items[i];
        
        item = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:nil selectedImage:nil];
    }
}

- (void)nd_createViewControllers
{
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.title = @"First";
    UIButton *ThirdVCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ThirdVCButton.frame = CGRectMake(0, 64, 100, 100);
    [vc1.view addSubview:ThirdVCButton];
    [ThirdVCButton setTitle:@"跳到第三个" forState:UIControlStateNormal];
    [ThirdVCButton setBackgroundColor:[UIColor blackColor]];
    [ThirdVCButton addTarget:self action:@selector(jumpToThirdVC) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.title = @"Second";
    UINavigationController *nc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    ThirdViewController *vc3 = [[ThirdViewController alloc]init];
    vc3.view.backgroundColor = [UIColor whiteColor];
    vc3.title = @"Third";
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    self.viewControllers = @[nc1,nc2,nc3];
}

#pragma mark - event response

- (void)jumpToThirdVC
{
    [self openURL:@"nd://jincieryi.com.cn/tabbardemothirdvc?tab=2"];
}

- (void)backHomePage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter

@end
