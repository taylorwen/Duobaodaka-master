//
//  StatementVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "StatementVC.h"

@interface StatementVC ()

@end

@implementation StatementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限时揭晓规则";
    self.view.backgroundColor = BG_GRAY_COLOR;
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIScrollView* scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, mainWidth-20, self.view.frame.size.height-20-64)];
    scroll.layer.cornerRadius = 8;
    scroll.contentSize = CGSizeMake(mainWidth-20, 550);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    UIButton* buyNow1 = [[UIButton alloc]initWithFrame:CGRectMake(16, 20, 220, 40)];
    buyNow1.layer.cornerRadius = 3;
    [buyNow1 setTitle:@"限时揭晓规则" forState:UIControlStateNormal];
    [buyNow1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    buyNow1.titleLabel.font = [UIFont systemFontOfSize:16];
    [buyNow1 setBackgroundColor:mainColor];
    [scroll addSubview:buyNow1];
    
    UIImageView* point_1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 11, 11)];
    point_1.image = [UIImage imageNamed:@"point_01"];
    [scroll addSubview:point_1];
    
    UILabel* title_point01 = [[UILabel alloc]initWithFrame:CGRectMake(30, 85, mainWidth-40-20, 39)];
    title_point01.font = [UIFont systemFontOfSize:13];
    title_point01.textColor = [UIColor grayColor];
    title_point01.text = @"所有限时揭晓奖品，不管已参与人次是否达到总需参与人次，都按截止时间准时揭晓。";
    title_point01.lineBreakMode = NSLineBreakByWordWrapping;
    title_point01.numberOfLines = 3;
    [scroll addSubview:title_point01];
    
    UIImageView* point_2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 130, 11, 11)];
    point_2.image = [UIImage imageNamed:@"point_02"];
    [scroll addSubview:point_2];
    
    UILabel* title_point02 = [[UILabel alloc]initWithFrame:CGRectMake(30, 120, mainWidth-40-20, 50)];
    title_point02.font = [UIFont systemFontOfSize:13];
    title_point02.textColor = [UIColor grayColor];
    title_point02.text = @"如果计算出的夺宝码未被购买，则取差值最小的夺宝码作为幸运夺宝码。";
    title_point02.lineBreakMode = NSLineBreakByWordWrapping;
    title_point02.numberOfLines = 3;
    [scroll addSubview:title_point02];
    
    UIImageView* point_3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 180, 11, 11)];
    point_3.image = [UIImage imageNamed:@"point_03"];
    [scroll addSubview:point_3];
    
    UILabel* title_point03 = [[UILabel alloc]initWithFrame:CGRectMake(30, 170, mainWidth-40-20, 50)];
    title_point03.font = [UIFont systemFontOfSize:13];
    title_point03.textColor = [UIColor grayColor];
    title_point03.text = @"如果有2个夺宝码最小差值相等，则取大值作为最终幸运夺宝码。";
    title_point03.lineBreakMode = NSLineBreakByWordWrapping;
    title_point03.numberOfLines = 3;
    [scroll addSubview:title_point03];
    
    UIImageView* point_4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 240, 11, 11)];
    point_4.image = [UIImage imageNamed:@"point_02"];
    [scroll addSubview:point_4];
    
    UILabel* title_point04 = [[UILabel alloc]initWithFrame:CGRectMake(30, 230, mainWidth-40-20, 50)];
    title_point04.font = [UIFont systemFontOfSize:13];
    title_point04.textColor = [UIColor grayColor];
    title_point04.text = @"限时揭晓奖品不参与差价送咖豆活动且晒单不可再获得1000咖豆奖励。";
    title_point04.lineBreakMode = NSLineBreakByWordWrapping;
    title_point04.numberOfLines = 3;
    [scroll addSubview:title_point04];
    
    UIImageView* point_5 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 290, 11, 11)];
    point_5.image = [UIImage imageNamed:@"point_03"];
    [scroll addSubview:point_5];
    
    UILabel* title_point05 = [[UILabel alloc]initWithFrame:CGRectMake(30, 275, mainWidth-40-20, 50)];
    title_point05.font = [UIFont systemFontOfSize:13];
    title_point05.textColor = [UIColor grayColor];
    title_point05.text = @"限时揭晓的幸运夺宝码计算方式：";
    title_point05.lineBreakMode = NSLineBreakByWordWrapping;
    title_point05.numberOfLines = 3;
    [scroll addSubview:title_point05];
    
    UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 320, mainWidth-60-20, 50)];
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.textColor = [UIColor grayColor];
    lable1.text = @"1) 限时揭晓奖品取截止时间前网站所有奖品100条购买时间记录。";
    lable1.lineBreakMode = NSLineBreakByWordWrapping;
    lable1.numberOfLines = 3;
    [scroll addSubview:lable1];
    
    UILabel* lable2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 360, mainWidth-60-20, 50)];
    lable2.font = [UIFont systemFontOfSize:13];
    lable2.textColor = [UIColor grayColor];
    lable2.text = @"2) 时间按时、分、秒、毫秒依次排列组成一组数值。";
    lable2.lineBreakMode = NSLineBreakByWordWrapping;
    lable2.numberOfLines = 3;
    [scroll addSubview:lable2];
    
    UILabel* lable3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 400, mainWidth-60-20, 50)];
    lable3.font = [UIFont systemFontOfSize:13];
    lable3.textColor = [UIColor grayColor];
    lable3.text = @"3) 将这100组数值之和除以奖品总需参与人次后取余数，余数加上10,000,001即为“幸运夺宝码”。";
    lable3.lineBreakMode = NSLineBreakByWordWrapping;
    lable3.numberOfLines = 3;
    [scroll addSubview:lable3];
    
}

@end
