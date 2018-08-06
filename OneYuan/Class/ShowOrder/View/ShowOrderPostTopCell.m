//
//  ShowOrderPostTopCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderPostTopCell.h"

@interface ShowOrderPostTopCell ()
{
    UIImageView *imgHead;
    UIImageView *imgGet;
    UILabel     *lblName;
    UILabel     *lblNum;
    UILabel     *lblTitle;
    UILabel     *lblFufen;
    
    UILabel     *lblPostTitle;
    UILabel     *lblPostTime;
    UILabel     *lblPostContent;
    
    UIImageView*    imgPro1;
    UIImageView*    imgPro2;
    UIImageView*    imgPro3;
    UIImageView*    imgPro4;
    UIImageView*    imgPro5;
    UIImageView*    imgPro6;
    UIImageView*    imgPro7;
    UIImageView*    imgPro8;
    UIImageView*    imgPro9;
    
    double          rate1;
    double          rate2;
    double          rate3;
    double          rate4;
    double          rate5;
    double          rate6;
    double          rate7;
    double          rate8;
    double          rate9;
}
@end

@implementation ShowOrderPostTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* vTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 90)];
        vTop.backgroundColor = [UIColor hexFloatColor:@"f7f7f7"];
        [self addSubview: vTop];
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imgHead.layer.cornerRadius = 30;
        imgHead.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [vTop addSubview:imgHead];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, mainWidth - 100, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:15];
        [vTop addSubview:lblName];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, mainWidth - 100, 15)];
        lblNum.textColor = [UIColor grayColor];
        lblNum.font = [UIFont systemFontOfSize:12];
        [vTop addSubview:lblNum];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, mainWidth - 90, 30)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:12];
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.numberOfLines = 3;
        [vTop addSubview:lblTitle];
        
        lblPostTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, mainWidth - 20, 15)];
        lblPostTime.textColor = [UIColor lightGrayColor];
        lblPostTime.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblPostTime];
        
        lblPostContent = [[UILabel alloc] init];
        lblPostContent.textColor = [UIColor lightGrayColor];
        lblPostContent.font = [UIFont systemFontOfSize:14];
        lblPostContent.lineBreakMode = NSLineBreakByCharWrapping;
        lblPostContent.numberOfLines = 999;
        [self addSubview:lblPostContent];
        
        imgPro1 = [[UIImageView alloc] init];
        [self addSubview:imgPro1];
        
        imgPro2 = [[UIImageView alloc] init];
        [self addSubview:imgPro2];
        
        imgPro3 = [[UIImageView alloc] init];
        [self addSubview:imgPro3];
        
        imgPro4 = [[UIImageView alloc] init];
        [self addSubview:imgPro4];
        
        imgPro5 = [[UIImageView alloc] init];
        [self addSubview:imgPro5];
        
        imgPro6 = [[UIImageView alloc] init];
        [self addSubview:imgPro6];
        
        imgPro7 = [[UIImageView alloc] init];
        [self addSubview:imgPro7];
        
        imgPro8 = [[UIImageView alloc] init];
        [self addSubview:imgPro8];
        
        imgPro9 = [[UIImageView alloc] init];
        [self addSubview:imgPro9];
    }
    return self;
}

- (void)setPost:(ShowOrderSingleItem*)item Content:(NSString *)postContent
{
    if (!item) {
        return;
    }
    if (!postContent) {
        return;
    }
    
    [imgHead setImage_oy:oyImageBaseUrl image:item.sd_photo];
    
    lblName.text = item.sd_username;
    lblNum.text = [NSString stringWithFormat:@"本期夺宝： %@ 人次",item.gonumber];
    
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期) %@",item.sd_qishu ,myStr];
    
    lblFufen.text = item.gonumber;
    CGSize s = [lblFufen.text textSizeWithFont:lblFufen.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblFufen.frame = CGRectMake((imgGet.frame.size.width - s.width) / 2, 18, s.width, 12);
    
    NSString* str1 = item.sd_content;
    NSString* myStr1;
    NSRange range1 = [str rangeOfString:@"&nbsp;"];
    if (range1.length > 0) {
        myStr1 = [str1 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr1 = str1;
    }
    NSString* strP;
    NSRange rangeP = [myStr1 rangeOfString:@"<p>"];
    if (rangeP.length > 0) {
        strP = [myStr1 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    }else
    {
        strP = myStr1;
    }
    NSString* strBr;
    NSRange rangeBr = [strP rangeOfString:@"<br/>"];
    if (rangeBr.length > 0) {
        strBr = [strP stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    }else
    {
        strBr = strP;
    }
    lblPostTitle.text = strBr;
    lblPostContent.text = strBr;
    
    s = [lblPostContent.text textSizeWithFont:lblPostContent.font constrainedToSize:CGSizeMake(mainWidth - 20, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblPostContent.frame = CGRectMake(10, 100, mainWidth - 20, s.height);
    
    lblPostTime.text = [WenzhanTool formateDateStr: item.sd_time];
    lblPostTime.frame = CGRectMake(10, 100+s.height+10, mainWidth-20, 15);
    
    NSString* imageString = [item.sd_photolist substringToIndex:[item.sd_photolist length]-1];
    NSArray* arrImg = [[Jxb_Common_Common sharedInstance] getSpiltString:imageString split:@";"];
    
    [imgPro1 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:0]];
    NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
    UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];        //得到了UIImage
    rate1 = image1.size.height/image1.size.width;
    imgPro1.frame = CGRectMake(10, 100 + s.height + 35, mainWidth-20, (mainWidth-20)*rate1);
    
    if(arrImg.count<2)
    {
        [imgPro2 setHidden:YES];
    }
    else
    {
        [imgPro2 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:1]];
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate2 = image.size.height/image.size.width;
        imgPro2.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*rate1 +5, mainWidth - 20, (mainWidth-20)*rate2);
    }
    
    if(arrImg.count<3)
    {
        [imgPro3 setHidden:YES];
    }
    else
    {
        [imgPro3 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:2]];
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate3 = image.size.height/image.size.width;
        imgPro3.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2)+5*2, mainWidth - 20, (mainWidth-20)*rate3);
    }
    
    if(arrImg.count<4)
    {
        [imgPro4 setHidden:YES];
    }
    else
    {
        [imgPro4 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:3]];
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate4 = image.size.height/image.size.width;
        imgPro4.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3)+5*3, mainWidth - 20, (mainWidth-20)*rate4);
        
    }
    
    if(arrImg.count<5)
    {
        [imgPro5 setHidden:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate5 = image.size.height/image.size.width;
        imgPro5.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3+rate4)+5*4, mainWidth - 20, (mainWidth-20)*rate5);
        [imgPro5 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:4]];
    }
    
    if(arrImg.count<6)
    {
        [imgPro6 setHidden:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:5]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate6 = image.size.height/image.size.width;
        imgPro6.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3+rate4+rate5)+5*5, mainWidth - 20, (mainWidth-20)*rate6);
        [imgPro6 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:5]];
    }
    
    if(arrImg.count<7)
    {
        [imgPro7 setHidden:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:6]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate7 = image.size.height/image.size.width;
        imgPro7.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3+rate4+rate5+rate6)+5*6, mainWidth - 20, (mainWidth-20)*rate7);
        [imgPro7 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:6]];
    }
    
    if(arrImg.count<8)
    {
        [imgPro8 setHidden:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:7]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate8 = image.size.height/image.size.width;
        imgPro8.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3+rate4+rate5+rate6+rate7)+5*7, mainWidth - 20, (mainWidth-20)*rate8);
        [imgPro8 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:7]];
    }
    
    if(arrImg.count<9)
    {
        [imgPro9 setHidden:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:8]]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        //得到了UIImage
        if (image == nil) {
            return;
        }
        rate9 = image.size.height/image.size.width;
        imgPro9.frame = CGRectMake(10, 100 + s.height + 35 + (mainWidth-20)*(rate1+rate2+rate3+rate4+rate5+rate6+rate7+rate8)+5*8, mainWidth - 20, (mainWidth-20)*rate9);
        [imgPro9 setImage_oy:oyImageBaseUrl image:[arrImg objectAtIndex:8]];
    }
}
@end
