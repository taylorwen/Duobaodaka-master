//
//  PersonLotteryCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonLotteryCell.h"

@interface PersonLotteryCell ()
{
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    
    UILabel         *lblNum;
    UILabel         *lblRC;
    
    UILabel         *lbl;
    
    NSTimer         *timer;
    UILabel         *lblTime;
    UILabel         *lblTime1;
    UILabel         *lblTime2;
    UIImageView     *imgTimeBG;
    UIImageView     *imgTimeBG1;
    UIImageView     *imgTimeBG2;
    UILabel         *point;
    UILabel         *point1;
    NSInteger       nowSeconds;
    UILabel         *btnLottery;
    
}
@end
@implementation PersonLotteryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        UIImageView  *imgProBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgPro.frame.size.height - 20, 90, 20)];
        imgProBg.backgroundColor = mainColor;
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        lbl = [[UILabel alloc] init];
        lbl.text = @"揭晓中";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:11];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
        lbl.frame = CGRectMake((90 - s.width) / 2, 90-(20 - s.height )/2 - s.height, s.width, s.height);
        [imgPro addSubview:lbl];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 100, 13)];
        lbl1.text = @"TA已参与";
        lbl1.textColor = [UIColor lightGrayColor];
        lbl1.font = [UIFont systemFontOfSize:11];
        [self addSubview:lbl1];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(160, 55, 100, 13)];
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblNum];
        
        lblRC = [[UILabel alloc] init];
        lblRC.text = @"人次";
        lblRC.textColor = [UIColor lightGrayColor];
        lblRC.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblRC];
        
        
        btnLottery = [[UILabel alloc] initWithFrame:CGRectMake(110, 76, 200, 30)];
        btnLottery.text = @"正在揭晓中，点击查看详情";
        btnLottery.textColor = mainColor;
        btnLottery.font = [UIFont systemFontOfSize:14];
        [self addSubview:btnLottery];
        
    }
    return self;
}

- (void)setLottery:(MineMyBuyItem*)item
{
    if(!item || !item.thumb)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:item.thumb];
    
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",item.qishu,myStr];
    lblNum.text = [NSString stringWithFormat:@"%@",item.gonumber];
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblRC.frame = CGRectMake(160 + s.width + 5, 55, 100, 13);
}
@end
