//
//  HomeCateCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/2.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeCateCell.h"

@interface HomeCateCell ()
{
    __weak id<HomeRankingCellDelegate> delegate;
    UIButton    *btnNew;
    
    UIButton    *btnShow;
    
    UIButton    *btnBuy;
    
    UIButton    *btnAccount;
    
    UIImageView* up;
    UIImageView* down;
    
    int     state;
}

@end
@implementation HomeCateCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat width = mainWidth/4;
        state = 0;
        
        btnNew = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
        [btnNew addTarget:self action:@selector(newAction) forControlEvents:UIControlEventTouchUpInside];
        [btnNew setTitle:@"最热" forState:UIControlStateNormal];
        [btnNew setTitleColor:wordColor forState:UIControlStateNormal];
        [btnNew setTitleColor:mainColor forState:UIControlStateSelected];
        btnNew.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnNew setBackgroundImage:[UIImage imageNamed:@"home_ranking_line"] forState:UIControlStateSelected];
        btnNew.selected = YES;
        [self addSubview:btnNew];
        
        btnShow = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, self.frame.size.height)];
        [btnShow addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        [btnShow setTitle:@"剩余" forState:UIControlStateNormal];
        [btnShow setTitleColor:wordColor forState:UIControlStateNormal];
        [btnShow setTitleColor:mainColor forState:UIControlStateSelected];
        btnShow.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnShow setBackgroundImage:[UIImage imageNamed:@"home_ranking_line"] forState:UIControlStateSelected];
        [self addSubview:btnShow];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(width*2, 0, width, self.frame.size.height)];
        [btnBuy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [btnBuy setTitle:@"最新" forState:UIControlStateNormal];
        [btnBuy setTitleColor:wordColor forState:UIControlStateNormal];
        [btnBuy setTitleColor:mainColor forState:UIControlStateSelected];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"home_ranking_line"] forState:UIControlStateSelected];
        [self addSubview:btnBuy];
        
        btnAccount = [[UIButton alloc] initWithFrame:CGRectMake(width*3, 0, width, self.frame.size.height)];
        [btnAccount addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
        [btnAccount setTitle:@"总需" forState:UIControlStateNormal];
        [btnAccount setTitleColor:wordColor forState:UIControlStateNormal];
        [btnAccount setTitleColor:mainColor forState:UIControlStateSelected];
        btnAccount.titleLabel.font = [UIFont systemFontOfSize:12];
        btnAccount.tag = 100;
        [btnAccount setBackgroundImage:[UIImage imageNamed:@"home_ranking_line"] forState:UIControlStateSelected];
        [self addSubview:btnAccount];
        
        [self initCateUI];
    }
    return self;
}

- (void)initCateUI
{
    up = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth- 22, 10, 10, 6)];
    up.image = [UIImage imageNamed:@"zongxu_up"];
    [self addSubview:up];
    
    down = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth-22, 20, 10, 6)];
    down.image = [UIImage imageNamed:@"zongxu_down"];
    [self addSubview:down];
}

- (void)newAction
{
    btnNew.selected = YES;
    btnShow.selected = NO;
    btnBuy.selected = NO;
    btnAccount.selected = NO;
    up.image = [UIImage imageNamed:@"zongxu_up"];
    down.image = [UIImage imageNamed:@"zongxu_down"];
    if(delegate)
    {
        [delegate btnHomeRankingClick:0];
    }
}

- (void)showAction
{
    btnNew.selected = NO;
    btnShow.selected = YES;
    btnBuy.selected = NO;
    btnAccount.selected = NO;
    up.image = [UIImage imageNamed:@"zongxu_up"];
    down.image = [UIImage imageNamed:@"zongxu_down"];
    if(delegate)
    {
        [delegate btnHomeRankingClick:1];
    }
}

- (void)buyAction
{
    btnNew.selected = NO;
    btnShow.selected = NO;
    btnBuy.selected = YES;
    btnAccount.selected = NO;
    up.image = [UIImage imageNamed:@"zongxu_up"];
    down.image = [UIImage imageNamed:@"zongxu_down"];
    if(delegate)
    {
        [delegate btnHomeRankingClick:2];
    }
}

- (void)accountAction
{
    btnNew.selected = NO;
    btnShow.selected = NO;
    btnBuy.selected = NO;
    btnAccount.selected = YES;
    if (state == 0) {
        [down setImage:[UIImage imageNamed:@"zongxu_red_down"]];
        [up setImage:[UIImage imageNamed:@"zongxu_up"]];
        state = 1;
        if(delegate)
        {
            [delegate btnHomeRankingClick:4];
        }
    }else{
        [down setImage:[UIImage imageNamed:@"zongxu_down"]];
        [up setImage:[UIImage imageNamed:@"zongxu_red_up"]];
        state = 0;
        if(delegate)
        {
            [delegate btnHomeRankingClick:3];
        }
    }
    
}
@end
