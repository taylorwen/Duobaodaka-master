//
//  MineLoginView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineLoginView.h"
#import "LoginVC.h"

@interface MineLoginView ()
{
    __weak id<MineLoginViewDelegate> delegate;
}
@end

@implementation MineLoginView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = @"欢迎来到夺宝大咖";
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:14];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl.frame = CGRectMake((mainWidth - s.width)/2, 20, s.width, s.height);
        [self addSubview:lbl];
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth -150 )/2, 50, 150, 44)];
        [btn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:mainColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 4.5;
        btn.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
        [btn addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel* lbl1 = [[UILabel alloc] init];
        lbl1.text = @"本软件内所有奖品抽奖活动与苹果公司(Apple Inc.)无关";
        lbl1.textColor = [UIColor redColor];
        lbl1.font = [UIFont systemFontOfSize:13];
        lbl1.frame = CGRectMake(10, 104, mainWidth-20, 40);
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.numberOfLines = 2;
        lbl1.textAlignment = NSTextAlignmentCenter;
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"0"])
        {
            [self addSubview:lbl1];
        }
    }
    return self;
}

- (void)btnLoginAction
{
    [delegate doLogin];
}
@end
