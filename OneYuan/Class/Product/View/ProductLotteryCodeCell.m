//
//  ProductLotteryCodeCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLotteryCodeCell.h"

@interface ProductLotteryCodeCell ()
{
    UILabel* lblTime;
    UILabel* lblCode;
    NSArray*    codeCount;
}
@end

@implementation ProductLotteryCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, mainWidth-32, 13)];
        lblTime.font = [UIFont systemFontOfSize:13];
        lblTime.textColor = [UIColor grayColor];
        [self addSubview:lblTime];
        
        lblCode = [[UILabel alloc] initWithFrame:CGRectMake((mainWidth-280)/2, 0, 280, 16)];
        lblCode.font = [UIFont systemFontOfSize:13];
        lblCode.textColor = [UIColor lightGrayColor];
        lblCode.numberOfLines = 9999;
        lblCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblCode];
        
    }
    return self;
}

- (void)setCodes:(ProductCodeBuy*)allCodes lotteryItem:(ProductInfo*)item
{
    if (!allCodes)
        return;
    if (!item)
        return;
    
    lblCode.text = allCodes.codes;
    CGSize s = [lblCode.text textSizeWithFont:lblCode.font constrainedToSize:CGSizeMake(mainWidth - 32, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblCode.frame = CGRectMake((mainWidth-260)/2, 10, 260, s.height);
}
@end
