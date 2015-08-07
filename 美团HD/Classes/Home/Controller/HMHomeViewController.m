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
#import <MJRefresh.h>
#import "MBProgressHUD+HMExtension.h"
#import "HMCollectionViewCell.h"
#import <PureLayout.h>
#import "HMDetailViewController.h"
#import "HMDataTool.h"
#import "AwesomeMenu.h"
#import "HMCollectViewController.h"
#import "HMNavigationController.h"

@interface HMHomeViewController () <AwesomeMenuDelegate>
/** 分类item */
@property(nonatomic, weak) UIBarButtonItem *categoryItem;
/** 区域item */
@property(nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序item */
@property(nonatomic, weak) UIBarButtonItem *sortItem;

/** 存放所有的团购 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 没有团购数据时显示的提醒图片 */
@property(nonatomic, weak) UIImageView *noDataView;

// 记录一些当前数据
/** 返回结果 */
@property (nonatomic, strong) HMFineDealResult *result;
/** 当前页码 */
@property (nonatomic, assign) int currentPage;
/** 当前城市 */
@property (nonatomic, strong) HMCity *currentCity;
// 当前的类别名称 (发给服务器)
@property (nonatomic, copy) NSString *currentCategoryName;
// 当前的区域名称 (发给服务器)
@property (nonatomic, copy) NSString *currentDistrictName;
/** 当前排序模型 */
@property (nonatomic, strong) HMSort *currentSort;
/** 当前正在发送的网络请求 */
@property (nonatomic, strong) DPRequest *currentRequest;

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

- (UIImageView *)noDataView
{
    if (_noDataView == nil) {
        UIImageView *noDataView = [[UIImageView alloc] init];
        noDataView.image = [UIImage imageNamed:@"icon_deals_empty"];
        noDataView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDataView];
        
        // 约束
        [noDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // 赋值
        self.noDataView = noDataView;
    }
    return _noDataView;
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
    
//    self.collectionView.alwaysBounceVertical = YES;
    
    // 注册xib中使用的自定义cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = HMRGBColor(224, 224, 224);
    
    // self.view  == self.tableView
    // self.view  ==  self.collectionView.superview
    
    // 设置导航栏左边
    [self setupNavLeft];
    
    // 设置导航栏右边
    [self setupNavRight];
    
    // 监听通知
    [self setupNotes];
    
    // 增加一个刷新功能
    [self setupRefresh];
    
    // 添加环形菜单
    [self setupAwesomeMenu];
}

/**
 *  环形菜单
 */
- (void)setupAwesomeMenu
{
    // 所有item的公共背景
    UIImage *itemBg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    
    // 创建菜单item (按钮)
    // 1. 个人信息
    AwesomeMenuItem *personalItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    // 2. 收藏
    AwesomeMenuItem *collectItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    // 3. 历史记录
    AwesomeMenuItem *historyItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    // 4. 更多
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    // 5. 开始按钮
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    // 创建菜单
    NSArray *items = @[personalItem, collectItem, historyItem, moreItem];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    menu.delegate = self;
    menu.alpha = 0.5;
    [self.view addSubview:menu];
    
    // 设置菜单约束
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    CGFloat menuWH = 250;
    [menu autoSetDimensionsToSize:CGSizeMake(menuWH, menuWH)];
    
    // 设置菜单信息
    menu.menuWholeAngle = M_PI_2;
    CGFloat margin = 50;
    menu.startPoint = CGPointMake(margin, menuWH - margin);
    menu.rotateAddButton = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 根据当前屏幕尺寸,计算布局参数 (比如说间距)
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self viewWillTransitionToSize:screenSize withTransitionCoordinator:nil];
}

/**
 *  刷新功能
 */
- (void)setupRefresh
{
    // 上拉加载更多 - 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    
    // 下拉刷新 - 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    self.collectionView.footer.hidden = YES;
    
#warning TODO
    self.currentCity = [HMDataTool cityWithName:@"北京"];
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
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
    
    // 清除正在发送的请求
    [self.currentRequest disconnect];
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

#pragma mark - <AwesomeMenuDelegate>

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0: // 个人
            HMLog(@"个人");
            break;
        case 1: { // 收藏
            HMCollectViewController *collectVc = [[HMCollectViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:collectVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2: // 历史
            HMLog(@"历史");
            break;
        case 3: // 更多
            HMLog(@"更多");
            break;
            
        default:
            break;
    }
    
    [self awesomeMenuDidFinishAnimationClose:menu];
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu;
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}

- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    
}

#pragma mark - 通知处理
- (void)sortDidChange:(NSNotification *)note
{
    // 更新导航栏顶部排序的子标题
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.sortItem.customView;
    self.currentSort = note.userInfo[HMCurrentSortKey];
    topItem.subtitle = self.currentSort.label;
    
    // 重新发送请求给服务器
//    [self loadNewDeals];
    
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
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
//    [self loadNewDeals];
    
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
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
//    [self loadNewDeals];
    
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
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
//    [self loadNewDeals];
    
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
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
    
    //  取消上一个请求
    [self.currentRequest disconnect];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentDistrictName) params[@"region"] = self.currentDistrictName;
    // 分类
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    // 页码
//    params[@"page"] = @(1);
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFineDealResult objectWithKeyValues:json];
        
        // 移除旧数据
        [self.deals removeAllObjects];
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 停止刷新状态
        [self.collectionView.header endRefreshing];
        
        self.currentPage = 1;
        
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 停止刷新状态
        [self.collectionView.header endRefreshing];
    }];
}

- (void)loadMoreDeals
{
    
    if (self.currentCity == nil) return;
    
    //  取消上一个请求
    [self.currentRequest disconnect];
    // 停止刷新状态
    [self.collectionView.header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    int tempPage = self.currentPage;
    tempPage ++;
    
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentDistrictName) params[@"region"] = self.currentDistrictName;
    // 分类
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    // 页码
    params[@"page"] = @(tempPage);
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFineDealResult objectWithKeyValues:json];
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 调用初始化refresh 方法
        [self setupRefresh];
        
        // 修改页码
        self.currentPage = tempPage;
        
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        
        // 调用初始化refresh 方法
        [self setupRefresh];

    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    self.noDataView.hidden = (count > 0);
    self.collectionView.footer.hidden = (self.deals.count == self.result.total_count);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDetailViewController *detailVc = [[HMDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
