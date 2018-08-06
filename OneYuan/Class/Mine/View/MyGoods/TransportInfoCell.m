//
//  TransportInfoCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TransportInfoCell.h"

@interface TransportInfoCell ()
{
    UILabel* lblCom;
    UILabel* lblTranCode;
    UIButton* btnTranCheck;
    __weak id<TransportInfoCellDelegate> delegate;
    MineMyOrderTrans*       itemTran;
    
}
@end
@implementation TransportInfoCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* lblComm = [[UILabel alloc]initWithFrame:   CGRectMake(20, 0, mainWidth-40, 30)];
        lblComm.textColor = [UIColor grayColor];
        lblComm.font = [UIFont systemFontOfSize:14];
        lblComm.text = @"物流公司：";
        [self addSubview:lblComm];
        
        lblCom = [[UILabel alloc]initWithFrame:             CGRectMake(100, 0, mainWidth-40, 30)];
        lblCom.textColor = [UIColor grayColor];
        lblCom.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblCom];
        
        UILabel* lbltranmmm = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, mainWidth-40, 30)];
        lbltranmmm.textColor = [UIColor grayColor];
        lbltranmmm.font = [UIFont systemFontOfSize:14];
        lbltranmmm.text = @"运单号码：";
        [self addSubview:lbltranmmm];
        
        lblTranCode = [[UILabel alloc]initWithFrame:        CGRectMake(100, 30, mainWidth-40, 30)];
        lblTranCode.textColor = [UIColor grayColor];
        lblTranCode.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblTranCode];
        
        btnTranCheck = [[UIButton alloc]initWithFrame:      CGRectMake(mainWidth-90, 15, 80, 30)];
        [btnTranCheck setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnTranCheck setTitle:@"物流查询" forState:UIControlStateNormal];
        btnTranCheck.titleLabel.font = [UIFont systemFontOfSize:14];
        btnTranCheck.layer.borderColor = [UIColor redColor].CGColor;
        btnTranCheck.layer.borderWidth = 0.5;
        btnTranCheck.layer.cornerRadius = 15;
        [btnTranCheck addTarget:self action:@selector(checkoutTransportInfoClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setTrans:(MineMyOrderTrans*)item
{
    if (!item) {
        return;
    }
    itemTran = item;
    //快递公司代号
//    NSString*   expressS;
    if ([item.kuaidi_jianxie       isEqualToString:@"jd"]) {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"shunfeng"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"tiantian"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"zhongtong"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"zhaijisong"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"debangwuliu"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"yuantong"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"yunda"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"youzhengguonei"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"shentong"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"dbdk"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%d",0];
    }
    else if ([item.kuaidi_jianxie  isEqualToString:@"ems"])
    {
        lblCom.text = [NSString stringWithFormat:@"%@",item.kuaidi_zhongwen];
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
        [self addSubview:btnTranCheck];
    }
    else
    {
        lblCom.text = @"暂无物流信息";
        lblTranCode.text = [NSString stringWithFormat:@"%@",item.kuaidi_hao];
//        [self addSubview:btnTranCheck];
    }
    
    
}

- (void)checkoutTransportInfoClicked
{
    if (delegate) {
        [delegate btnCheckTranAction:itemTran];
    }
}
@end
