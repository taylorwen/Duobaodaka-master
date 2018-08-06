//
//  CartEmptyView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartEmptyView.h"
#import "LoginVC.h"

@interface CartEmptyView ()
{
    __weak id<CartEmptyViewDelegate> delegate;
}

@end
@implementation CartEmptyView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((mainWidth - 80 ) / 2, (mainHeight-80-64-49)/2-50, 80, 80)];
        img.image = [UIImage imageNamed:@"empty_cart"];
        [self addSubview:img];
        
        [[UserInstance ShardInstnce] isUserStillOnline];

        UILabel* lab = [[UILabel alloc] init];
        
        lab.text = @"英明威武的小主，你咋还未夺宝涅？";
        
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        CGSize s = [lab.text textSizeWithFont:lab.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lab.frame = CGRectMake((mainWidth - s.width) / 2, (mainHeight-80-64-49)/2+80-40, s.width, s.height);
        [self addSubview:lab];
        
        
        UIButton *login = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth / 4, (mainHeight-80-64-49)/2+80, mainWidth/2, 40)];
        login.backgroundColor = mainColor;
        login.layer.cornerRadius = 4.5;
        [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [login addTarget:self action:@selector(btnDoLogin) forControlEvents:UIControlEventTouchUpInside];
       
        [login setTitle:@"马上夺宝" forState:UIControlStateNormal];
        [self addSubview:login];
    }
    return self;
}

- (void)setEmpty
{
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[UserInstance ShardInstnce] isUserStillOnline];
}

- (void)btnDoLogin
{
    NSLog(@"do login with user!");
    [delegate doLogin];
    
}

@end
