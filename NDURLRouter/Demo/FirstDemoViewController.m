//
//  FirstDemoViewController.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/9.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "FirstDemoViewController.h"

@interface FirstDemoViewController ()

@end

@implementation FirstDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
