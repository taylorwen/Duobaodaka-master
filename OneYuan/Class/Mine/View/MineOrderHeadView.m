//
//  MineOrderHeadView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineOrderHeadView.h"

@interface MineOrderHeadView ()
{
    UILabel* lblNum;
    UILabel* lblP;
}
@end

@implementation MineOrderHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
        lbl.text = @"您总共获得了";
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:15];
        [self addSubview:lbl];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 100, 15)];
        lblNum.text = @"0";
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblNum];
        
        lblP = [[UILabel alloc] init];
        lblP.text = @"个奖品";
        lblP.textColor = [UIColor grayColor];
        lblP.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblP];
    }
    return self;
}

- (void)setNum:(NSInteger)num
{
    lblNum.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lblP.frame = CGRectMake(lblNum.frame.origin.x + s.width + 5, 10, 100, 15);
}
@end
