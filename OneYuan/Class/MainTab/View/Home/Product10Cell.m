//
//  HomeHotCollectionCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "Product10Cell.h"
#import "CartModel.h"
#import "CartInstance.h"
#import "HomeModel.h"

#define cellW self.frame.size.width
#define cellH self.frame.size.height

@interface  Product10Cell()
{
    UIImageView                 *imgPro;
    UILabel                     *lblTitle;
    UILabel                     *lblPrice;
    
    LDProgressView   *progress;
    
    UILabel                     *lblNowNum;
    UILabel                     *lblAllNum;
    UILabel                     *lblLeftNum;
    HomeTenModel                *_myItem;
    HomeTenCollectionType       *_type;
}
@end

@implementation Product10Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [myLineColor CGColor];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        img.image = [UIImage imageNamed:@"tenrmb"];
        [self addSubview:img];
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, mainWidth/2-60, mainWidth/2-60)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.numberOfLines = 2;
        lblTitle.font = [UIFont systemFontOfSize:13];
        lblTitle.textColor = wordColor;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:12];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth/2 - 45, mainWidth/2+25, 35, 35)];
            btnCart.layer.borderWidth = 0.8;
            btnCart.layer.borderColor = [UIColor  hexFloatColor:@"e58c5e"].CGColor;
            btnCart.layer.cornerRadius = 17.5;
            [btnCart setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
            [btnCart addTarget:self action:@selector(addCartAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnCart];
        }
        
        progress = [[LDProgressView alloc] initWithFrame:CGRectMake(10, mainWidth/2+30, mainWidth/2 - 70, 8)];
        progress.color = mainColor;
        progress.borderRadius = @3;
        progress.flat = @YES;
        progress.showBackgroundInnerShadow = @YES;
        progress.animate = @NO;
        [self addSubview:progress];
        
        lblNowNum = [[UILabel alloc] initWithFrame:CGRectMake(10, mainWidth/2+40, 100, 13)];
        lblNowNum.textColor = mainColor;
        lblNowNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblNowNum];
        
        lblAllNum = [[UILabel alloc] init];
        lblAllNum.textColor = wordColor;
        lblAllNum.font = [UIFont systemFontOfSize:10];
        
        lblLeftNum = [[UILabel alloc] init];
        lblLeftNum.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblLeftNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblLeftNum];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, mainWidth/2+50, 100, 13)];
        lbl1.text = @"已参与";
        lbl1.textColor = wordColor;
        lbl1.font = [UIFont systemFontOfSize:8];
        [self addSubview:lbl1];
        
        UILabel* lbl2 = [[UILabel alloc] init];
        lbl2.text = @"总需人次";
        lbl2.textColor = wordColor;
        lbl2.font = [UIFont systemFontOfSize:8];
        CGSize s = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake(10 + (progress.frame.size.width - s.width) / 2, lbl1.frame.origin.y, s.width, 13);
        //        [self addSubview:lbl2];
        
        UILabel* lbl3 = [[UILabel alloc] init];
        lbl3.text = @"剩余";
        lbl3.textColor = wordColor;
        lbl3.font = [UIFont systemFontOfSize:8];
        s = [lbl3.text textSizeWithFont:lbl3.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl3.frame = CGRectMake(10 + progress.frame.size.width - s.width, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl3];
        
    }
    return self;
}

- (void)setTenPros:(HomeTenModel*)hot
{
    _myItem = (HomeTenModel*)hot;
    if(hot)
    {
        [imgPro setImage_oy:oyImageBaseUrl image:hot.thumb];
    }
    else
    {
        [imgPro setImage:[UIImage imageNamed:@"noimage"]];
    }
    NSString* str = hot.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = myStr;
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(mainWidth/2 - 20, 40) lineBreakMode:NSLineBreakByCharWrapping];
    lblTitle.frame = CGRectMake(10, mainWidth/2-30, mainWidth/2 - 20, s.height < 40 ? s.height : 40);
    
    lblPrice.text = [NSString stringWithFormat:@"总需人次: %@",hot.zongrenshu];
    lblPrice.frame = CGRectMake(10, mainWidth/2 + 8, mainWidth/2 - 20, 12);
    
    lblNowNum.text = hot.canyurenshu;
    lblAllNum.text = hot.zongrenshu;
    lblLeftNum.text = hot.shenyurenshu;
    
    s = [lblLeftNum.text textSizeWithFont:lblLeftNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblLeftNum.frame = CGRectMake(10 + progress.frame.size.width - s.width , lblNowNum.frame.origin.y, s.width, 13);
    
    s = [lblAllNum.text textSizeWithFont:lblAllNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblAllNum.frame = CGRectMake(10 + (progress.frame.size.width - s.width)/2, lblNowNum.frame.origin.y, s.width, 13);
    
    progress.progress = [hot.canyurenshu doubleValue]/ [hot.zongrenshu doubleValue];
}

-(void)addCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = _myItem.pid;
    item.title = _myItem.title;
    item.qishu = _myItem.qishu;
    item.yunjiage = _myItem.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d", 10];
    item.sid = _myItem.sid;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_myItem.thumb];
    
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:_type == HomeTenCollectionType_All ? addCartType_Tab : addCartType_Search];
}

@end