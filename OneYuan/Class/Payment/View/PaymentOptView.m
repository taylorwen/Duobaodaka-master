//
//  CartOptView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PaymentOptView.h"
#import "CartModel.h"
#import "OyTool.h"

#define orY 15

@interface PaymentOptView ()
{
    __weak id<PaymentOptViewDelegate> delegate;
    UIButton                           *btnBuy;
}

@end

@implementation PaymentOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, mainWidth - 32 , 30)];
        [btnBuy setTitle:@"确认支付" forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24];
        btnBuy.layer.cornerRadius = 3;
        btnBuy.layer.masksToBounds = YES;
        [btnBuy addTarget:self action:@selector(btnCalcAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
    }
    return self;
}

- (void)btnCalcAction
{
            if(delegate)
            {
                [delegate callThirdPartyPaymentAction];
            }
}
@end
