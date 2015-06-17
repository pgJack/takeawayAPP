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
@property (nonatomic, strong) NSMutableArray *resultNames;
@end

@implementation HMCityResultViewController

- (NSMutableArray *)resultNames
{
    if (_resultNames == nil) {
        _resultNames = [NSMutableArray array];
    }
    return _resultNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    if (searchText.length == 0) return;
    _searchText = [searchText copy];
    
    // 清除就数据
    [self.resultNames removeAllObjects];
    
    // 将搜索条件的字符串转换成小写
    searchText = searchText.lowercaseString;
    
    // 根据搜索条件 - 搜索城市
    NSArray *cities = [HMDataTool cities];
    for (HMCity *city in cities) {
        if ([city.name containsString:searchText]) { //名字中包含了搜索条件 广州
            [self.resultNames addObject:city.name];
        } else if ([city.pinYin containsString:searchText]) { //拼音中包含了搜索条件
            [self.resultNames addObject:city.name];
        } else if ([city.pinYinHead containsString:searchText]) { //拼音声母中包含了搜索条件
            [self.resultNames addObject:city.name];
        }
    }
    
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置城市名称
    cell.textLabel.text = self.resultNames[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"一共有%zd个搜索结果",self.resultNames.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
