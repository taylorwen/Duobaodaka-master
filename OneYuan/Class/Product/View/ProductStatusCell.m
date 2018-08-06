//
//  ProductStatusCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/7.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductStatusCell.h"

@interface ProductStatusCell ()
{
    __block UILabel     *lblStatus;
}

@end
@implementation ProductStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* vvv = [[UIView alloc]initWithFrame:CGRectMake(10, 10, mainWidth -20, 44)];
        vvv.backgroundColor = BG_GRAY_COLOR;
        vvv.layer.cornerRadius = 5;
        [self addSubview:vvv];
        
        lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainWidth-20, 44)];
        lblStatus.textColor = [UIColor hexFloatColor:@"666666"];
        lblStatus.font = [UIFont systemFontOfSize:17];
        lblStatus.textAlignment = NSTextAlignmentCenter;
        [vvv addSubview:lblStatus];
    }
    return self;
}

- (void)setStatus:(NSArray *)item
{
    if (![UserInstance ShardInstnce].uid)
    {
        lblStatus.text = @"你还没有注册登录，注册登录吧";
    }
    else
    {
        if (item.count == 0) {
            lblStatus.text = @"你还没有参与本次夺宝哦";
        }else
        {
            lblStatus.text = [NSString stringWithFormat:@"本期您累计参与%lu次,点击查看夺宝码",(unsigned long)item.count];
        }
    }
    
}
@end
