//
//  InterceptorViewController.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/12.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "InterceptorViewController.h"

#import "UIViewController+NDURLRouter.h"

@interface InterceptorViewController ()

@end

@implementation InterceptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(id)sender
{
    [self openURL:@"nd://jincieryi.com.cn/interceptordemovc"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
