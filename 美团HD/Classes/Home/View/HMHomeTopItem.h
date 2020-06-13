//
//  HMHomeTopItem.h
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomeTopItem : UIView
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 子标题 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/** 图标按钮 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
+ (instancetype)item;

@end
