//
//  HMCityViewController.m
//  美团HD
//
//  Created by apple on 20/6/12.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDataTool.h"
#import "HMCityGroup.h"

@interface HMCityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HMCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
//    self.tabBarItem.title = ;
//    self.navigationItem.title = ;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HMDataTool cityGroups].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HMCityGroup *cityGroup = [HMDataTool cityGroups][section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置城市名称
    HMCityGroup *cityGroup = [HMDataTool cityGroups][indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *titles = [NSMutableArray array];
//    [[HMDataTool cityGroups] enumerateObjectsUsingBlock:^(HMCityGroup *group, NSUInteger idx, BOOL *stop) {
//        [titles addObject:group.title];
//    }];
//    return titles;
    
//    NSArray *groups = [HMDataTool cityGroups];
//    HMCityGroup *group = [groups lastObject];
//    
//    HMLog(@"%@",[group valueForKeyPath:@"title"]); // 相当于group.title
//    // 将groups数组中所有元素的title属性取出来,放到一个新的数组中
//    HMLog(@"%@",[groups valueForKeyPath:@"title"]);
    
    return [[HMDataTool cityGroups] valueForKeyPath:@"title"];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HMCityGroup *cityGroup = [HMDataTool cityGroups][section];
    return cityGroup.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
