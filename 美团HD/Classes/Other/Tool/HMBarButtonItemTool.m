//
//  HMBarButtonItemTool.m
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMBarButtonItemTool.h"

@implementation HMBarButtonItemTool

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
