//
//  ProductDetailGetCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductDetailGetCell.h"

@interface ProductDetailGetCell ()
{
    UIImageView     *imgUser;
    UILabel         *lblName;
    UILabel         *lblRTime;
    UILabel         *lblBTime;
    UILabel         *lblRNo;
    UILabel         *lblArea;
    UILabel         *lblBuyCount;
}
@end

@implementation ProductDetailGetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, mainWidth, 14)];
        lblTitle.text = @"上期获得者";
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblTitle];
        
        imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(16, 35, 40, 40)];
        imgUser.image = [UIImage imageNamed:@"noimage"];
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2;
        imgUser.layer.masksToBounds = YES;
        [self addSubview:imgUser];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, mainWidth - 70, 14)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblName];
        
        lblRTime = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 50, mainWidth - 70, 14)];
        lblRTime.textColor = [UIColor lightGrayColor];
        lblRTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRTime];
        
        lblBTime = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 65, mainWidth - 70, 14)];
        lblBTime.textColor = [UIColor lightGrayColor];
        lblBTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblBTime];
        
        lblBuyCount = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 14)];
        lblBuyCount.textColor = mainColor;
        lblBuyCount.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblBuyCount];
        
        
        UILabel* lblno = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x , 80, 100, 14)];
        lblno.text = @"幸运夺宝码：";
        lblno.textColor = [UIColor lightGrayColor];
        lblno.font = [UIFont systemFontOfSize:12];
        [self addSubview: lblno];
        
        lblRNo = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x + 70, 80, mainWidth - 70, 14)];
        lblRNo.textColor = mainColor;
        lblRNo.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRNo];
        
        lblArea = [[UILabel alloc] init];
        lblArea.textColor = [UIColor lightGrayColor];
        lblArea.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblArea];
    }
    return self;
}

- (void)setProDetail:(ProductInfo*)detail
{
    if(!detail)
        return;
    [imgUser setImage_oy:oyImageBaseUrl image:detail.thumb];
    
    lblName.text = detail.q_user;
    NSString* rtime = detail.time;
    lblRTime.text = [NSString stringWithFormat:@"揭晓时间：%@", rtime];
    NSString* btime = detail.time;
    lblBTime.text = [NSString stringWithFormat:@"夺宝时间：%@", btime];
    lblRNo.text = detail.time;
    
    lblBuyCount.text = [NSString stringWithFormat:@"总夺宝 %@ 人次",detail.yunjiage];
    
    CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblArea.text = [NSString stringWithFormat:@"(%@)",detail.xsjx_time];
    lblArea.frame = CGRectMake(lblName.frame.origin.x + s.width, lblName.frame.origin.y, 200, 14);
}
@end
