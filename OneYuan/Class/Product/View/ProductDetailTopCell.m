//
//  ProductDetailTopCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductDetailTopCell.h"
#import "ProBuyingProgress.h"
#import "LDProgressView.h"

@interface ProductDetailTopCell ()
{
    UIImageView *imgPro;
    UILabel     *lblTitle;
    UILabel     *lblSubTitle;
    UILabel     *lblPrice;
    
    ProBuyingProgress   *progress;
    UIButton     *image;
    UIImageView* imgtenrmb;
}
@end

@implementation ProductDetailTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgtenrmb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        imgtenrmb.image = [UIImage imageNamed:@"tenrmb"];
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, mainWidth-140-60, mainWidth-140-60)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.borderColor = [[UIColor clearColor]CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        image = [[UIButton alloc]initWithFrame:CGRectMake(10, mainWidth-105-60, 50, 20)];
        image.backgroundColor = [UIColor hexFloatColor:@"1b9f40"];
        image.layer.borderColor = [[UIColor hexFloatColor:@"ff3131"]CGColor];
        image.layer.borderWidth = 0.5;
        image.layer.cornerRadius = 3;
        [image setTitle:@"进行中" forState:UIControlStateNormal];
        image.titleLabel.font = [UIFont systemFontOfSize: 13];
        image.titleLabel.textColor = [UIColor whiteColor];
        image.userInteractionEnabled = NO;
        [self addSubview:image];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, mainWidth-110-60, mainWidth - 20-55, 30)];
        lblTitle.font = [UIFont systemFontOfSize:13];
        lblTitle.textColor = [UIColor grayColor];
        [self addSubview:lblTitle];
        
        UILabel* lblAlert = [[UILabel alloc]initWithFrame:CGRectMake(10, mainWidth-140, mainWidth-20, 40)];
        lblAlert.textColor = [UIColor redColor];
        lblAlert.textAlignment = NSTextAlignmentLeft;
        lblAlert.font = [UIFont systemFontOfSize:13];
        lblAlert.lineBreakMode = NSLineBreakByWordWrapping;
        lblAlert.numberOfLines = 2;
        lblAlert.text = @"苹果公司不会以任何形式参与到夺宝大咖中，本产品所有活动及商品均与苹果公司无关。";
        [self addSubview:lblAlert];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, mainWidth-100, mainWidth - 20, 14)];
        lblPrice.font = [UIFont systemFontOfSize:13];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        progress = [[ProBuyingProgress alloc]initWithFrame:CGRectMake(10, mainWidth-80, mainWidth-20, 35)];
        [self addSubview:progress];
    }
    return self;
}

- (void)setProDetail:(ProductInfo*)detail img:(UIImageView**)img array:(NSArray*)arr
{
    if(!detail)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:detail.thumb];
    *img = imgPro;
    
    NSString* str = detail.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",detail.qishu,myStr];
    
    lblPrice.text = [NSString stringWithFormat:@"总需人次：%@",detail.zongrenshu];
    
    [progress setProgress:[detail.shenyurenshu doubleValue] now:[detail.canyurenshu doubleValue]];
    
    if ([detail.yunjiage intValue]>2) {
        [self addSubview:imgtenrmb];
    }
    
    if (![UserInstance ShardInstnce].uid)
    {
        image.titleLabel.text = @"未登录";
        image.backgroundColor = [UIColor hexFloatColor:@"979797"];
        image.layer.borderColor = [[UIColor hexFloatColor:@"7c7a7a"]CGColor];
    }
    else
    {
        if (arr.count > 0)
        {
            image.titleLabel.text = @"已参与";
            image.backgroundColor = [UIColor hexFloatColor:@"5599ff"];
            image.layer.borderColor = [[UIColor hexFloatColor:@"3d7ddc"]CGColor];
        }
        else
        {
            image.titleLabel.text = @"未参与";
            image.backgroundColor = [UIColor hexFloatColor:@"9155ff"];
            image.layer.borderColor = [[UIColor hexFloatColor:@"7237de"]CGColor];
        }
    }
}

@end
