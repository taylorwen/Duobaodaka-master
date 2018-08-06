//
//  NewestedCollCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "NewestedCollCell.h"

@interface NewestedCollCell ()
{
    UIImageView *imgProduct;
    UILabel* lblTitle;
    
    UILabel* lblhuojiang;
    UILabel* lblUser;
    
    UILabel* lblxingyun;
    UILabel* lblmobile;
    
    UILabel* lblcanyu;
    UILabel* lblgonumber;
    
    UILabel* jiexiao;
    UILabel* lbltime;
}
@end

@implementation NewestedCollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* lineTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth/2, 0.5)];
        lineTop.backgroundColor = myLineColor;
        [self addSubview:lineTop];
        
        UIImageView* lineRight = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2-0.5, 0, 0.5, mainWidth/2+70)];
        lineRight.backgroundColor = myLineColor;
        [self addSubview:lineRight];
        
        imgProduct = [[UIImageView alloc] init];
        imgProduct.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgProduct];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:11];
        lblTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:lblTitle];
        
        lblhuojiang = [[UILabel alloc]init];
        lblhuojiang.font = [UIFont systemFontOfSize:10];
        lblhuojiang.textColor = wordColor;
        lblhuojiang.text = @"获奖用户:";
        [self addSubview:lblhuojiang];
        
        lblUser = [[UILabel alloc] init];
        lblUser.font = [UIFont systemFontOfSize:10];
        lblUser.textColor = [UIColor hexFloatColor:@"3385ff"];
        [self addSubview:lblUser];
        
        lblxingyun = [[UILabel alloc]init];
        lblxingyun.font = [UIFont systemFontOfSize:10];
        lblxingyun.textColor = wordColor;
        lblxingyun.text = @"幸运号码:";
        [self addSubview:lblxingyun];
        
        lblmobile = [[UILabel alloc] init];
        lblmobile.font = [UIFont systemFontOfSize:10];
        lblmobile.textColor = mainColor;
        [self addSubview:lblmobile];
        
        lblcanyu = [[UILabel alloc]init];
        lblcanyu.font = [UIFont systemFontOfSize:10];
        lblcanyu.textColor = wordColor;
        lblcanyu.text = @"参与次数:";
        [self addSubview:lblcanyu];
        
        lblgonumber = [[UILabel alloc] init];
        lblgonumber.font = [UIFont systemFontOfSize:10];
        lblgonumber.textColor = wordColor;
        [self addSubview:lblgonumber];
        
        jiexiao = [[UILabel alloc]init];
        jiexiao.font = [UIFont systemFontOfSize:10];
        jiexiao.textColor = wordColor;
        jiexiao.text = @"揭晓时间:";
        [self addSubview:jiexiao];
        
        lbltime = [[UILabel alloc] init];
        lbltime.font = [UIFont systemFontOfSize:10];
        lbltime.textColor = wordColor;
        [self addSubview:lbltime];
    }
    return self;
}

- (void)setNewed:(NewestProItme*)newed
{
    imgProduct.frame = CGRectMake(30, 10, self.bounds.size.width - 60, self.bounds.size.width - 60);
    [imgProduct setImage_oy:oyImageBaseUrl image:newed.thumb];
    
    NSString* str = newed.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0)
    {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@", newed.qishu,myStr];
    lblTitle.numberOfLines = 2;
    lblTitle.lineBreakMode =  NSLineBreakByWordWrapping;
    lblTitle.frame = CGRectMake(10, self.bounds.size.width - 52, self.bounds.size.width - 20, 30);
    
    lblhuojiang.frame   = CGRectMake(10, self.bounds.size.width -  7-15, 70, 15);
    lblxingyun.frame    = CGRectMake(10, self.bounds.size.width + 10-15, 70, 15);
    lblcanyu.frame      = CGRectMake(10, self.bounds.size.width + 27-15, 70, 15);
    jiexiao.frame       = CGRectMake(10, self.bounds.size.width + 44-15, 70, 15);
    
    lblUser.text = newed.username;
    lblUser.frame = CGRectMake(60, self.bounds.size.width-7-15, self.bounds.size.width - 70, 15);
    
    lblmobile.text = newed.huode;
    lblmobile.frame = CGRectMake(60, self.bounds.size.width -5, self.bounds.size.width - 70, 15);
    
    lblgonumber.text = newed.gonumber;
    lblgonumber.frame = CGRectMake(60, self.bounds.size.width + 27-15, self.bounds.size.width - 70, 15);
    
    lbltime.frame = CGRectMake(60, self.bounds.size.width + 44-15, self.bounds.size.width - 70, 15);
    //时间戳转换时间
    lbltime.text = [NSString stringWithFormat:@"%@",[WenzhanTool formateDateStr:newed.q_end_time]];
}
@end
