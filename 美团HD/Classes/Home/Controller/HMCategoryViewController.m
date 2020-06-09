//
//  HMCategoryViewController.m
//  美团HD
//
//  Created by apple on 20/6/14.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMCategoryViewController.h"

@interface HMCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation HMCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMRandomColor;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return 20;
    } else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView == self.leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"左边cell -- %zd",indexPath.row];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"右边cell -- %zd",indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        HMLog(@"点击了左边第%zd行",indexPath.row);
    } else {
        HMLog(@"点击了右边第%zd行",indexPath.row);
    }
}


@end