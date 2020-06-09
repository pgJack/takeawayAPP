//
//  ViewController.m
//  美团HD
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "ViewController.h"
#import "DPAPI.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"city"] = @"北京";
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:param
         success:^(id json) {
             HMLog(@"北京请求成功");
         } failure:^(NSError *error) {
             HMLog(@"北京请求失败");
         }];
    
    
    NSMutableDictionary *param2 = [NSMutableDictionary dictionary];
    param2[@"city"] = @"广州";
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:param2
         success:^(id json) {
             HMLog(@"广州请求成功");
         } failure:^(NSError *error) {
             HMLog(@"广州请求失败");
         }];
    
    
    NSMutableDictionary *param3 = [NSMutableDictionary dictionary];
    param3[@"city"] = @"上海";
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:param3
        success:^(id json) {
            HMLog(@"上海请求成功");
        } failure:^(NSError *error) {
            HMLog(@"上海请求失败");
        }];
}

@end
