//
//  Product100RecodeCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/11.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "Product100RecodeCell.h"

@interface Product100RecodeCell ()
{
    UILabel* lblTime;
    UILabel* lblCode;
    UILabel* lblUsername;
}
@end

@implementation Product100RecodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 24)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
        
        lblCode = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, mainWidth-140-100, 24)];
        lblCode.textColor = [UIColor lightGrayColor];
        lblCode.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblCode];
        
        lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 80, 10, 80, 24)];
        lblUsername.textColor = [UIColor lightGrayColor];
        lblUsername.font = [UIFont systemFontOfSize:12];
        lblUsername.lineBreakMode = NSLineBreakByWordWrapping;
        lblUsername.numberOfLines = 3;
        [self addSubview:lblUsername];
        
    }
    return self;
}




-(void)setRecode:(RecodeListModel*)item
{
    lblTime.text = [WenzhanTool formateDateStr:item.time];
    lblCode.text = item.shopname;
    lblUsername.text = [NSString stringWithFormat:@"%@",item.username];
}
@end
