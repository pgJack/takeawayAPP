//
//  HMNavigationController.m
//  美团HD
//
//  Created by apple on 20/6/11.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMNavigationController.h"

@interface HMNavigationController ()

@end

@implementation HMNavigationController

+ (void)initialize
{
    // 设置导航栏的主题
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏上面item的文字属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 普通文字的颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = HMRGBColor(17, 177, 157);
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    // 不可交互的文字颜色
    NSMutableDictionary *disabelAttrs = [NSMutableDictionary dictionary];
    disabelAttrs[NSForegroundColorAttributeName] = HMRGBColor(100, 100, 100);
    [item setTitleTextAttributes:disabelAttrs forState:UIControlStateDisabled];
}

//- (instancetype)init
//{
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
