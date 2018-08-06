//
//  ProductDetailOptView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductDetailOptView.h"
#import "CartModel.h"

@interface ProductDetailOptView ()
{
    __weak id<ProductDetailOptViewDelegate> delegate;
    __block BTBadgeView* btB;
}
@end

@implementation ProductDetailOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        UIButton* btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth*0.37, 0, mainWidth*0.37 , 40)];
        [btnBuy setTitle:@"立即夺宝" forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:[UIColor hexFloatColor:@"e05000"]];
        btnBuy.layer.cornerRadius = 0;
        btnBuy.layer.masksToBounds = YES;
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnBuy addTarget:self action:@selector(btnAddGotoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        UIButton* btnAddCart = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainWidth*0.37 , 40)];
        [btnAddCart setTitle:@"加入清单" forState:UIControlStateNormal];
        [btnAddCart setBackgroundColor:[UIColor hexFloatColor:@"edb000"]];
        btnAddCart.layer.cornerRadius = 0;
        btnAddCart.layer.masksToBounds = YES;
        btnAddCart.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnAddCart addTarget:self action:@selector(btnAddtoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAddCart];
        
        UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth*0.74, 0, mainWidth*0.26, 30)];
        [btnCart setBackgroundColor:[UIColor blackColor]];
        [btnCart setImage:[UIImage imageNamed:@"tab-cart"] forState:UIControlStateNormal];
        [btnCart addTarget:self action:@selector(btnGotoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCart];
        
        UILabel* lblButton = [[UILabel alloc]initWithFrame: CGRectMake(mainWidth*0.74, 29, mainWidth*0.26, 10)];
        lblButton.text = @"清单";
        lblButton.textColor = [UIColor whiteColor];
        lblButton.font = [UIFont systemFontOfSize:9];
        lblButton.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblButton];
        

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
        [self addSubview:btB];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnGotoCart)];
        [btB addGestureRecognizer:tap];
    }
    return self;
}

- (void)btnAddtoCart
{
    if(delegate)
    {
        [delegate addToCartAction];
    }
}


- (void)btnAddGotoCart
{
    if(delegate)
    {
        [delegate addGotoCartAction];
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
@end
