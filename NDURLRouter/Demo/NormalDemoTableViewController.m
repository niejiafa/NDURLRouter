//
//  NormalDemoTableViewController.m
//  NDURLRouter
//
//  Created by NDMAC on 16/5/9.
//  Copyright © 2016年 NDEducation. All rights reserved.
//

#import "NormalDemoTableViewController.h"

#import "UIViewController+NDURLRouter.h"

@interface NormalDemoTableViewController ()

@end

@implementation NormalDemoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"First";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openURL:@"nd://jincieryi.com.cn/test"];
}

@end
