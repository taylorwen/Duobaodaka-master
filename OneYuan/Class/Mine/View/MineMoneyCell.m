//
//  MineMoneyCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMoneyCell.h"
#import "WenzhanTool.h"
#import "AttributedLabel.h"

@interface MineMoneyCell ()
{
    UILabel* lblType;
    UILabel* lblTime;
    UILabel* lblSource;
    UILabel* lblMoney;
    
    UILabel* lblAmount;
    UIImageView*typeImg;
}

@end

@implementation MineMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 13)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, mainWidth, 0.5)];
        line.backgroundColor = myLineColor;
        [self addSubview:line];
        
        typeImg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 42, 45, 45)];
        [self addSubview:typeImg];

        lblSource = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 200, 45)];
        lblSource.textColor = [UIColor grayColor];
        lblSource.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblSource];
        
        lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth-200, 42, 180, 45)];
        lblAmount.textColor = mainColor;
        lblAmount.font = [UIFont systemFontOfSize:15];
        lblAmount.textAlignment = NSTextAlignmentRight;
        [self addSubview:lblAmount];
    }
    return self;
}

- (void)setMoney:(MineMoneyInItem *)money
{
    //时间戳转换时间
    lblTime.text = [NSString stringWithFormat:@"%@",[WenzhanTool formateDateStr:money.time]];
    
    lblSource.text = [NSString stringWithFormat:@"%@",money.content];
    if ([money.content isEqualToString:@"充值"]) {
        lblAmount.text = [NSString stringWithFormat:@"+%@.00",money.money];
        typeImg.image = [UIImage imageNamed:@"chongzhi"];
    }
    else if ([money.content isEqualToString:@"充值大咖网盘"])
    {
        lblAmount.text = [NSString stringWithFormat:@"+%@.00",money.money];
        typeImg.image = [UIImage imageNamed:@"chongzhi"];
    }
    else if ([money.content isEqualToString:@"管理员修改金额"])
    {
        lblAmount.text = [NSString stringWithFormat:@"+%@.00",money.money];
        typeImg.image = [UIImage imageNamed:@"chongzhi"];
    }
    else
    {
        lblAmount.text = [NSString stringWithFormat:@"-%@.00",money.money];
        typeImg.image = [UIImage imageNamed:@"duobao"];
    }
}
@end
