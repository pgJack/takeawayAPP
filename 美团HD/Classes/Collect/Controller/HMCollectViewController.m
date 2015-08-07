//
//  HMCollectViewController.m
//  美团HD
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMCollectViewController.h"
#import <PureLayout.h>
#import "HMDetailViewController.h"
#import "HMCollectionViewCell.h"
#import "HMDealTool.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDeal.h"

static NSString * const HMEdit = @"编辑";
static NSString * const HMDone = @"完成";

#define HMNavLeftText(text) [NSString stringWithFormat:@"  %@  ",text]

@interface HMCollectViewController ()

/** 存放所有的团购 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 没有团购数据时显示的提醒图片 */
@property(nonatomic, weak) UIImageView *noDataView;

/** 记录导航栏左边所有的item */
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *deselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

@end

@implementation HMCollectViewController

static NSString * const reuseIdentifier = @"deal";

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
        noDataView.image = [UIImage imageNamed:@"icon_collects_empty"];
        noDataView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDataView];
        
        // 约束
        [noDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // 赋值
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (_selectAllItem == nil) {
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"全选") style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)deselectAllItem
{
    if (_deselectAllItem == nil) {
        _deselectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"全不选") style:UIBarButtonItemStylePlain target:self action:@selector(deselectAllItemClick)];
    }
    return _deselectAllItem;
}

- (UIBarButtonItem *)deleteItem
{
    if (_deleteItem == nil) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"删除") style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick)];
    }
    return _deleteItem;
}

#pragma mark - 初始化

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 移除数据
    [self.deals removeAllObjects];
    // 添加数据
    [self.deals addObjectsFromArray:[HMDealTool collectedDeals]];
    // 刷新数据
    [self.collectionView reloadData];
    
    // 判断编辑按钮是否允许点击
    UIBarButtonItem *editItem = self.navigationItem.rightBarButtonItem;
    editItem.enabled = (self.deals.count > 0);
    
    // 根据当前屏幕尺寸,计算布局参数 (比如说间距)
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self viewWillTransitionToSize:screenSize withTransitionCoordinator:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册xib中使用的自定义cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = HMRGBColor(224, 224, 224);
    
    // 设置导航栏内容
    [self setupNav];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.title = @"我的收藏";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HMEdit style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    
}

#pragma mark - 监听点击方法

- (void)edit
{
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    if ([title isEqualToString:HMEdit]) { // 进入编辑状态
        self.navigationItem.rightBarButtonItem.title = HMDone;
        
        // 控制左边的 (全选 全不选 删除) 出现
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.deselectAllItem, self.deleteItem];
        
    } else { // 结束编辑状态
        self.navigationItem.rightBarButtonItem.title = HMEdit;
        
        // 控制左边的 (全选 全不选 删除) 消失
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAllItemClick
{
    
}

- (void)deselectAllItemClick
{
    
}

- (void)deleteItemClick
{
    
}

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

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    self.noDataView.hidden = (count > 0);
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
