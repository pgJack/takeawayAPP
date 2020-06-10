//
//  HMDropDownRightCell.m
//  美团HD
//
//  Created by apple on 20/6/10.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMDropDownRightCell.h"

@implementation HMDropDownRightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *rightId = @"right";
    HMDropDownRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightId];
    if (cell == nil) {
        cell = [[HMDropDownRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightId];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    return cell;
}

@end
