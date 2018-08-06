//
//  ProductLotteryTopCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLotteryTopCell.h"
#import "WenzhanTool.h"

@interface ProductLotteryTopCell ()
{
    UIImageView *imgPro;
    UILabel     *lblTitle;
    UILabel     *lblPrice;
    UILabel     *lblNumber;
    
    
    UIImageView *imgHead;
    UIImageView *imgline;
    UILabel     *lblName;
    UILabel     *lblArea;
    UILabel     *lblBtime;
    UILabel     *lblRtime;
    
    UIButton    *image;
}
@end

@implementation ProductLotteryTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, mainWidth-200, mainWidth-200)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        image = [[UIButton alloc]initWithFrame:CGRectMake(10, mainWidth-105-80, 50, 20)];
        image.backgroundColor = [UIColor hexFloatColor:@"1b9f40"];
        image.layer.borderColor = [[UIColor hexFloatColor:@"ff3131"]CGColor];
        image.layer.borderWidth = 0.5;
        image.layer.cornerRadius = 3;
        [image setTitle:@"进行中" forState:UIControlStateNormal];
        image.titleLabel.font = [UIFont systemFontOfSize: 13];
        image.titleLabel.textColor = [UIColor whiteColor];
        image.userInteractionEnabled = NO;
        [self addSubview:image];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, mainWidth-110-80, mainWidth - 75, 30)];
        lblTitle.textColor = [UIColor hexFloatColor:@"666666"];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.numberOfLines = 2;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, mainWidth - 75-80, mainWidth - 20, 14)];
        lblPrice.textColor = [UIColor hexFloatColor:@"666666"];
        lblPrice.font = [UIFont systemFontOfSize:11];
        lblPrice.lineBreakMode = NSLineBreakByWordWrapping;
        lblPrice.numberOfLines = 2;
        lblPrice.text = @"总需人次：";
        [self addSubview:lblPrice];
        
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(70, mainWidth - 75-80, 200, 15)];
        lblNumber.textColor = mainColor;
        lblNumber.font = [UIFont systemFontOfSize:14];
        lblNumber.lineBreakMode = NSLineBreakByWordWrapping;
        lblNumber.numberOfLines = 2;
        [self addSubview:lblNumber];
        
    }
    return self;
}

- (void)setLottery:(ProductInfo *)lottery child:(ProductInfoChild*)infoChild
{
    if(!lottery)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:lottery.thumb];
    
    NSString* str = lottery.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",lottery.qishu,myStr] ;
    lblNumber.text = lottery.zongrenshu;
    
    if ([lottery.shengyutime intValue] > 0)
    {
        image.titleLabel.text = @"倒计时";
//        image.backgroundColor = [UIColor hexFloatColor:@"ff6c13"];
        image.layer.borderColor = [[UIColor hexFloatColor:@"5599ff"]CGColor];
    }
    else
    {
        image.titleLabel.text = @"已揭晓";
//        image.backgroundColor = [UIColor hexFloatColor:@"1b9f40"];
        image.layer.borderColor = [[UIColor hexFloatColor:@"137d30"]CGColor];
    }
}
@end
