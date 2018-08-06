//
//  ProductImgDetailVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductImgDetailVC.h"
#import "ProductImgDetailModel.h"



@interface ProductImgDetailVC ()<UMSocialUIDelegate>
{
    NSString* _goodsId;
    ProductImage* proImage;
    NSString*   shareURL;
    NSString*   goodsTitle;
}
@end

@implementation ProductImgDetailVC

- (id)initWithGoodsId:(NSString*)goodsArr goodTitle:(NSString*)title
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsArr;
        goodsTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"奖品图文详情";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self actionCustomRightBtnWithNrlImage:@"free" htlImage:@"free" title:@"" action:^{
        [wSelf loadShareSDK];
    }];
    [self drawWebview];
}

- (void)drawWebview
{
    [[XBToastManager ShardInstance] showprogress];

    NSString* urlbase = @"http://m.duobaodaka.com/index.php/mobile/mobile/goodsdesc_app/";
    NSString* URL = [urlbase stringByAppendingString:_goodsId];
    shareURL = URL;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    [[XBToastManager ShardInstance] hideprogress];
}

- (void)loadShareSDK
{
    [UMSocialData defaultData].extConfig.wechatSessionData.title    = @"夺宝大咖";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title   = @"夺宝大咖";
    [UMSocialData defaultData].extConfig.qqData.title               = @"夺宝大咖";
    [UMSocialData defaultData].extConfig.qzoneData.title            = @"夺宝大咖";
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url  = shareURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    [UMSocialData defaultData].extConfig.qqData.url             = shareURL;
    [UMSocialData defaultData].extConfig.qzoneData.url          = shareURL;
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:goodsTitle
                                     shareImage:[UIImage imageNamed:@"icon40"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
}
@end
