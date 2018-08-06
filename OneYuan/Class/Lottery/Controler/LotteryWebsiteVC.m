//
//  LotteryWebsiteVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LotteryWebsiteVC.h"

@interface LotteryWebsiteVC ()

@end

@implementation LotteryWebsiteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"最新开奖";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
    //时时彩网站
    [[XBToastManager ShardInstance]showprogress];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://caipiao.163.com/t/award/cqssc/"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    [[XBToastManager ShardInstance]hideprogress];
    
}








@end
