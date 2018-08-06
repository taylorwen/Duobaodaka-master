//
//  PayproCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/20.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PayproCell.h"

@interface PayproCell ()
{
    
    CartItem    *myItem;
    
    UIImageView *imgPro;
    UIImageView* imgrmb;
    UILabel     *lblTitle;
    __block UILabel     *lblLeft;
    __block UILabel     *lblCount;
    NSString    *lblYunjiage;
 
}
@end

@implementation PayproCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* linebottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59, mainWidth, 1)];
        linebottom.backgroundColor = BG_GRAY_COLOR;
        [self addSubview:linebottom];
        
        imgrmb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgrmb.image = [UIImage imageNamed:@"tenrmb"];
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 2;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, mainWidth-150, 15)];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.numberOfLines = 1;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:lblTitle];
        
        lblCount = [[UILabel alloc] initWithFrame:CGRectMake(60, 38, 200, 12)];
        lblCount.textAlignment = NSTextAlignmentLeft;
        lblCount.font = [UIFont systemFontOfSize:11];
        lblCount.textColor = [UIColor lightGrayColor];
        [self addSubview:lblCount];
        
        lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 90, 11, 80, 22)];
        lblLeft.textAlignment = NSTextAlignmentRight;
        lblLeft.font = [UIFont systemFontOfSize:12];
        lblLeft.textColor = [UIColor lightGrayColor];
        [self addSubview:lblLeft];
        
    }
    return self;
}

- (void)setCart:(CartItem*)item
{
    if (!item)
    {
        return;
    }
    myItem = item;
    [imgPro setImage_oy:nil image:item.thumb];
    if ([item.yunjiage intValue] == 10)
    {
        [self addSubview:imgrmb];
    }
    else
    {
        [imgrmb removeFromSuperview];
    }
    
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
    lblYunjiage = item.gonumber;
    lblCount.text = [NSString stringWithFormat:@"已参与%@人次",lblYunjiage];
    lblLeft.text = [NSString stringWithFormat:@"共%d夺宝币",[item.gonumber intValue]*[item.yunjiage intValue]];
}

@end
