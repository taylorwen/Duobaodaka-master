//
//  ShowOrderItemCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderItemCell.h"

@interface ShowOrderItemCell ()
{
    __weak id   <ShowOrderItemDelegate> delegate;
    UIImageView *imgHead;
    UIImageView *imgLine1;
    //UIImageView *imgLine2;
    
    UIButton     *btnName;
    UILabel     *lblName;
    UILabel     *lblTime;
    UILabel     *lblTitle;
    UILabel     *lblContent;
    
    
    UIImageView *imgPro1;
    UIImageView *imgPro2;
    UIImageView *imgPro3;
}
@end

@implementation ShowOrderItemCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imgHead.image = [UIImage imageNamed:@"noimage"];
        imgHead.layer.cornerRadius = 20;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [self addSubview:imgHead];
        
        imgLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, mainWidth -20, 0.5)];
        imgLine1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:imgLine1];
        
        btnName = [[UIButton alloc] initWithFrame:CGRectMake(55, 10, mainWidth-55-150, 30)];
        btnName.titleLabel.textColor = [UIColor hexFloatColor:@"3385ff"];
        btnName.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnName addTarget:self action:@selector(doNameClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnName];
        
        lblName = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, mainWidth-55-150, 14)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblName];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth-140, 10, 130, 14)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblTime];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, mainWidth - 65, 15)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblTitle];
        
        lblContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, mainWidth - 20, 30)];
        lblContent.textColor = [UIColor lightGrayColor];
        lblContent.font = [UIFont systemFontOfSize:12];
        lblContent.numberOfLines = 2;
        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblContent];
        
        CGFloat w = (mainWidth - 60) / 3;
        
        imgPro1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100,w, w+20)];
        imgPro1.layer.cornerRadius = 3;
        imgPro1.layer.borderColor = [UIColor whiteColor].CGColor;
        imgPro1.layer.borderWidth = 0.5;
        imgPro1.layer.masksToBounds = YES;
        imgPro1.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgPro1];
        
        imgPro2 = [[UIImageView alloc] initWithFrame:CGRectMake(30 + w, 100,w, w+20)];
        imgPro2.image = [UIImage imageNamed:@"noimage"];
        imgPro2.layer.cornerRadius = 3;
        imgPro2.layer.borderColor = [UIColor whiteColor].CGColor;
        imgPro2.layer.borderWidth = 0.5;
        imgPro2.layer.masksToBounds = YES;
        imgPro2.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgPro2];
        
        imgPro3 = [[UIImageView alloc] initWithFrame:CGRectMake(50 + w + w, 100,w, w+20)];
        imgPro3.image = [UIImage imageNamed:@"noimage"];
        imgPro3.layer.cornerRadius = 3;
        imgPro3.layer.borderColor = [UIColor whiteColor].CGColor;
        imgPro3.layer.borderWidth = 0.5;
        imgPro3.layer.masksToBounds = YES;
        imgPro3.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgPro3];
        
    }
    return self;
}

- (void)setShow:(ShowOrderItem*)item
{
    if (!item)
    {
        return;
    }
    [imgHead setImage_oy:oyImageBaseUrl image:item.sd_photo];
    lblName.text = item.sd_username;
    //时间戳转换时间
    lblTime.text = [NSString stringWithFormat:@"%@",[WenzhanTool formateDateStr:item.sd_time]];
    
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期) %@",item.sd_qishu,myStr];
    
    NSString* str1 = item.sd_title;
    NSString* myStr1;
    NSString* myStr2;
    NSString* myStr3;
    NSRange range1 = [str rangeOfString:@"&nbsp;"];
    if (range1.length > 0) {
        myStr1 = [str1 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr1 = str1;
    }
    NSRange range2 = [str rangeOfString:@"&nbsp;"];
    if (range2.length > 0) {
        myStr2 = [myStr1 stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    }else
    {
        myStr2 = myStr1;
    }
    NSRange range3 = [str rangeOfString:@"&nbsp;"];
    if (range3.length > 0) {
        myStr3 = [myStr2 stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    }else
    {
        myStr3 = myStr2;
    }
    lblContent.text = myStr3;
    
    NSArray* arrPic = [[Jxb_Common_Common sharedInstance] getSpiltString:item.sd_photolist split:@";"];
    imgPro3.hidden = arrPic.count < 3;
    imgPro2.hidden = arrPic.count < 2;
    [imgPro1 setImage_oy:oyImageBaseUrl image:[arrPic objectAtIndex:0]];
    if(arrPic.count > 1)
        [imgPro2 setImage_oy:oyImageBaseUrl image:[arrPic objectAtIndex:1]];
    if(arrPic.count > 2)
        [imgPro3 setImage_oy:oyImageBaseUrl image:[arrPic objectAtIndex:2]];
}

- (void)doNameClicked:(NSUInteger)index
{
    if (delegate)
    {
        [delegate doUsernameClicked:index];
    }
}
@end
