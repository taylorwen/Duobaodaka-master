//
//  ActivityRuleVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/24.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ActivityRuleVC.h"

@interface ActivityRuleVC ()

@end

@implementation ActivityRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(32, 74, mainWidth-64, self.view.frame.size.height-132)];
    bg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bg];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(bg.frame.size.width+32-23, 74-15, 38, 38)];
    [close setImage:[UIImage imageNamed:@"btn1Home"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UITextView* txtView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, bg.frame.size.width-20, bg.frame.size.height-20)];
    txtView.backgroundColor = [UIColor whiteColor];
    txtView.layer.cornerRadius = 5;
    txtView.font = [UIFont systemFontOfSize:13];
    txtView.text = @"1. 注册会员每分享成功一次，即可获得该期奖品的1个夺宝码\n\n2. 每期奖品开奖时间为10分钟，如10分钟内没有夺满也一样揭晓\n\n3. 每期奖品开奖时间为10分钟，如10分钟内没有夺满也一样揭晓\n\n4. 注册会员每购买1元大咖网盘空间，即可获得该期奖品的一个夺宝码\n\n5. 每期奖品开奖时按照开奖规则揭晓一个夺宝码，拥有该夺宝码的用户获得该期奖品\n\n6. 每个会员每期产品只能分享一次\n\n7. 本活动最终解释权归夺宝大咖所有\n\n8. 用户中奖后，话费只能充值到中奖用户的注册手机号码，且每个手机号码最多只能充值300元，即同一用户在活动期间最多可获得3次中奖机会，其他视为无效。";
    [bg addSubview:txtView];
    
}

- (void)closePopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
        [self.delegate cancelLimiteButtonClicked:self];
    }
}

@end
