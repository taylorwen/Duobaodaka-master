//
//  PersonBuyRecordCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonBuyRecordCell.h"
#import "WenzhanTool.h"

@interface PersonBuyRecordCell ()
{
    __weak id<PersonBuyRecordCellDelegate> delegate;
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    UIButton         *btnName;
    UILabel         *lblTime;
    
    AttributedLabel*    dCishu;
    UILabel             *renci;
    MineBuyedItem*      taItem;
}
@end

@implementation PersonBuyRecordCell
@synthesize delegate;
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
        imgProBg.backgroundColor = [UIColor blackColor];
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = @"已揭晓";
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
        
        UILabel *lbln = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, mainWidth - 120, 15)];
        lbln.text = @"获得者：";
        lbln.textColor = [UIColor lightGrayColor];
        lbln.font = [UIFont systemFontOfSize:12];
        [self addSubview:lbln];
        
        btnName = [[UIButton alloc]init];
        [btnName setTitleColor:[UIColor hexFloatColor:@"3385ff"] forState:UIControlStateNormal];
        btnName.titleLabel.font = [UIFont systemFontOfSize:14];
        btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnName addTarget:self action:@selector(tapTAUserName) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnName];
        
        UILabel *benqi = [[UILabel alloc] initWithFrame:CGRectMake(110, 65, mainWidth - 100, 15)];
        benqi.text = @"本期参与人次：";
        benqi.textColor = [UIColor lightGrayColor];
        benqi.font = [UIFont systemFontOfSize:12];
        [self addSubview:benqi];
        
        renci = [[UILabel alloc] initWithFrame:CGRectMake(195, 65, mainWidth - 100, 15)];
        renci.textColor = mainColor;
        renci.font = [UIFont systemFontOfSize:12];
        [self addSubview:renci];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, mainWidth - 100, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
    }
    return self;
}

- (void)setBuyed:(MineBuyedItem*)memitem recode:(MineMyBuyItem*)item
{
    if (!memitem) {
        return;
    }
    if (!item) {
        return;
    }
    taItem = memitem;
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
    [btnName setTitle:memitem.username forState:UIControlStateNormal];
    CGSize s = [btnName.titleLabel.text textSizeWithFont:btnName.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    btnName.frame = CGRectMake(155, 45, s.width, 15);
    
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@",[WenzhanTool formateDateStr:memitem.q_end_time]];
    
    renci.text = memitem.gonumber;
}

- (void)tapTAUserName
{
    if (delegate) {
        [delegate tapTALotteryUsername:taItem.uid];
    }
}
@end
