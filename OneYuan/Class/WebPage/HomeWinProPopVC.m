//
//  HomeWinProPopVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/27.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeWinProPopVC.h"
#import "HomeModel.h"

@interface HomeWinProPopVC ()
{
    WinProModel*        winItem;
}
@end

@implementation HomeWinProPopVC
- (id)initWithWinProInfo:(WinProModel*)item
{
    self = [super init];
    if(self)
    {
        winItem = item;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* background = [[UIView alloc]initWithFrame:CGRectMake(32, (self.view.frame.size.height-380)/2, mainWidth-64, 380)];
    background.backgroundColor = [UIColor whiteColor];
    background.layer.masksToBounds= YES;
    background.layer.cornerRadius = 10  ;
    [self.view addSubview:background];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-32-29, (self.view.frame.size.height-380)/2-15, 44, 44)];
    [close setImage:[UIImage imageNamed:@"red_cha"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeWinPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UIImageView* winImg = [[UIImageView alloc]initWithFrame:CGRectMake((background.frame.size.width-200)/2, 20, 200, 156)];
    winImg.image = [UIImage imageNamed:@"zhongjiang"];
    [background addSubview:winImg];
    
    UILabel* lblGet = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+156, background.frame.size.width, 25)];
    lblGet.textColor = [UIColor grayColor];
    lblGet.font = [UIFont systemFontOfSize:14];
    lblGet.text = @"您获得了奖品";
    lblGet.textAlignment = NSTextAlignmentCenter;
    [background addSubview:lblGet];
    
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+156+10+12, background.frame.size.width-20, 40)];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.text = [NSString stringWithFormat:@"(第%@期) %@",winItem.qishu,winItem.title];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    lblTitle.numberOfLines = 2;
    [background addSubview:lblTitle];
    
    UILabel* lblLuky = [[UILabel alloc]initWithFrame:CGRectMake(32, 20+156+10+25+30, background.frame.size.width, 20)];
    lblLuky.textColor = [UIColor grayColor];
    lblLuky.font = [UIFont systemFontOfSize:14];
    lblLuky.text = @"幸运号码";
    [background addSubview:lblLuky];
    
    UILabel* lblLukyCode = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+156+10+25+30, background.frame.size.width-32, 20)];
    lblLukyCode.textColor = [UIColor redColor];
    lblLukyCode.font = [UIFont systemFontOfSize:14];
    lblLukyCode.text = winItem.huode;
    lblLukyCode.textAlignment = NSTextAlignmentRight;
    [background addSubview:lblLukyCode];
    
    UILabel* lblBuy = [[UILabel alloc]initWithFrame:CGRectMake(32, 20+156+10+25+30+25, background.frame.size.width-64, 20)];
    lblBuy.textColor = [UIColor grayColor];
    lblBuy.font = [UIFont systemFontOfSize:14];
    lblBuy.text = @"幸运时间";
    [background addSubview:lblBuy];
    
    UILabel* lblBuyTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+156+10+25+30+25, background.frame.size.width-32, 20)];
    lblBuyTime.textColor = [UIColor grayColor];
    lblBuyTime.font = [UIFont systemFontOfSize:14];
    lblBuyTime.text = [WenzhanTool formateDateStr:winItem.time];
    lblBuyTime.textAlignment = NSTextAlignmentRight;
    [background addSubview:lblBuyTime];
    
    UIButton* btnConfirm = [[UIButton alloc]initWithFrame:CGRectMake(32, 20+156+10+25+30+25+40, background.frame.size.width-64, 44)];
    btnConfirm.backgroundColor = mainColor;
    btnConfirm.layer.masksToBounds = YES;
    btnConfirm.layer.cornerRadius = 5;
    [btnConfirm setTitle:@"确认收货地址" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm addTarget:self action:@selector(confirmAddressClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:btnConfirm];
    
}

- (void)confirmAddressClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextWinButtonClicked:)]) {
        [self.delegate goNextWinButtonClicked:self];
    }
    
}

- (void)closeWinPopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWinButtonClicked:)]) {
        [self.delegate cancelWinButtonClicked:self];
    }
}
@end
