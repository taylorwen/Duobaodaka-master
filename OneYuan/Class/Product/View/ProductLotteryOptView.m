//
//  ProductLotteryOptView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLotteryOptView.h"
#import "CartModel.h"
#import "ProductModel.h"

@interface ProductLotteryOptView ()
{
    __weak id<ProductLotteryOptViewDelegate> delegate;
    __block BTBadgeView                     *btB;
    __block UIButton                                *btnBuy;
    __block UILabel                                 *lblQishu;
}
@end

@implementation ProductLotteryOptView
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
        
        lblQishu = [[UILabel alloc]initWithFrame:CGRectMake(16, 9.5, mainWidth-32 - 100, 30)];
        lblQishu.textColor = [UIColor hexFloatColor:@"666666"];
        lblQishu.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblQishu];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 116, 4.5, 100 , 40)];
        [btnBuy setTitle:@"立即前往" forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:13];
        btnBuy.layer.cornerRadius = 5;
        btnBuy.layer.masksToBounds = YES;
        [btnBuy addTarget:self action:@selector(btnGotoDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        btB = [[BTBadgeView alloc] init];
        btB.shine = NO;
        btB.shadow = NO;
        [CartModel quertCart:nil value:nil block:^(NSArray* result){
            if(result.count > 0)
                btB.value = [NSString stringWithFormat:@"%d",(int)result.count];
        }];
        if([btB.value intValue]< 10)
        {
            btB.frame = CGRectMake(mainWidth - 30, 0, 22, 22);
        }
        else if([btB.value intValue] < 100)
        {
            btB.frame = CGRectMake(mainWidth - 30, 0, 30, 22);
        }
//        [self addSubview:btB];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnGotoCart)];
        [btB addGestureRecognizer:tap];
    }
    return self;
}


- (void)btnGotoDetail
{
    if(delegate)
    {
        [delegate gotoDetailAction];
    }
}

- (void)btnGotoCart
{
    if(delegate)
    {
        [delegate gotoCartAction];
    }
}

- (void)setCartNum:(int)count
{
    if(count <=0)
        btB.value = @"";
    else
        btB.value  = [NSString stringWithFormat:@"%d",count];
    
    if([btB.value intValue]< 10)
    {
        btB.frame = CGRectMake(mainWidth - 30, 0, 22, 22);
    }
    else if([btB.value intValue] < 100)
    {
        btB.frame = CGRectMake(mainWidth - 30, 0, 30, 22);
    }
}

- (void)setBtnPeriod:(ProductNextPeriod*)period
{
    if(period.qishu)
    {
        [btnBuy setTitle:@"立即前往" forState:UIControlStateNormal];
        lblQishu.text = [NSString stringWithFormat:@"第%@期正在火热进行中",period.qishu];
    }
    else {
        [btnBuy setTitle:[NSString stringWithFormat:@"暂无下期"] forState:UIControlStateNormal];
        btnBuy.userInteractionEnabled = NO;
        lblQishu.text = [NSString stringWithFormat:@"暂无下期，敬请关注"];
    }
    
    
}
@end
