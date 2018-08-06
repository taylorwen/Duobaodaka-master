//
//  CartOptView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartOptView.h"
#import "CartModel.h"
#import "OyTool.h"

#define orY 15

@interface CartOptView ()
{
    __weak id<CartOptViewDelegate> delegate;
    
    UILabel* lblNum;
    UILabel* lbl2;
    UILabel* lblPrice;
    UILabel* lbl3;
}

@end

@implementation CartOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
        self.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        self.layer.borderWidth = 0.5;
        /**
         Label   共
         */
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, orY, 100, 13)];
        lbl1.text = @"共";
        lbl1.font = [UIFont systemFontOfSize:14];
        lbl1.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl1];
        /**
         Label  件商品，合计
         */
        lbl2 = [[UILabel alloc] init];
        lbl2.text = @"件奖品，合计";
        lbl2.font = [UIFont systemFontOfSize:14];
        lbl2.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl2];
        /**
         Label   元
         */
        lbl3 = [[UILabel alloc] init];
        lbl3.text = @"夺宝币";
        lbl3.font = [UIFont systemFontOfSize:14];
        lbl3.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl3];
        /**
         Label   商品件数
         */
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(30, orY, 100, 13)];
        lblNum.font = [UIFont systemFontOfSize:14];
        lblNum.textColor = mainColor;
        [self addSubview:lblNum];
        /**
         Label   价格
         */
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:14];
        lblPrice.textColor = mainColor;
        [self addSubview:lblPrice];
        /**
         Button   去结算
         */
        UIButton* btnCalc = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 90, 5, 80, 34)];
        [btnCalc setBackgroundColor:mainColor];
        [btnCalc setTitle:@"去结算" forState:UIControlStateNormal];
        [btnCalc setTitleColor:wordColor forState:UIControlStateNormal];
        btnCalc.layer.cornerRadius = 3;
        [btnCalc addTarget:self action:@selector(btnCalcAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCalc];
    }
    return self;
}
/**
 *  计算结算行的商品件数和总价;
 */

- (void)setOpt
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        lblNum.text = [NSString stringWithFormat:@"%d",(int)result.count];
        
        int price = 0;
        int price10 = 0;
        for (CartItem* item in result)
        {
            if ([item.yunjiage intValue] ==10)
            {
                price10 += [item.yunjiage intValue]*[item.gonumber intValue] ;
            }
            else if ([item.yunjiage intValue] == 1)
            {
                price   += [item.yunjiage intValue]*[item.gonumber intValue];
            }
        }
        int priceTotal = price10 + price;
        lblPrice.text = [NSString stringWithFormat:@"%d",priceTotal];
        
        CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize s2 = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake(lblNum.frame.origin.x + s.width + 5, orY, s2.width, 13);
        
        s = [lblPrice.text textSizeWithFont:lblPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        lblPrice.frame = CGRectMake(lbl2.frame.origin.x + lbl2.frame.size.width + 10, orY, s.width, 13);
        
        lbl3.frame = CGRectMake(lblPrice.frame.origin.x + lblPrice.frame.size.width + 10, orY, 100, 13) ;
    }];
}

- (void)btnCalcAction
{
    if(delegate)
    {
        [delegate cartCalcAction:lblPrice.text];
    }
}

@end