//
//  PersonBuyingRecordCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonBuyingRecordCell.h"
#import "ProBuyingProgress.h"
#import "CartModel.h"
#import "CartInstance.h"

@interface PersonBuyingRecordCell ()
{
    __weak id<PersonBuyingViewDelegate> delegate;
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    ProBuyingProgress   *progress;
    
    UILabel         *lblNum;
    UILabel         *lblRC;
    
    UILabel         *lbl;
    
    MineMyBuyItem*  _myItem;
    
}

@end

@implementation PersonBuyingRecordCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        UIImageView  *imgProBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgPro.frame.size.height - 20, 90, 20)];
        imgProBg.backgroundColor = mainColor;
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        lbl = [[UILabel alloc] init];
        lbl.text = @"进行中";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:11];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
        lbl.frame = CGRectMake((90 - s.width) / 2, 90-(20 - s.height )/2 - s.height, s.width, s.height);
        [imgPro addSubview:lbl];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblTitle];
        
        progress = [[ProBuyingProgress alloc] initWithFrame:CGRectMake(110, 55, mainWidth - 120, 35)];
        [self addSubview:progress];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 105, 100, 15)];
        lbl1.text = @"本期已参与";
        lbl1.textColor = [UIColor lightGrayColor];
        lbl1.font = [UIFont systemFontOfSize:12];
        [self addSubview:lbl1];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(190, 105, 100, 15)];
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblNum];
        
        lblRC = [[UILabel alloc] init];
        lblRC.text = @"人次";
        lblRC.textColor = [UIColor lightGrayColor];
        lblRC.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRC];
        
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth-90, 95, 80, 25)];
            btnCart.layer.borderWidth = 0.5;
            btnCart.layer.borderColor = [UIColor  redColor].CGColor;
            btnCart.layer.cornerRadius = 10;
            btnCart.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnCart setTitle:@"跟买" forState:UIControlStateNormal];
            [btnCart setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btnCart addTarget:self action:@selector(addCartAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnCart];
        }
    }
    return self;
}

- (void)setBuying:(MineMyBuyItem*)item
{
    if(!item || !item.thumb)
        return;
    _myItem = item;
    [imgPro setImage_oy:oyImageBaseUrl image:item.thumb];
    
    
    lbl.text = @"进行中";
    [self addSubview:progress];
    [progress setProgress:[item.shenyurenshu doubleValue] now:[item.canyurenshu doubleValue]];
    
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
    lblNum.text = [NSString stringWithFormat:@"%@",item.gonumber];
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblRC.frame = CGRectMake(190 + s.width + 10, 105, 100, 15);
}

- (void)addCartAction
{
    if(delegate)
    {
        [delegate addPersonGotoCartAction:_myItem];
    }
}

@end
