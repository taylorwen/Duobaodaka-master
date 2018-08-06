//
//  HomeWinProPopVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/27.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabMinePopVC.h"
#import "HomeModel.h"

@interface TabMinePopVC ()
{
    WinProModel*        winItem;
}
@end

@implementation TabMinePopVC
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
    UIView* background = [[UIView alloc]initWithFrame:CGRectMake(32, (self.view.frame.size.height-mainWidth+64)/2, mainWidth-64, mainWidth-64)];
    background.backgroundColor = [UIColor whiteColor];
    background.layer.masksToBounds= YES;
    background.layer.cornerRadius = 10  ;
    [self.view addSubview:background];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-32-22, (self.view.frame.size.height-mainWidth+64)/2-15, 30, 30)];
    [close setImage:[UIImage imageNamed:@"red_cha"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeWinPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UIButton* service1 = [[UIButton alloc]initWithFrame:CGRectMake((background.frame.size.width/2-60)/2, 10, 60, 60)];
    [service1 setImage:[UIImage imageNamed:@"登录_03"] forState:UIControlStateNormal];
    [service1 addTarget:self action:@selector(servece1ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:service1];
    
    UILabel* serviceName1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, background.frame.size.width/2, 20)];
    serviceName1.text = @"客服MM - 小文";
    serviceName1.textColor = [UIColor grayColor];
    serviceName1.font = [UIFont systemFontOfSize:14];
    serviceName1.textAlignment = NSTextAlignmentCenter;
    [background addSubview:serviceName1];
    
    UIButton* service2 = [[UIButton alloc]initWithFrame:CGRectMake((background.frame.size.width/2-60)/2+background.frame.size.width/2, 10, 60, 60)];
    [service2 setImage:[UIImage imageNamed:@"登录_03"] forState:UIControlStateNormal];
    [service2 addTarget:self action:@selector(servece2ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:service2];
    
    UILabel* serviceName2 = [[UILabel alloc]initWithFrame:CGRectMake(background.frame.size.width/2, 80, background.frame.size.width/2, 20)];
    serviceName2.text = @"客服MM - 小海";
    serviceName2.textColor = [UIColor grayColor];
    serviceName2.font = [UIFont systemFontOfSize:14];
    serviceName2.textAlignment = NSTextAlignmentCenter;
    [background addSubview:serviceName2];
    
    UIButton* service3 = [[UIButton alloc]initWithFrame:CGRectMake((background.frame.size.width/2-60)/2, 110, 60, 60)];
    [service3 setImage:[UIImage imageNamed:@"登录_03"] forState:UIControlStateNormal];
    [service3 addTarget:self action:@selector(servece3ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:service3];
    
    UILabel* serviceName3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, background.frame.size.width/2, 20)];
    serviceName3.text = @"客服MM - 婷婷";
    serviceName3.textColor = [UIColor grayColor];
    serviceName3.font = [UIFont systemFontOfSize:14];
    serviceName3.textAlignment = NSTextAlignmentCenter;
    [background addSubview:serviceName3];
    
    UIButton* service4 = [[UIButton alloc]initWithFrame:CGRectMake((background.frame.size.width/2-60)/2+background.frame.size.width/2, 110, 60, 60)];
    [service4 setImage:[UIImage imageNamed:@"登录_03"] forState:UIControlStateNormal];
    [service4 addTarget:self action:@selector(servece4ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:service4];
    
    UILabel* serviceName4 = [[UILabel alloc]initWithFrame:CGRectMake(background.frame.size.width/2, 180, background.frame.size.width/2, 20)];
    serviceName4.text = @"客服MM - 露露";
    serviceName4.textColor = [UIColor grayColor];
    serviceName4.font = [UIFont systemFontOfSize:14];
    serviceName4.textAlignment = NSTextAlignmentCenter;
    [background addSubview:serviceName4];
    
    UIButton* btnCall = [[UIButton alloc]initWithFrame:CGRectMake(0, background.frame.size.height-40, background.frame.size.width, 40)];
    [btnCall setImage:[UIImage imageNamed:@"icon_phonekefu"] forState:UIControlStateNormal];
    [btnCall setImageEdgeInsets:UIEdgeInsetsMake(10, 40, 10, background.frame.size.width-40-20)];
    btnCall.backgroundColor = mainColor;
    [btnCall setTitle:@"400-608-6666" forState:UIControlStateNormal];
    [btnCall setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCall setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [btnCall addTarget:self action:@selector(servece5ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:btnCall];
}

- (void)servece1ButtonClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextTabMineButton1Clicked:)]) {
        [self.delegate goNextTabMineButton1Clicked:self];
    }
    
}

- (void)servece2ButtonClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextTabMineButton2Clicked:)]) {
        [self.delegate goNextTabMineButton2Clicked:self];
    }
    
}

- (void)servece3ButtonClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextTabMineButton3Clicked:)]) {
        [self.delegate goNextTabMineButton3Clicked:self];
    }
    
}

- (void)servece4ButtonClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextTabMineButton4Clicked:)]) {
        [self.delegate goNextTabMineButton4Clicked:self];
    }
    
}

- (void)servece5ButtonClicked
{
    //跳转到地址页面
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextTabMineButton5Clicked:)]) {
        [self.delegate goNextTabMineButton5Clicked:self];
    }
    
}

- (void)closeWinPopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelTabMineButtonClicked:)]) {
        [self.delegate cancelTabMineButtonClicked:self];
    }
}
@end
