//
//  MineOrderCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineOrderCell.h"
#import "WenzhanTool.h"

@interface MineOrderCell ()
{
    __weak id<MineMyOrderCellDelegate> delegate;
    
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    
    UILabel         *lblCode;
    UILabel         *lblTime;
    UILabel*        renci;
    
    UIButton        *btnState;
    UIButton        *btnOpt;
    UIButton        *btnDetail;
    
    int             myOrderId;
    MineMyOrderItem*    myItem;
}
@end

@implementation MineOrderCell
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
        lblTitle.font = [UIFont systemFontOfSize:12];
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
        
        btnState = [[UIButton alloc] initWithFrame:CGRectMake(15, 98, 85, 15)];
        btnState.layer.cornerRadius = 3;
        btnState.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:btnState];
        
        btnOpt = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth-90, 50, 80, 25)];
        btnOpt.layer.cornerRadius = 3;
        btnOpt.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:btnOpt];
        
        btnDetail = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-70, 90, 60, 15)];
        btnDetail.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnDetail setTitle:@"查看详情" forState:UIControlStateNormal];
        [btnDetail setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnDetail setBackgroundColor:myLineColor];
        [self addSubview:btnDetail];
        
    }
    return self;
}

- (void)setMyOrder:(MineMyOrderItem *)item
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
    
    btnState.hidden = YES;
    btnOpt.hidden = YES;
    btnDetail.hidden = YES;
    [btnOpt removeTarget:self action:@selector(confirmOrder)    forControlEvents:UIControlEventTouchUpInside];
    [btnOpt removeTarget:self action:@selector(confirmShip)     forControlEvents:UIControlEventTouchUpInside];
    [btnOpt removeTarget:self action:@selector(showOrder)       forControlEvents:UIControlEventTouchUpInside];
    
    if ([item.go_status intValue] == 0) {
        [btnState setHidden:NO];
        [btnState setTitle:@"已夺宝" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if([item.go_status intValue] == 1)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"待确认地址" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"确认地址" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([item.go_status intValue] == 2)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"确认收货地址" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"待发货" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(confirmShip) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([item.go_status intValue] == 3)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"已发货" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"查看物流" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(confirmShip) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([item.go_status intValue] == 4)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"订单已完成" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"查看晒单详情" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
        
        [btnDetail setHidden:NO];
        [btnDetail addTarget:self action:@selector(showGoodDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"已晒单" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnDetail setHidden:NO];
        [btnDetail addTarget:self action:@selector(showGoodDetail) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma delegate;
//确认收货地址
- (void)confirmOrder
{
    if(delegate)
    {
        [delegate confirmOrder:myItem];
    }
}
- (void)confirmShip
{
    if(delegate)
    {
        [delegate confirmShip:myItem];
    }
}

//去晒单页面
- (void)showOrder
{
    if (delegate) {
        [delegate checkShowOrder:myItem];
    }
}

- (void)showGoodDetail
{
    if (delegate) {
        [delegate confirmShip:myItem];
    }
}
@end
