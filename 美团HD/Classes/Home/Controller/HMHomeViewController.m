//
//  HMHomeViewController.m
//  美团HD
//
//  Created by apple on 20/6/10.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMHomeTopItem.h"
#import "HMCategoryViewController.h"
#import "HMDistrictViewController.h"
#import "HMSortViewController.h"
#import "HMSort.h"
#import "HMCategory.h"
#import "HMCity.h"
#import "HMDistrict.h"
#import "DPAPI.h"
#import "HMFineDealResult.h"
#import <MJExtension.h>
#import "HMCollectionViewCell.h"

@interface HMHomeViewController ()
/** 分类item */
@property(nonatomic, weak) UIBarButtonItem *categoryItem;
/** 区域item */
@property(nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序item */
@property(nonatomic, weak) UIBarButtonItem *sortItem;

/** 存放所有的团购 */
@property (nonatomic, strong) NSMutableArray *deals;

// 记录一些当前数据
/** 当前城市 */
@property (nonatomic, strong) HMCity *currentCity;
// 当前的类别名称 (发给服务器)
@property (nonatomic, copy) NSString *currentCategoryName;
// 当前的区域名称 (发给服务器)
@property (nonatomic, copy) NSString *currentDistrictName;
/** 当前排序模型 */
@property (nonatomic, strong) HMSort *currentSort;

@end

@implementation HMHomeViewController

#pragma mark - 懒加载
- (NSMutableArray *)deals
{
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

static NSString * const reuseIdentifier = @"deal";

#pragma mark - 监听屏幕的旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(305, 305);
    
    CGFloat screenW = size.width;
    // 根据屏幕尺寸决定每行的列数
    int cols = (screenW == HMScreenMaxWH) ? 3 : 2;
    // 一行之中所有cell的中宽度
    CGFloat allCellW = cols * layout.itemSize.width;
    // cell之间的间距
    CGFloat xMargin = (screenW - allCellW) / (cols + 1);
    CGFloat yMargin = (cols == 3) ? xMargin : 30;
    
    
    // 周边的间距
    layout.sectionInset = UIEdgeInsetsMake(yMargin, xMargin, yMargin, xMargin);
    // 每一行中每个cell之间的间距
    layout.minimumInteritemSpacing = xMargin;
    // 每一行之间的间距
    layout.minimumLineSpacing = yMargin;
}

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册xib中使用的自定义cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 根据当前屏幕尺寸,计算布局参数 (比如说间距)
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self viewWillTransitionToSize:screenSize withTransitionCoordinator:nil];
    
    
    self.collectionView.backgroundColor = HMRGBColor(224, 224, 224);
    
    // self.view  == self.tableView
    // self.view  ==  self.collectionView.superview
    
    // 设置导航栏左边
    [self setupNavLeft];
    
    // 设置导航栏右边
    [self setupNavRight];
    
    // 监听通知
    [self setupNotes];
}

/**
 *  监听通知
 */
- (void)setupNotes
{
    [HMNoteCenter addObserver:self selector:@selector(sortDidChange:) name:HMSortDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(categoryDidChange:) name:HMCategoryDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(cityDidChange:) name:HMCityDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(districtDidChange:) name:HMDistrictDidChangeNotification object:nil];
}

- (void)dealloc
{
    [HMNoteCenter removeObserver:self];
}

/**
 *  设置导航栏左边
 */
- (void)setupNavLeft
{
    // logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 类别
    HMHomeTopItem *categoryTopItem = [HMHomeTopItem item];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    categoryTopItem.title = @"全部分类";
    categoryTopItem.subtitle = nil;
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    
    // 区域
    HMHomeTopItem *districtTopItem = [HMHomeTopItem item];
    [districtTopItem setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    districtTopItem.title = @"北京";
    districtTopItem.subtitle = @"海淀区";
    [districtTopItem addTarget:self action:@selector(districtClick)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    // 排序
    HMHomeTopItem *sortTopItem = [HMHomeTopItem item];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    sortTopItem.title = @"排序";
    sortTopItem.subtitle = @"默认排序";
    [sortTopItem addTarget:self action:@selector(sortClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}

/**
 *  设置导航栏右边
 */
- (void)setupNavRight
{
    // search
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" highImage:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    searchItem.customView.width = 50;
    
    // map
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" highImage:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 通知处理
- (void)sortDidChange:(NSNotification *)note
{
    // 更新导航栏顶部排序的子标题
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.sortItem.customView;
    self.currentSort = note.userInfo[HMCurrentSortKey];
    topItem.subtitle = self.currentSort.label;
    
    // 重新发送请求给服务器
    [self loadNewDeals];
}

- (void)categoryDidChange:(NSNotification *)note
{
    // 更新导航栏顶部类别菜单的内容
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.categoryItem.customView;
    // 取出模型
    HMCategory *category = note.userInfo[HMCurrentCategoryKey];
    int subcategoryIndex = [note.userInfo[HMCurrentSubcategoryIndexKey] intValue];
    NSString *subcategory = category.subcategories[subcategoryIndex];
    // 设置数据
    topItem.title = category.name;
    topItem.subtitle = subcategory;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    
    // 发送给服务器的分类名称
    self.currentCategoryName = category.subcategories ? subcategory : category.name;
    if ([self.currentCategoryName isEqualToString:@"全部"]) {
        self.currentCategoryName = category.name;
    } else if ([self.currentCategoryName isEqualToString:@"全部分类"]) {
        self.currentCategoryName = nil;
    }
    
    // 重新发送请求给服务器
    [self loadNewDeals];
}

- (void)cityDidChange:(NSNotification *)note
{
    // 更新导航栏顶部类别菜单的内容
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.districtItem.customView;
    // 取出模型
    self.currentCity = note.userInfo[HMCurrentCityKey];
    topItem.title = self.currentCity.name;
    topItem.subtitle = nil;
    
    // 重新发送请求给服务器
    [self loadNewDeals];
}

- (void)districtDidChange:(NSNotification *)note
{
    // 更新导航栏顶部类别菜单的内容
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.districtItem.customView;
    // 取出模型
    HMDistrict *district = note.userInfo[HMCurrentDistrictKey];
    int subdistrictIndex = [note.userInfo[HMCurrentSubdistrictIndexKey] intValue];
    NSString *subdistrict = district.subdistricts[subdistrictIndex];
    // 设置数据
    topItem.title = [NSString stringWithFormat:@"%@ | %@",self.currentCity.name, district.name];
    topItem.subtitle = subdistrict;
    
    // 发送给服务器的区域名称
    self.currentDistrictName = district.subdistricts ? subdistrict : district.name;
    if ([self.currentDistrictName isEqualToString:@"全部"]) {
        self.currentDistrictName = subdistrict ? district.name : nil;
    }
    
    // 重新发送请求给服务器
    [self loadNewDeals];
}

#pragma mark - 导航栏事件处理
/**
 *  点击了分类
 */
- (void)categoryClick
{
    HMCategoryViewController *categoryVc = [[HMCategoryViewController alloc] init];
    categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    [self presentViewController:categoryVc animated:YES completion:nil];
}
/**
 *  点击了区域
 */
- (void)districtClick
{
    HMDistrictViewController *districtVc = [[HMDistrictViewController alloc] init];
    districtVc.modalPresentationStyle = UIModalPresentationPopover;
    districtVc.popoverPresentationController.barButtonItem = self.districtItem;
    districtVc.districts = self.currentCity.districts;
    [self presentViewController:districtVc animated:YES completion:nil];
}
/**
 *  点击了排序
 */
- (void)sortClick
{
    HMSortViewController *sortVc = [[HMSortViewController alloc] init];
    sortVc.modalPresentationStyle = UIModalPresentationPopover;
    sortVc.popoverPresentationController.barButtonItem = self.sortItem;
    [self presentViewController:sortVc animated:YES completion:nil];
}
/**
 *  点击了搜索按钮
 */
- (void)searchClick
{
    HMLog(@"searchClick");
}

/**
 *  点击了地图按钮
 */
- (void)mapClick
{
    HMLog(@"mapClick");
}

#pragma mark - 私有方法
- (void)loadNewDeals
{
    if (self.currentCity == nil) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentDistrictName) params[@"region"] = self.currentDistrictName;
    // 分类
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    // 发送请求给服务器
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        HMFineDealResult *result = [HMFineDealResult objectWithKeyValues:json];
        
        // 移除旧数据
        [self.deals removeAllObjects];
        
        // 添加新数据
        [self.deals addObjectsFromArray:result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        HMLog(@"error - %@",error);
    }];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
