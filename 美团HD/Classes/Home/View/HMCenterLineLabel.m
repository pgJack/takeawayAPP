//
//  HMCenterLineLabel.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMCenterLineLabel.h"

@implementation HMCenterLineLabel


- (void)drawRect:(CGRect)rect {
    
    // 调用super的目的, 保留之前绘制的文字
    [super drawRect:rect];
    
    CGFloat x = 0 + rect.origin.x;
    CGFloat y = rect.size.height * 0.5 + rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = 1;
    UIRectFill(CGRectMake(x, y, w, h));
}

- (void)drawLine:(CGRect)rect
{
    HMLog(@"%@",NSStringFromCGRect(rect));
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 起点
    CGFloat startX = 0 + rect.origin.x;
    CGFloat startY = rect.size.height * 0.5 + rect.origin.y;
    CGContextMoveToPoint(ctx, startX, startY);
    
    // 终点
    CGFloat endX = rect.size.width + rect.origin.x;
    CGFloat endY = startY;
    CGContextAddLineToPoint(ctx, endX, endY);
    
    // 绘图渲染
    CGContextStrokePath(ctx);
}

@end
