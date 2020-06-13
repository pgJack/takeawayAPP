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

@interface HMHomeViewController ()

@end

@implementation HMHomeViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = HMRGBColor(224, 224, 224);
    
    // self.view  == self.tableView
    // self.view  ==  self.collectionView.superview
    
    // 设置导航栏左边
    [self setupNavLeft];
    
    // 设置导航栏右边
    [self setupNavRight];
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
    [categoryTopItem.iconButton setImage:[UIImage imageNamed:@"icon_category_-1"] forState:UIControlStateNormal];
    [categoryTopItem.iconButton setImage:[UIImage imageNamed:@"icon_category_highlighted_-1"] forState:UIControlStateHighlighted];
    categoryTopItem.titleLabel.text = @"全部分类";
    categoryTopItem.subtitleLabel.text = nil;
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    
    
    // 区域
    HMHomeTopItem *districtTopItem = [HMHomeTopItem item];
    [districtTopItem.iconButton setImage:[UIImage imageNamed:@"icon_district"] forState:UIControlStateNormal];
    [districtTopItem.iconButton setImage:[UIImage imageNamed:@"icon_district_highlighted"] forState:UIControlStateHighlighted];
    districtTopItem.titleLabel.text = @"北京";
    districtTopItem.subtitleLabel.text = @"海淀区";
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    
    // 排序
    HMHomeTopItem *sortTopItem = [HMHomeTopItem item];
    [sortTopItem.iconButton setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    [sortTopItem.iconButton setImage:[UIImage imageNamed:@"icon_sort_highlighted"] forState:UIControlStateHighlighted];
    sortTopItem.titleLabel.text = @"排序";
    sortTopItem.subtitleLabel.text = @"默认排序";
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
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
