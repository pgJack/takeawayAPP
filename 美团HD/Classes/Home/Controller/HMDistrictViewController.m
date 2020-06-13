//
//  HMDistrictViewController.m
//  美团HD
//
//  Created by apple on 20/6/14.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMDistrictViewController.h"
#import "HMCityViewController.h"
#import "HMNavigationController.h"

@interface HMDistrictViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation HMDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, 600);
}
#pragma mark - 私有方法
/**
 *  切换城市
 */
- (IBAction)changeCity {
    // 1. 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2. 弹出切换城市控制器
    HMCityViewController *cityVc = [[HMCityViewController alloc] init];
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:cityVc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end