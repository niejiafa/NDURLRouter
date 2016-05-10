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
    if (0 == indexPath.row)
    {
        cell.textLabel.text = @"First";
    }
    else
    {
        cell.textLabel.text = @"Second";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        [self openURL:@"nd://jincieryi.com.cn/normaldemofirstvc"];
    }
    else
    {
        [self openURL:@"nd://jincieryi.com.cn/normaldemosecondvc"];
    }
}

@end
