//
//  GoodStatusCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "GoodStatusCell.h"
#import "MineMyOrderTransModel.h"

@interface GoodStatusCell ()
{
    UIImageView* line;
    UIImageView* corner0;
    UIImageView* corner1;
    UIImageView* corner2;
    UIImageView* corner3;
    UIImageView* corner4;
    
    UILabel* lblGood;
    UILabel* lblGoodTime;
    
    UILabel* lblAddress;
    UILabel* lblAddressTime;
    
    UILabel* lblSend;
    UILabel* lblSendTime;
    
    UILabel* lblRecieve;
    UILabel* lblRecieveTime;
    
    UILabel* lblSign;
    UIButton*   btnConfirm;
    
    __weak id<GoodStatusCellDelegate> delegate;
    
}
@end

@implementation GoodStatusCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //画线
        line = [[UIImageView alloc]initWithFrame:CGRectMake(24.5, 17, 1, 186)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        //画圆
        corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17, 10, 10)];
        corner0.backgroundColor = [UIColor lightGrayColor];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 5;
        [self addSubview:corner0];
        
        corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [self addSubview:corner1];
        
        corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [self addSubview:corner2];
        
        corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [self addSubview:corner3];
        
        corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [self addSubview:corner4];
        
        lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, 200, 20)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = @"获得奖品";
        [self addSubview:lblGood];
        
        lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-210, 12, 200, 20)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = @"";
        
        lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(60, 12+44, 200, 20)];
        lblAddress.textColor = [UIColor grayColor];
        lblAddress.font = [UIFont systemFontOfSize:14];
        lblAddress.text = @"确认收货地址";
        [self addSubview:lblAddress];
        
        lblAddressTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-210, 12+44, 200, 20)];
        lblAddressTime.textColor = [UIColor grayColor];
        lblAddressTime.font = [UIFont systemFontOfSize:14];
        lblAddressTime.textAlignment = NSTextAlignmentRight;
        lblAddressTime.text = @"";
        
        lblSend = [[UILabel alloc]initWithFrame:CGRectMake(60, 12+44*2, 200, 20)];
        lblSend.textColor = [UIColor grayColor];
        lblSend.font = [UIFont systemFontOfSize:14];
        lblSend.text = @"奖品派发";
        [self addSubview:lblSend];
        
        lblSendTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-210, 12+44*2, 200, 20)];
        lblSendTime.textColor = [UIColor grayColor];
        lblSendTime.font = [UIFont systemFontOfSize:14];
        lblSendTime.textAlignment = NSTextAlignmentRight;
        lblSendTime.text = @"";
        
        lblRecieve = [[UILabel alloc]initWithFrame:CGRectMake(60, 12+44*3, 200, 20)];
        lblRecieve.textColor = [UIColor grayColor];
        lblRecieve.font = [UIFont systemFontOfSize:14];
        lblRecieve.text = @"确认收货";
        [self addSubview:lblRecieve];
        
        lblRecieveTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-210, 12+44*3, 200, 20)];
        lblRecieveTime.textColor = [UIColor grayColor];
        lblRecieveTime.font = [UIFont systemFontOfSize:14];
        lblRecieveTime.textAlignment = NSTextAlignmentRight;
        lblRecieveTime.text = @"";
        
        btnConfirm = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-90, 12+44*3-5, 80, 30)];
        [btnConfirm setTitle:@"确认收货" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnConfirm.titleLabel.font = [UIFont systemFontOfSize:14];
        btnConfirm.layer.borderWidth = 0.5;
        btnConfirm.layer.borderColor = [UIColor redColor].CGColor;
        btnConfirm.layer.cornerRadius = 15;
        [btnConfirm addTarget:self action:@selector(btnConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
        
        lblSign = [[UILabel alloc]initWithFrame:CGRectMake(60, 12+44*4, 200, 20)];
        lblSign.textColor = [UIColor grayColor];
        lblSign.font = [UIFont systemFontOfSize:14];
        lblSign.text = @"已签收";
        [self addSubview:lblSign];

    }
    return self;
}

- (void)setStatus:(NSArray*)listArr Model:(MineMyOrderTrans*)item
{
    if (listArr.count == 0) {
        return;
    }
    if (!item) {
        return;
    }
    //判断圆圈的位置
    if ([item.go_status isEqualToString:@"1"]) {
        //获得奖品
        corner0.frame = CGRectMake(15, 12, 20, 20);
        corner0.layer.cornerRadius = 10;
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
    }
    else if ([item.go_status isEqualToString:@"2"])
    {
        //确认收货地址
        corner1.frame = CGRectMake(15, 12+44, 20, 20);
        corner1.layer.cornerRadius = 10;
        corner1.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
    }
    else if ([item.go_status isEqualToString:@"3"])
    {
        
        corner2.frame = CGRectMake(15, 12+44*2, 20, 20);
        corner2.layer.cornerRadius = 10;
        corner2.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        [self addSubview:btnConfirm];
    }
    else if ([item.go_status isEqualToString:@"4"])
    {
        corner3.frame = CGRectMake(15, 12+44*3, 20, 20);
        corner3.layer.cornerRadius = 10;
        corner3.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
    }
    else if ([item.go_status isEqualToString:@"5"])
    {
        corner4.frame = CGRectMake(15, 12+44*4, 20, 20);
        corner4.layer.cornerRadius = 10;
        corner4.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
    }
    
    //判断时间数组的写入顺序
    if (listArr.count == 1) {
        //获得奖品
        MineMyOrderTransInfo* item0 = [listArr objectAtIndex:0];
        lblGoodTime.text = [WenzhanTool formateDateStr:item0.create_time];
        [self addSubview:lblGoodTime];
    }
    else if (listArr.count == 2)
    {
        //确认收货地址
        MineMyOrderTransInfo* item0 = [listArr objectAtIndex:0];
        MineMyOrderTransInfo* item1 = [listArr objectAtIndex:1];
        lblGoodTime.text = [WenzhanTool formateDateStr:item0.create_time];
        [self addSubview:lblGoodTime];
        lblAddressTime.text = [WenzhanTool formateDateStr:item1.create_time];
        [self addSubview:lblAddressTime];
    }
    else if (listArr.count == 3)
    {
        MineMyOrderTransInfo* item0 = [listArr objectAtIndex:0];
        MineMyOrderTransInfo* item1 = [listArr objectAtIndex:1];
        MineMyOrderTransInfo* item2 = [listArr objectAtIndex:2];
        lblGoodTime.text = [WenzhanTool formateDateStr:item0.create_time];
        [self addSubview:lblGoodTime];
        lblAddressTime.text = [WenzhanTool formateDateStr:item1.create_time];
        [self addSubview:lblAddressTime];
        lblSendTime.text = [WenzhanTool formateDateStr:item2.create_time];
        [self addSubview:lblSendTime];
    }
    else if (listArr.count == 4)
    {
        MineMyOrderTransInfo* item0 = [listArr objectAtIndex:0];
        MineMyOrderTransInfo* item1 = [listArr objectAtIndex:1];
        MineMyOrderTransInfo* item2 = [listArr objectAtIndex:2];
        MineMyOrderTransInfo* item3 = [listArr objectAtIndex:3];
        lblGoodTime.text = [WenzhanTool formateDateStr:item0.create_time];
        [self addSubview:lblGoodTime];
        lblAddressTime.text = [WenzhanTool formateDateStr:item1.create_time];
        [self addSubview:lblAddressTime];
        lblSendTime.text = [WenzhanTool formateDateStr:item2.create_time];
        [self addSubview:lblSendTime];
        lblRecieveTime.text = [WenzhanTool formateDateStr:item3.create_time];
        [self addSubview:lblRecieveTime];
        lblSign.textColor = [UIColor hexFloatColor:@"ebae29"];
    }
    else if (listArr.count == 5)
    {
        MineMyOrderTransInfo* item0 = [listArr objectAtIndex:0];
        MineMyOrderTransInfo* item1 = [listArr objectAtIndex:1];
        MineMyOrderTransInfo* item2 = [listArr objectAtIndex:2];
        MineMyOrderTransInfo* item3 = [listArr objectAtIndex:3];
        lblGoodTime.text = [WenzhanTool formateDateStr:item0.create_time];
        [self addSubview:lblGoodTime];
        lblAddressTime.text = [WenzhanTool formateDateStr:item1.create_time];
        [self addSubview:lblAddressTime];
        lblSendTime.text = [WenzhanTool formateDateStr:item2.create_time];
        [self addSubview:lblSendTime];
        lblRecieveTime.text = [WenzhanTool formateDateStr:item3.create_time];
        [self addSubview:lblRecieveTime];
        lblSign.textColor = [UIColor hexFloatColor:@"ebae29"];
    }
}

- (void)btnConfirmClicked
{
    if (delegate) {
        [delegate btnStatusTranAction];
    }
}
@end
