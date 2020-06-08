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
#import "HMCityResultViewController.h"
#import <PureLayout.h>

@interface HMCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 蒙版遮盖 */
@property(nonatomic, weak) IBOutlet UIButton *cover;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/** 城市搜索结果控制器 */
@property (nonatomic, strong) HMCityResultViewController *cityResultVc;
@end

@implementation HMCityViewController

#pragma mark - 懒加载
- (HMCityResultViewController *)cityResultVc
{
    if (_cityResultVc == nil) {
        _cityResultVc = [[HMCityResultViewController alloc] init];
        [self addChildViewController:_cityResultVc];
        [self.view addSubview:_cityResultVc.view];
        
        // 添加约束
        [_cityResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_cityResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
    }
    return _cityResultVc;
}


#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 监听蒙版的点击
    [self.cover addTarget:self.searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UISearchBarDelegate>
/**
 *  当搜索框已经进入编辑状态 - 键盘已经弹出
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1. 让搜索框背景变成绿色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
    // 2. 出现cancel按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 3. 导航条消失 (通过动画向上消失)
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 4. 添加蒙版
    self.cover.hidden = NO;
}

/**
 *  当搜索框已经推出编辑状态 - 键盘已经退下
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1. 让搜索框背景变成灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    // 2. 隐藏cancel按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 3. 导航条出现 (通过动画向下出现)
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 4. 隐藏蒙版
    self.cover.hidden = YES;
    
    // 5. 清空搜索框文字
    searchBar.text = nil;
    
    // 6. 隐藏搜索结果控制器
    self.cityResultVc.view.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [searchBar resignFirstResponder];
    [searchBar endEditing:YES];
}

/**
 *  搜索框文字发生改变
 *
 *  @param searchText 搜索框当前的文字 - (搜索条件)
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if (searchText.length) {
//        self.cityResultVc.view.hidden = NO;
//    } else {
//        self.cityResultVc.view.hidden = YES;
//    }
//    self.cityResultVc.view.hidden = !searchText.length;
    self.cityResultVc.view.hidden = (searchText.length == 0);
    self.cityResultVc.searchText = searchText;
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
    // 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 取出城市的名字
    HMCityGroup *cityGroup = [HMDataTool cityGroups][indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    
    // 根据城市的名字获得城市模型
    HMCity *city = [HMDataTool cityWithName:cityName];
    
    // 发送通知
    NSDictionary *userInfo = @{HMCurrentCityKey : city};
    [HMNoteCenter postNotificationName:HMCityDidChangeNotification object:nil userInfo:userInfo];
    
    
}

@end
