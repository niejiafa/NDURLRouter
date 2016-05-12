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
        ///默认都是 push 方式，可以设置为 present 方式，方法有很多中，具体参考NDURLOpenOptions，下面这种是拼接到 url 中
        [self openURL:@"nd://jincieryi.com.cn/normaldemosecondvc?action=present"];
    }
}

@end
