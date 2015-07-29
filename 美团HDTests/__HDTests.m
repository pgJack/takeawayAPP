//
//  __HDTests.m
//  美团HDTests
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Extension.h"

@interface __HDTests : XCTestCase

@end

@implementation __HDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testString
{
    NSString *str = @"89.90000023456";
    NSString *result = [str dealedPriceString];
    NSAssert([result isEqualToString:@"89.9"], @"dealedPriceString计算方法有问题");
}

// 单元测试 测试某个单元 (某个业务功能)
// 红灯 : 测试不通过
// 绿灯 : 测试通过
- (void)testCalender
{
    // 创建一个日历对象 (能完成很多的日期处理)
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 创建日期
//    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [fmt dateFromString:@"2008-08-08 08-08-08"];
    NSDate *date2 = [fmt dateFromString:@"2015-08-08 08-08-08"];
    
    // 比较日期
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calender components:unit fromDate:date1 toDate:date2 options:kNilOptions];
    NSAssert(cmps.year == 7, @"NSCalendar计算方法有问题");
    
//    NSLog(@"-----华丽的分割线------");
//    NSLog(@"%d - %d - %d - %d - %d - %d",cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
//    NSLog(@"-----忧伤的分割线------");
    
    // 获得date的某个元素 (年月日时分秒...元素)
//    NSDateComponents *cmps = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
//    NSLog(@"%d - %d - %d - %d - %d - %d",cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
//    NSInteger year = [calender component:NSCalendarUnitYear fromDate:date];
//    NSInteger month = [calender component:NSCalendarUnitMonth fromDate:date];
//    NSInteger day = [calender component:NSCalendarUnitDay fromDate:date];
//    NSLog(@"%d - %d - %d",year, month, day);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
