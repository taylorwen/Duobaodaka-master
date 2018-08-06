//
//  PersonOrderCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/9/1.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonOrderCell.h"


@interface PersonOrderCell ()
{
    __weak id<PersonOrderCellDelegate> delegate;
    
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    
    UILabel         *lblCode;
    UILabel         *lblTime;
    UILabel*        renci;
    
    int             myOrderId;
    MineMyOrderItem*    myItem;
}
@end
@implementation PersonOrderCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 85, 85)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        UILabel *benqi = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, mainWidth - 100, 15)];
        benqi.text = @"本期参与人次：";
        benqi.textColor = [UIColor lightGrayColor];
        benqi.font = [UIFont systemFontOfSize:12];
        [self addSubview:benqi];
        
        renci = [[UILabel alloc] initWithFrame:CGRectMake(195, 50, mainWidth - 100, 15)];
        renci.textColor = mainColor;
        renci.font = [UIFont systemFontOfSize:12];
        [self addSubview:renci];
        
        UILabel* lblC = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 100, 15)];
        lblC.text = @"幸运夺宝码：";
        lblC.textColor = [UIColor lightGrayColor];
        lblC.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblC];
        
        lblCode = [[UILabel alloc] initWithFrame:CGRectMake(180, 70, 100, 15)];
        lblCode.textColor = mainColor;
        lblCode.font = lblC.font;
        [self addSubview:lblCode];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, mainWidth - 100, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = lblC.font;
        [self addSubview:lblTime];
        
    }
    return self;
}

- (void)setPersonOrder:(MineMyOrderItem *)item
{
    if(!item)
        return;
    myOrderId = [item.pid intValue];
    myItem = item;
    [imgPro setImage_oy:oyImageBaseUrl image:item.thumb];
    
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0)
    {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",item.qishu,myStr];
    renci.text = item.gonumber;
    lblCode.text = item.huode;
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@",[WenzhanTool formateDateStr:item.q_end_time]];
    
}

@end
