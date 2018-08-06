//
//  SettingSecureVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/4.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingSecureVC.h"

@interface SettingSecureVC ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    UIWebView       *_webView;
    UIProgressView *_progressView;
    NJKWebViewProgress      *_progressProxy;
}
@end

@implementation SettingSecureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私协议";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-64)];
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 5)];
    [self.view addSubview:_progressView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [self loadGoogle];
    
    
}

-(void)loadGoogle
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:oySecureList]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [_progressView setProgress:progress animated:NO];
}

@end