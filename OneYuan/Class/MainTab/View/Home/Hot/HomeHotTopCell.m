//
//  HomeHotTopCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeHotTopCell.h"

@implementation HomeHotTopCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //画线
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, mainWidth, 1)];
        line.backgroundColor = myLineColor;
//        [self addSubview:line];
        
        //左侧画线
        UIImageView* left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 3, 44)];
        left.backgroundColor = mainColor;
        [self addSubview:left];
        
        UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, mainWidth-80, 44)];
        title.font = [UIFont systemFontOfSize:17];
        title.textColor = [UIColor hexFloatColor:@"666666"];
        title.text = @"热门推荐";
        [self addSubview:title];
        
    }
    return self;
}
@end
