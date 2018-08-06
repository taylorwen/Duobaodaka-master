//
//  SuperShareVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/20.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SuperShareVC.h"
#import "Limite3Model.h"
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "FreeBuySuccessVC.h"

@interface SuperShareVC ()<UIActionSheetDelegate,UMSocialUIDelegate>
{
    NSString*   uid_user;
    NSString*   sid_codeid;
}
@end

@implementation SuperShareVC
- (id)initWithUserID:(NSString*)userid codeId:(NSString*)codeId
{
    self = [super init];
    if(self)
    {
        uid_user = userid;
        sid_codeid = codeId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百元话费，免费夺取";
    self.view.backgroundColor = BG_GRAY_COLOR;
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight-64)];
    bg.image = [UIImage imageNamed:@"super_share"];
    [self.view addSubview:bg];
    
    UILabel* freeHuafei = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.6, mainWidth, 30)];
    freeHuafei.textColor = [UIColor brownColor];
    freeHuafei.font = [UIFont systemFontOfSize:17];
    freeHuafei.text = @"成功分享至朋友圈，即可完成免费夺话费";
    freeHuafei.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:freeHuafei];
    
    UIButton* btnShare = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/4, self.view.frame.size.height*0.6 + 60, mainWidth/2, 40)];
    [btnShare setBackgroundColor:[UIColor redColor]];
    [btnShare setTitle:@"立即分享" forState:UIControlStateNormal];
    btnShare.layer.cornerRadius = 4;
    btnShare.layer.masksToBounds = YES;
    [btnShare addTarget:self action:@selector(sharedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShare];
    
    
}

- (void)sharedButtonClicked
{
    [[XBToastManager ShardInstance]showprogress];
    NSDictionary* dict = @{@"uid":uid_user,@"sid":sid_codeid};
    [Limite3Model getSharedUser:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([parser.resultCode isEqualToString:@"200"]) {
            
            //开始分享
            [UMSocialData defaultData].extConfig.qqData.title = @"夺宝大咖";
            [UMSocialData defaultData].extConfig.qzoneData.title = @"夺宝大咖";
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"夺宝大咖";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"夺宝大咖";
            
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault];
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@%@",oyBasePHPUrl,oyNewGetLimiteSharedURL,[UserInstance ShardInstnce].mobile];
            [UMSocialData defaultData].extConfig.wechatSessionData.url  = [NSString stringWithFormat:@"%@%@%@",oyBasePHPUrl,oyNewGetLimiteSharedURL,[UserInstance ShardInstnce].mobile];//微信聊天的分享
            [UMSocialData defaultData].extConfig.qqData.url             = [NSString stringWithFormat:@"%@%@%@",oyBasePHPUrl,oyNewGetLimiteSharedURL,[UserInstance ShardInstnce].mobile];
            [UMSocialData defaultData].extConfig.qzoneData.url          = [NSString stringWithFormat:@"%@%@%@",oyBasePHPUrl,oyNewGetLimiteSharedURL,[UserInstance ShardInstnce].mobile];
            
            //调用快速分享接口
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UmengAppkey
                                              shareText:@"夺宝大咖，等你来抢百元话费"
                                             shareImage:[UIImage imageNamed:@"icon40"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,nil]
                                               delegate:self];
        }
        else if ([parser.resultCode isEqualToString:@"201"]){
            [[XBToastManager ShardInstance]showtoast:parser.resultMessage];
        }else
        {
            [[XBToastManager ShardInstance]showtoast:parser.resultMessage];
        }
        
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        //开始处理回调方法
        [self loadAutoBuy];
    }
}

//分享成功后自动购买
- (void)loadAutoBuy
{
    [[XBToastManager ShardInstance]showprogress];
    NSString* ipStr = [UserInstance ShardInstnce].user_ip;
    NSDictionary* dict = @{@"uid":uid_user,@"sid":sid_codeid,@"ip":ipStr};
    [Limite3Model getautoBuy:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([parser.resultCode isEqualToString:@"200"]) {
            //购买成功，进入成功页面
            FreeBuySuccessVC* vc = [[FreeBuySuccessVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance]showtoast:parser.resultMessage wait:5.0f];
        }
        
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}
@end
