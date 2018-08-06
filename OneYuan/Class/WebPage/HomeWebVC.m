//
//  HomeWebVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/29.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeWebVC.h"
#import "NJKWebViewProgress.h"
#import "UMSocialSnsService.h"
#import "HomeModel.h"

@interface HomeWebVC ()<UIWebViewDelegate, NJKWebViewProgressDelegate,UMSocialUIDelegate>
{
    UIWebView       *_webView;
    UIProgressView *_progressView;
    NJKWebViewProgress      *_progressProxy;
    HomeAd* itemAd;
}
@end

@implementation HomeWebVC

- (id)initWithURL:(HomeAd *)url
{
    self = [super init];
    if(self)
    {
        itemAd = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof(self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self actionCustomRightBtnWithNrlImage:@"free" htlImage:@"free" title:@"" action:^{
        [wSelf loadShareSDK];
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
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:itemAd.link]];
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

- (void)loadShareSDK
{
    [UMSocialData defaultData].extConfig.wechatSessionData.title    = itemAd.title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title   = itemAd.title;
    [UMSocialData defaultData].extConfig.qqData.title               = itemAd.title;
    [UMSocialData defaultData].extConfig.qzoneData.title            = itemAd.title;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url  = itemAd.link;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = itemAd.link;
    [UMSocialData defaultData].extConfig.qqData.url             = itemAd.link;
    [UMSocialData defaultData].extConfig.qzoneData.url          = itemAd.link;
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:itemAd.title
                                     shareImage:[UIImage imageNamed:@"icon40"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
}



@end
