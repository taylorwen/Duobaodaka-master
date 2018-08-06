//
//  MineUnshowOrderCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineUnshowOrderCell.h"
#import "WenzhanTool.h"
#import "MineShowOrderModel.h"

@interface MineUnshowOrderCell ()
{
    __weak id<MineShowOrderDelegate> delegate;
    UIImageView     *imgPro;
    
    UILabel         *lblTitle;
    UILabel         *lblAllNeed;    //总需人次
    UILabel         *lblContent;   //幸运号码
    UILabel         *lblTime;       //揭晓时间
    UILabel         *lblState;
    UILabel         *lblFufen;
    
    MineUnshowOrderItem*     myItem;
}
@end

@implementation MineUnshowOrderCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, mainWidth - 120, 20)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:13];
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.numberOfLines = 1;
        [self addSubview:lblTitle];
        
        lblAllNeed = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, mainWidth - 120, 15)];
        lblAllNeed.textColor = [UIColor lightGrayColor];
        lblAllNeed.font = [UIFont systemFontOfSize:11];
        lblAllNeed.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblAllNeed];
        
        lblContent = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, mainWidth-120, 15)];
        lblContent.font = [UIFont systemFontOfSize:11];
        lblContent.textColor = [UIColor lightGrayColor];
        lblContent.numberOfLines = 1;
        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblContent];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, mainWidth - 120, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblTime];
        
        UIButton* sOrder = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-70, 68, 60, 25)];
        [sOrder setTitle:@"立即晒单" forState:UIControlStateNormal];
        [sOrder setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sOrder.layer.borderWidth = 0.5;
        sOrder.layer.borderColor = [UIColor redColor].CGColor;
        sOrder.layer.cornerRadius = 10;
        sOrder.titleLabel.font = [UIFont systemFontOfSize:14];
        [sOrder addTarget:self action:@selector(goToShowOrder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sOrder];
    }
    return self;
}

- (void)setMyOrder:(MineUnshowOrderItem*)item
{
    if (!item)
    {
        return;
    }
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
    lblAllNeed.text = [NSString stringWithFormat:@"总需：%@人次 本期已参与%@人次",item.zongrenshu,item.gonumber];
    
    lblContent.text = [NSString stringWithFormat:@"幸运号码：%@",item.q_user_code];
    lblTime.text    = [NSString stringWithFormat:@"揭晓时间：%@",[WenzhanTool formateDateStr:item.q_end_time]];
    
}

- (void)goToShowOrder
{
    if (delegate) {
        [delegate goToShowOrderAction:myItem];
    }
}

@end