//
//  ProductBuyCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductBuyCell.h"
#import "ProdcutBuyModel.h"

@interface ProductBuyCell ()
{
    __weak id<ProductBuyCellDelegate> delegate;
    UIImageView* imgHead;
    UILabel*     lblName;
    UIButton*       btnName;
    UILabel*     lblArea;
    UILabel*     lblNum;
    UILabel*     lblRc;
    UILabel*     lblTime;
    ProdcutBuyItem* myItem;
}
@end

@implementation ProductBuyCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imgHead.image = [UIImage imageNamed:@"noimage"];
        imgHead.layer.cornerRadius = 30;
        imgHead.layer.borderWidth = 3;
        imgHead.layer.masksToBounds = YES;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"f8f8f8"] CGColor];
        [self addSubview:imgHead];
        
        btnName = [[UIButton alloc]initWithFrame:CGRectMake(75, 10, mainWidth - 100, 15)];
        [btnName setTitleColor:[UIColor hexFloatColor:@"3385ff"] forState:UIControlStateNormal];
        btnName.titleLabel.font = [UIFont systemFontOfSize:14];
        btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnName addTarget:self action:@selector(tapBuyName) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnName];
        
        lblArea = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, mainWidth - 100, 15)];
        lblArea.textColor = [UIColor lightGrayColor];
        lblArea.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblArea];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 100, 15)];
        lbl.textColor = [UIColor grayColor];
        lbl.text = @"夺宝了";
        lbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbl];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(120, lbl.frame.origin.y, 100, 15)];
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblNum];
        
        lblRc = [[UILabel alloc] init];
        lblRc.text = @"人次";
        lblRc.textColor = [UIColor grayColor];
        lblRc.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblRc];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(75, 70, mainWidth - 80, 15)];
        lblTime.textColor = [UIColor grayColor];
        lblTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblTime];
    }
    return self;
}

- (void)setBuy:(ProdcutBuyItem*)item
{
    if (!item) {
        return;
    }
    myItem = item;
    [imgHead setImage_oy:oyImageBaseUrl image:item.uphoto];
    
    lblName.text = item.username;
    [btnName setTitle:item.username forState:UIControlStateNormal];
    
    //删掉关键字Android
    NSString* lblIP = item.ip;
    NSString* removeAndroid;
    NSRange range = [lblIP rangeOfString:@"Android"];
    if (range.length >0) {
        removeAndroid = [lblIP stringByReplacingOccurrencesOfString:@"Android" withString:@"客户端"];
    }
    else{
        removeAndroid = lblIP;
    }
    lblArea.text = [NSString stringWithFormat:@"%@",removeAndroid];
    //CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblNum.text = item.gonumber;
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblRc.frame = CGRectMake(lblNum.frame.origin.x + s.width + 10, lblNum.frame.origin.y, 100, 15);
    
    lblTime.text = [NSString stringWithFormat:@"%@",[WenzhanTool formateDateStr:item.time]];
}

- (void)tapBuyName
{
    if (delegate) {
        [delegate tapUsername:myItem.uid];
    }
}
@end
