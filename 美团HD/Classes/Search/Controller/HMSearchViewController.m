//
//  HMSearchViewController.m
//  美团HD
//
//  Created by apple on 20/6/10.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//

#import "HMSearchViewController.h"
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
#import "HMHistoryViewController.h"

@interface HMSearchViewController () <UISearchBarDelegate>

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
/** 当前正在发送的网络请求 */
@property (nonatomic, strong) DPRequest *currentRequest;

/** 记录搜索框文字 */
@property(nonatomic, weak) UISearchBar *searchBar;

@end

@implementation HMSearchViewController

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
    
    // 注册xib中使用的自定义cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = HMRGBColor(224, 224, 224);
    
    // 设置导航栏
    [self setupNav];
    
    // 增加一个刷新功能
    [self setupRefresh];
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
    self.collectionView.footer.hidden = YES;
}

- (void)dealloc
{
    // 清除正在发送的请求
    [self.currentRequest disconnect];
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 添加遮盖
    [MBProgressHUD showMessage:@"正在拼命搜索团购..."];
    self.currentPage = 0;
    [self loadMoreDeals];
}

#pragma mark - 设置导航栏

- (void)setupNav
{
    // 1. 返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 2. 搜索框 (UISearchBar 需要包装, 进行特殊处理)
    UIView *titleView = [[UIView alloc] init];
    titleView.width = 250;
    titleView.height = 35;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = titleView.bounds;
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法

- (void)loadMoreDeals
{
    //  取消上一个请求
    [self.currentRequest disconnect];
    // 停止刷新状态
    [self.collectionView.header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    int tempPage = self.currentPage;
    tempPage ++;
    
    // 城市
    params[@"city"] = self.cityName;
    // 页码
    params[@"page"] = @(tempPage);
    // 搜索条件
    params[@"keyword"] = self.searchBar.text;
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFineDealResult objectWithKeyValues:json];
        
        // 如果是第一页的数据,清除掉以前的旧数据
        if (tempPage == 1) {
            [self.deals removeAllObjects];
        }
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 调用初始化refresh 方法
        [self setupRefresh];
        
        // 修改页码
        self.currentPage = tempPage;
        
        // 让表格滚动到最前面
        if (tempPage == 1 && self.deals.count) {
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            [self.collectionView setContentOffset:CGPointZero animated:YES];
        }
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
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
