//
//  HMSortViewController.m
//  美团HD
//
//  Created by apple on 20/6/14.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//

#import "HMSortViewController.h"
#import "HMSort.h"
#import "HMDataTool.h"

@interface HMSortViewController ()
@end

@implementation HMSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 根据plist数组创建对应个数的排序按钮
    NSArray *sorts = [HMDataTool sorts];
    NSUInteger count = sorts.count;
    CGFloat margin = 10;
    UIButton *lastButton = nil;
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [self.view addSubview:button];
        lastButton = button;
        
        // 取出模型
        HMSort *sort = sorts[i];
        // 设置按钮的文字
        [button setTitle:sort.label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        // 设置按钮的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置frame
        button.width = 100;
        button.height = 30;
        button.x = 10;
        button.y = margin + i * (button.height + margin);
    }
    // 设置控制器view在popover中的尺寸
    CGFloat w = CGRectGetMaxX(lastButton.frame) + lastButton.x;
    CGFloat h = CGRectGetMaxY(lastButton.frame) + margin;
    self.preferredContentSize = CGSizeMake(w, h);
}

- (void)buttonClick:(UIButton *)button
{
    // 1. 让popover消失
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2. 发出通知
    NSDictionary *userInfo = @{HMCurrentSortKey : [HMDataTool sorts][button.tag]};
    [HMNoteCenter postNotificationName:HMSortDidChangeNotification object:nil userInfo:userInfo];
    
}

@end
