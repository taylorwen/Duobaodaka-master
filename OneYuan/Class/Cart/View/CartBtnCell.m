//
//  CartBtnCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/2.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartBtnCell.h"
#import "CartModel.h"
#import "OyTool.h"

#define orY 15

@interface CartBtnCell ()
{
    __weak id<PaymentBtnViewDelegate> delegate;
    UIButton                           *btnBuy;
}
@end

@implementation CartBtnCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(16, 6.5, mainWidth - 32 , 36)];
        [btnBuy setTitle:@"确认支付" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:18];
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
        [delegate cellCallThirdPartyPaymentAction];
    }
}

@end
