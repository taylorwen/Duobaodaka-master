//
//  AllProItemCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "AllProItemCell.h"
#import "CartModel.h"
#import "AppDelegate.h"
#import "CartInstance.h"

@interface AllProItemCell ()
{
    ProCellType     _type;
    AllProItme      *_myItem;
    
    UIImageView *imgPro;
    
    UILabel     *lblTitle;
    UILabel     *lblPrice;
    
    UIProgressView  *progress;
    
    UILabel         *lblNowNum;
    UILabel         *lblAllNum;
    UILabel         *lblLeftNum;
}

@end

@implementation AllProItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 10;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.numberOfLines = 2;
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = wordColor;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:12];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 50, 70, 35, 35)];
            [btnCart setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
            [btnCart addTarget:self action:@selector(addCartAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnCart];
        }
        
        progress = [[UIProgressView alloc] initWithFrame:CGRectMake(120, 80, mainWidth - 180, 30)];
        progress.progressTintColor = mainColor;
        [self addSubview:progress];
        
        lblNowNum = [[UILabel alloc] initWithFrame:CGRectMake(120, 85, 100, 13)];
        lblNowNum.textColor = mainColor;
        lblNowNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblNowNum];
        
        lblAllNum = [[UILabel alloc] init];
        lblAllNum.textColor = wordColor;
        lblAllNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblAllNum];
        
        lblLeftNum = [[UILabel alloc] init];
        lblLeftNum.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblLeftNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblLeftNum];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 13)];
        lbl1.text = @"已参与";
        lbl1.textColor = wordColor;
        lbl1.font = [UIFont systemFontOfSize:8];
        [self addSubview:lbl1];
        
        UILabel* lbl2 = [[UILabel alloc] init];
        lbl2.text = @"总需人次";
        lbl2.textColor = wordColor;
        lbl2.font = [UIFont systemFontOfSize:8];
        CGSize s = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake(120 + (progress.frame.size.width - s.width) / 2, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl2];
        
        UILabel* lbl3 = [[UILabel alloc] init];
        lbl3.text = @"剩余";
        lbl3.textColor = wordColor;
        lbl3.font = [UIFont systemFontOfSize:8];
        s = [lbl3.text textSizeWithFont:lbl3.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl3.frame = CGRectMake(120 + progress.frame.size.width - s.width, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl3];
    }
    return self;
}

- (void)setProItem:(AllProItme*)item type:(ProCellType)type
{
    _type = type;
    _myItem = item;
    [imgPro setImage_oy:oyImageBaseUrl image:item.thumb];
    NSString*str = item.title;
    NSString*myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0)
    {
        myStr = [str stringByReplacingOccurrencesOfString:str withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = myStr;
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(mainWidth - 130, 40) lineBreakMode:NSLineBreakByCharWrapping];
    lblTitle.frame = CGRectMake(120, 15, mainWidth - 130, s.height < 40 ? s.height : 40);
    
    lblPrice.text = [NSString stringWithFormat:@"总需人次：%@",item.money];
    lblPrice.frame = CGRectMake(120, lblTitle.frame.origin.y + lblTitle.frame.size.height + 5, mainWidth - 130, 20);
    
    lblNowNum.text = item.canyurenshu;
    lblAllNum.text = item.zongrenshu;
    lblLeftNum.text = item.shenyurenshu;
    
    s = [lblLeftNum.text textSizeWithFont:lblLeftNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblLeftNum.frame = CGRectMake(120 + progress.frame.size.width - s.width , lblNowNum.frame.origin.y, s.width, 13);
    
    s = [lblAllNum.text textSizeWithFont:lblAllNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblAllNum.frame = CGRectMake(120 + (progress.frame.size.width - s.width)/2, lblNowNum.frame.origin.y, s.width, 13);
    
    progress.progress = [item.canyurenshu doubleValue]/ [item.zongrenshu doubleValue];
}

-(void)addCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = _myItem.pid;
    item.title = _myItem.title;
    item.qishu = _myItem.qishu;
    item.yunjiage = @"1";
    item.sid = _myItem.sid;
    item.money = _myItem.yunjiage;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_myItem.thumb];
    
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:_type == ProCellType_All ? addCartType_Tab : addCartType_Search];
}
@end
