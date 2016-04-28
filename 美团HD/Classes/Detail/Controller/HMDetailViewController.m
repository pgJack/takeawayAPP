//
//  HMDetailViewController.m
//  美团HD
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMDetailViewController.h"
#import "HMDeal.h"
#import "HMCenterLineLabel.h"
#import <UIImageView+WebCache.h>
#import "DPAPI.h"
#import "MBProgressHUD+HMExtension.h"
#import "HMGetSingleDealResult.h"
#import <MJExtension.h>
#import "HMDealTool.h"

@interface HMDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet HMCenterLineLabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *anyTimeRefuntableBtn;
@property (weak, nonatomic) IBOutlet UIButton *expireRefuntableBtn;
@property (weak, nonatomic) IBOutlet UIButton *soldNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *remainingTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end

@implementation HMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 处理右边的webView
    [self setupRightWebView];
    
    // 处理左边的内容
    [self setupLeftView];
    
    // 添加这个团购到最近访问记录中
    [HMDealTool addHistoryDeal:self.deal];
}

/**
 *  处理左边的内容
 */
- (void)setupLeftView
{
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = self.deal.title;
    // 描述
    self.descLabel.text = self.deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.deal.list_price];
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.current_price];
    // 购买数
    [self.soldNumberBtn setTitle:[NSString stringWithFormat:@"已购买%@",self.deal.purchase_count] forState:UIControlStateNormal];
    // 获得过期的时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    // 增加一天的过期时间
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    
    // 2015-07-28 00:00:00
    // 2015-07-28 23:59:59
//    HMLog(@"%@",self.deal.purchase_deadline);
    
    // 比较过期时间和当前时间
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calender components:unit fromDate:[NSDate date] toDate:dead options:kNilOptions];
    
    // 设置剩余时间
    if (cmps.day >= 30) {
        [self.remainingTimeBtn setTitle:@"未来一个月内有效" forState:UIControlStateNormal];
    } else {
        [self.remainingTimeBtn setTitle:[NSString stringWithFormat:@"剩余%d天%d小时%d分钟",cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    // 发送请求给服务器获取更详细的团购信息
    NSDictionary *params = @{@"deal_id" : self.deal.deal_id};
    [[DPAPI sharedInstance] request:@"v1/deal/get_single_deal" params:params success:^(id json) {
        HMGetSingleDealResult *result = [HMGetSingleDealResult objectWithKeyValues:json];
        self.deal =  [result.deals lastObject];
        
        self.anyTimeRefuntableBtn.selected = self.deal.is_refundable;
        self.expireRefuntableBtn.selected = self.deal.is_refundable;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"找不到指定的团购信息"];
    }];
    
    // 控制收藏按钮的状态
    self.collectBtn.selected = [HMDealTool isCollected:self.deal];
    
}

/**
 *  处理右边的webView
 */
- (void)setupRightWebView
{
    // 设置webView的代理
    self.webView.delegate = self;
    
    // 截取id
    NSString *ID = [self.deal.deal_id substringFromIndex:2];
    // 拼接请求url
    NSString *url = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
    
    // 加载右边的页面
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

/**
 *  点击了返回键
 */
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击了收藏按钮
 */
- (IBAction)collect:(UIButton *)button {
    
    if (button.isSelected) { // 已经被收藏,现在需要取消收藏
        [HMDealTool uncollect:self.deal];
    } else { // 没有被收藏,现在需要收藏
        [HMDealTool collect:self.deal];
    }
    
    button.selected = !button.isSelected;
}

/**
 *  设置当前控制器支持哪些方向
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - <UIWebViewDelegate>

/**
 *  webView加载完毕时调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 执行JS删掉不需要的节点
    NSString *js = @"document.getElementsByTagName('header')[0].remove();"
                    "document.getElementsByClassName('cost-box')[0].remove();"
                    "document.getElementsByClassName('buy-now')[0].remove();"
                    "document.getElementsByTagName('footer')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:js];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    HMLog(@"%@ - %@",self.deal.deal_id, request.URL);
//    return YES;
//}

@end
