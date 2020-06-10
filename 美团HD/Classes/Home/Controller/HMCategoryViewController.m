//
//  HMCategoryViewController.m
//  美团HD
//
//  Created by apple on 20/6/14.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMCategoryViewController.h"
#import "HMDataTool.h"
#import "HMCategory.h"
#import "HMDropDownLeftCell.h"
#import "HMDropDownRightCell.h"

@interface HMCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation HMCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, rowHeight * [HMDataTool categories].count);
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) { // 左边
        return [HMDataTool categories].count;
    } else { // 右边
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMCategory *category = [HMDataTool categories][leftSelectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) { // 左边
        cell = [HMDropDownLeftCell cellWithTableView:tableView];
    
        HMCategory *category = [HMDataTool categories][indexPath.row];
        cell.textLabel.text = category.name;
        cell.accessoryType = category.subcategories ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
        
    } else { // 右边
        cell = [HMDropDownRightCell cellWithTableView:tableView];
        
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMCategory *category = [HMDataTool categories][leftSelectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) { // 左边
        // 刷新右边
        [self.rightTableView reloadData];
    } else { // 右边
        HMLog(@"点击了右边第%zd行",indexPath.row);
    }
}


@end