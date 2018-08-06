//
//  HomeBtnCollectionCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeBtnCollectionCell.h"

@interface HomeBtnCollectionCell ()
{
    __weak id<HomeBtnCellDelegate> delegate;
    
    UIButton    *btnNew;
    UILabel     *lblNew;
    
    UIButton    *btnShow;
    UILabel     *lblShow;
    
    UIButton    *btnBuy;
    UILabel     *lblBuy;
    
    UIButton    *btnAccount;
    UILabel     *lblAccount;
}

@end

@implementation HomeBtnCollectionCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat width = 32;
        CGFloat perW = (mainWidth - width * 4) / 5;
        
        btnNew = [[UIButton alloc] initWithFrame:CGRectMake(perW, 10, width, width)];
        [btnNew setImage:[UIImage imageNamed:@"home_btn_new"] forState:UIControlStateNormal];
        [btnNew addTarget:self action:@selector(newAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnNew];
        
        lblNew = [[UILabel alloc] initWithFrame:CGRectMake(perW - 8, 50, 50, 15)];
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
            lblNew.text = @"十元专区";
        }
        else{
            lblNew.text = @"潮流新品";
        }
        lblNew.textAlignment = NSTextAlignmentCenter;
        lblNew.font = [UIFont systemFontOfSize:12];
        lblNew.textColor = wordColor;
        [self addSubview:lblNew];
        
        btnShow = [[UIButton alloc] initWithFrame:CGRectMake(perW * 2 + width, 10, width, width)];
        [btnShow setImage:[UIImage imageNamed:@"home_btn_show"] forState:UIControlStateNormal];
        [btnShow addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnShow];
        
        lblShow = [[UILabel alloc] initWithFrame:CGRectMake(perW*2+width*1 - 8, 50, 50, 15)];
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
            lblShow.text = @"晒单";
        }
        else{
            lblShow.text = @"最新揭晓";
        }
        lblShow.textAlignment = NSTextAlignmentCenter;
        lblShow.font = [UIFont systemFontOfSize:12];
        lblShow.textColor = wordColor;
        [self addSubview:lblShow];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(perW * 3 + width * 2, 10, width, width)];
        [btnBuy setImage:[UIImage imageNamed:@"home_btn_buy"] forState:UIControlStateNormal];
        [btnBuy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        lblBuy = [[UILabel alloc] initWithFrame:CGRectMake(perW*3+width*2 - 8, 50, 50, 15)];
        lblBuy.text = @"夺宝记录";
        lblBuy.textAlignment = NSTextAlignmentCenter;
        lblBuy.font = [UIFont systemFontOfSize:12];
        lblBuy.textColor = wordColor;
        [self addSubview:lblBuy];
        
        btnAccount = [[UIButton alloc] initWithFrame:CGRectMake(perW * 4 + width * 3, 10, width, width)];
        [btnAccount setImage:[UIImage imageNamed:@"home_btn_charge"] forState:UIControlStateNormal];
        [btnAccount addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAccount];
        
        lblAccount = [[UILabel alloc] initWithFrame:CGRectMake(perW*4+width*3 - 8, 50, 50, 15)];
        lblAccount.text = @"充值";
        lblAccount.textAlignment = NSTextAlignmentCenter;
        lblAccount.font = [UIFont systemFontOfSize:12];
        lblAccount.textColor = wordColor;
        [self addSubview:lblAccount];
        
        UIImageView* linebottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        linebottom.backgroundColor = BG_GRAY_COLOR;
        [self addSubview:linebottom];
        
    }
    return self;
}

- (void)newAction
{
    if(delegate)
    {
        [delegate btnHomeClick:0];
    }
}

- (void)showAction
{
    if(delegate)
    {
        [delegate btnHomeClick:1];
    }
}

- (void)buyAction
{
    if(delegate)
    {
        [delegate btnHomeClick:2];
    }
}

- (void)accountAction
{
    if(delegate)
    {
        [delegate btnHomeClick:3];
    }
}

@end
