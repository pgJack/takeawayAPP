//
//  HMCityResultViewController.m
//  美团HD
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMCityResultViewController.h"
#import "HMDataTool.h"
#import "HMCity.h"

@interface HMCityResultViewController ()
/** 里面装的都是符合条件的城市模型 */
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation HMCityResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    if (searchText.length == 0) return;
    _searchText = [searchText copy];
    
    // 将搜索条件的字符串转换成小写
    searchText = searchText.lowercaseString;
    
    // 根据搜索条件 - 搜索城市 (谓词 - 过滤器)
    NSArray *cities = [HMDataTool cities];
    
    // 创建过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText, searchText, searchText];
    self.resultCities = [cities filteredArrayUsingPredicate:predicate];
    
    
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置城市名称
    HMCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"一共有%zd个搜索结果",self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
