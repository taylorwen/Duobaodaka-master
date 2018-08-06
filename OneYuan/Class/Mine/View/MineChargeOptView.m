//
//  MineChargeOptView.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineChargeOptView.h"
@interface MineChargeOptView ()
{
    __weak id<ChargeOptViewDelegate> delegate;
    UIButton                          *btnBuy;
}
@end

@implementation MineChargeOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
        line1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line1];
        
        UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, mainWidth, 0.5)];
        line2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line2];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(16, 4.5, mainWidth - 32 , 40)];
        [btnBuy setTitle:@"确认充值" forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:14];
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
        [delegate chargeCallThirdPartyPayAction];
    }
}


@end
