//
//  NewestingCollCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/3.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "NewestingCollCell.h"
#define imgHeight   80
@interface NewestingCollCell ()
{
    __weak id<NewestProRefreshDelegate> delegate;
    UIImageView *imgProduct;
    UILabel     *lblTitle;
    UILabel     *lblPrice;
    
    NSTimer     *timer;
    UILabel     *lblTime;
    UILabel     *lblTime1;
    UILabel     *lblTime2;
    UIImageView *imgTimeBG;
    UIImageView *imgTimeBG1;
    UIImageView *imgTimeBG2;
    UILabel     *point;
    UILabel     *point1;
    UILabel     *point2;
    
    
    NSInteger    nowSeconds;
}
@end

@implementation NewestingCollCell
@synthesize delegate;
- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

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
        
        imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, self.bounds.size.width - 60, self.bounds.size.width - 60)];
        imgProduct.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgProduct];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:11];
        lblTitle.textColor = wordColor;
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:10];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        UIImageView* clock = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.bounds.size.width + 8-15, 15, 15)];
        clock.image = [UIImage imageNamed:@"clock"];
        [self addSubview:clock];
        
        UILabel* countdown = [[UILabel alloc]initWithFrame:CGRectMake(28, self.bounds.size.width + 9-15, 60, 15)];
        countdown.text = @"即将揭晓";
        countdown.textColor = wordColor;
        countdown.font = [UIFont systemFontOfSize:10];
        [self addSubview:countdown];
        
        imgTimeBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.width + 28-15, 40, 30)];
        imgTimeBG.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBG.layer.cornerRadius = 3;
        [self addSubview:imgTimeBG];
        
        point = [[UILabel alloc] initWithFrame:CGRectMake(10+40, self.bounds.size.width + 28-15, 10, 30)];
        point.font = [UIFont systemFontOfSize:25];
        point.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        point.text = @":";
        point.textAlignment = NSTextAlignmentCenter;
        [self addSubview:point];
        
        imgTimeBG1 = [[UIImageView alloc] initWithFrame:CGRectMake(10+50, self.bounds.size.width + 28-15, 40, 30)];
        imgTimeBG1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBG1.layer.cornerRadius = 3;
        [self addSubview:imgTimeBG1];
        
        point1 = [[UILabel alloc] initWithFrame:CGRectMake(10+90, self.bounds.size.width + 28-15, 10, 30)];
        point1.font = [UIFont systemFontOfSize:20];
        point1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        point1.text = @":";
        point1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:point1];
        
        imgTimeBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+100, self.bounds.size.width + 28-15, 40, 30)];
        imgTimeBG2.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBG2.layer.cornerRadius = 3;
        [self addSubview:imgTimeBG2];
        
        lblTime = [[UILabel alloc] init];
        lblTime.font = [UIFont systemFontOfSize:25];
        lblTime.textColor = mainColor;
        lblTime.text = @"00:00:00";
        [imgTimeBG addSubview:lblTime];
        
        lblTime1 = [[UILabel alloc] init];
        lblTime1.font = [UIFont systemFontOfSize:25];
        lblTime1.textColor = mainColor;
        lblTime1.text = @"00:00:00";
        [imgTimeBG1 addSubview:lblTime1];
        
        lblTime2 = [[UILabel alloc] init];
        lblTime2.font = [UIFont systemFontOfSize:25];
        lblTime2.textColor = mainColor;
        lblTime2.text = @"00:00:00";
        [imgTimeBG2 addSubview:lblTime2];
    }
    return self;
}

- (void)setNewesting:(NewestProItme *)newing
{

    [imgProduct setImage_oy:oyImageBaseUrl image:newing.thumb];
    
    NSString* str = newing.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0)
    {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = myStr;
    NSString* title = [NSString stringWithFormat:@"(第%@期)%@",newing.qishu,myStr];
    lblTitle.text = title;

    lblTitle.frame = CGRectMake(10, self.bounds.size.width - 52, self.bounds.size.width - 20, 30);
    
    lblPrice.text = [NSString stringWithFormat:@"总需人次:%@",newing.zongrenshu];
    lblPrice.frame = CGRectMake(10, self.bounds.size.width - 32, self.bounds.size.width - 20, 30);
    
    if ([newing.shengyutime intValue] <= 0)
    {
        lblTime.text = @"已揭晓...";
        return;
    }
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    nowSeconds = [newing.shengyutime integerValue] * 100;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if(nowSeconds < 0)
    {
        [timer invalidate];
        timer = nil;
        return;
    }
    nowSeconds--;
    if(nowSeconds <= 0)
    {
        if (delegate) {
            [delegate NewestingTriggerRefresh];
        }
        lblTime.text = @"已揭晓...";
        
        CGSize sss = [lblTime.text textSizeWithFont:lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        lblTime.frame = CGRectMake((imgTimeBG.frame.size.width - sss.width) / 2,  self.bounds.size.width + 20-15, sss.width, sss.height);
        
        return;
    }
    int m = (int)nowSeconds / 6000;
    NSString* f0 = m > 9 ? [NSString stringWithFormat:@"%d",m] : [@"0" stringByAppendingFormat:@"%d",m];
    int s = (int)(nowSeconds/100) - m*60;
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = nowSeconds % 100;
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    
    lblTime.text = [NSString stringWithFormat:@"%@",f0];
    CGSize sss = [lblTime.text textSizeWithFont:lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTime.frame = CGRectMake((imgTimeBG.frame.size.width - sss.width) / 2, (imgTimeBG.frame.size.height - sss.height) /2, sss.width, sss.height);
    
    lblTime1.text = [NSString stringWithFormat:@"%@",f1];
    CGSize sss1 = [lblTime1.text textSizeWithFont:lblTime1.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTime1.frame = CGRectMake((imgTimeBG1.frame.size.width - sss.width) / 2, (imgTimeBG1.frame.size.height - sss1.height) /2, sss1.width, sss1.height);
    
    lblTime2.text = [NSString stringWithFormat:@"%@",f2];
    CGSize sss2 = [lblTime2.text textSizeWithFont:lblTime2.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTime2.frame = CGRectMake((imgTimeBG2.frame.size.width - sss2.width) / 2, (imgTimeBG2.frame.size.height - sss2.height) /2, sss2.width, sss2.height);
    
}

@end
