//
//  SecondDemoViewController.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/10.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "SecondDemoViewController.h"

@interface SecondDemoViewController ()

@end

@implementation SecondDemoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 64, 100, 100);
    [self.view addSubview:backButton];
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(backHomePage) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - event response

- (void)backHomePage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
