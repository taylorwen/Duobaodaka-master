//
//  CartShowMoreCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartShowMoreCell.h"
#import "CartModel.h"
#import "OyTool.h"

#define orY 15

@interface CartShowMoreCell ()
{
    __weak id<PaymentShowViewDelegate> delegate;
    UIButton                           *btnBuy;
    UILabel                             *lblTotal;
}
@end

@implementation CartShowMoreCell
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel* lblPay = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 30)];
        lblPay.font = [UIFont systemFontOfSize:15];
        lblPay.textColor = [UIColor grayColor];
        lblPay.text = @"总需支付：";
        [self addSubview:lblPay];
        
        lblTotal = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, 200, 30)];
        lblTotal.font = [UIFont systemFontOfSize:15];
        lblTotal.textColor = [UIColor redColor];
        [self addSubview:lblTotal];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth-98, 0, 90, 30)];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"上"] forState:UIControlStateSelected];
        [btnBuy addTarget:self action:@selector(btnCalcAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
    }
    return self;
}

- (void)setPaymentValue:(NSString*)totalMoney
{
    lblTotal.text = [NSString stringWithFormat:@"%@ 夺宝币",totalMoney];
}

- (void)btnCalcAction:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [delegate addMoreItems];
    }
    else if(!btn.selected)
    {
        [delegate showThreeItems];
    }
}

@end
