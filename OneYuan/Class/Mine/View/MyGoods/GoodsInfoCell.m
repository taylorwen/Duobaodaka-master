//
//  GoodsInfoCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "GoodsInfoCell.h"

@interface GoodsInfoCell ()
{
    UIImageView*    proImg;
    UILabel*        title;
    UILabel*        lblNeedsNum;
    UILabel*        lblPati;
    UILabel*        lblLukyNo;
    UILabel*        lblLotteryT;
}
@end

@implementation GoodsInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        proImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 90, 90)];
        proImg.image = [UIImage imageNamed:@"iphone"];
        proImg.layer.masksToBounds = YES;
        proImg.layer.cornerRadius = 5;
        proImg.layer.borderColor = myLineColor.CGColor;
        proImg.layer.borderWidth = 0.5;
        [self addSubview:proImg];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, mainWidth-130, 20)];
        title.textColor = [UIColor grayColor];
        title.font = [UIFont systemFontOfSize:16];
        title.text = @"16GB iPhone6 金色版";
        [self addSubview:title];
        
        lblNeedsNum = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, mainWidth-130, 20)];
        lblNeedsNum.textColor = [UIColor grayColor];
        lblNeedsNum.font = [UIFont systemFontOfSize:12];
        lblNeedsNum.text = @"总需人次：6888";
        [self addSubview:lblNeedsNum];
        
        lblPati = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, mainWidth-130, 20)];
        lblPati.textColor = [UIColor grayColor];
        lblPati.font = [UIFont systemFontOfSize:12];
        lblPati.text = @"本期参与：250 人次";
        [self addSubview:lblPati];
        
        lblLukyNo = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, mainWidth-130, 20)];
        lblLukyNo.textColor = [UIColor grayColor];
        lblLukyNo.font = [UIFont systemFontOfSize:12];
        lblLukyNo.text = @"幸运号码：10000231";
        [self addSubview:lblLukyNo];
        
        lblLotteryT = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, mainWidth-130, 20)];
        lblLotteryT.textColor = [UIColor grayColor];
        lblLotteryT.font = [UIFont systemFontOfSize:12];
        lblLotteryT.text = @"揭晓时间：1990.09.23 12:23:04";
        [self addSubview:lblLotteryT];
        
    }
    return self;
}

- (void)setGoodsItem:(MineMyOrderItem*)item
{
    if (!item) {
        return;
    }
    [proImg setImage_oy:oyImageBaseUrl image:item.thumb];
    title.text = [NSString stringWithFormat:@"(第%@期) %@",item.qishu, item.title ];
    lblNeedsNum.text = [NSString stringWithFormat:@"总需人次：%@",item.zongrenshu];
    lblPati.text = [NSString stringWithFormat:@"本期已参与 %@ 人次",item.gonumber];
    lblLukyNo.text = [NSString stringWithFormat:@"幸运号码：%@",item.q_user_code];
    lblLotteryT.text = [NSString stringWithFormat:@"揭晓时间：%@",[WenzhanTool formateDateStr:item.q_end_time]];
    
    
    
}
@end
