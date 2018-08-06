//
//  MineBuyCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineBuyCell.h"
#import "WenzhanTool.h"

@interface MineBuyCell ()
{
    __weak id<MineBuyViewDelegate> delegate;
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    UILabel         *lblName;
    UILabel         *lblTime;
    UILabel         *lblAllNeed;
    
    UILabel*    dCishu;
    UILabel*    renci;
    UILabel*    myRenci;
    UILabel*    lukyNo;
    MineBuyedItem   *buyedItem;
}
@end

@implementation MineBuyCell
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
        imgProBg.backgroundColor = [UIColor blackColor];
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = @"已揭晓";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:11];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
        lbl.frame = CGRectMake((90 - s.width) / 2, 90-(20 - s.height )/2 - s.height, s.width, s.height);
        [imgPro addSubview:lbl];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:12];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        UILabel *lblZong = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, mainWidth - 100, 15)];
        lblZong.text = @"总需人次：";
        lblZong.textColor = [UIColor lightGrayColor];
        lblZong.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblZong];
        
        lblAllNeed = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, mainWidth - 100, 15)];
        lblAllNeed.textColor = mainColor;
        lblAllNeed.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblAllNeed];
        
        UILabel *benqi = [[UILabel alloc] initWithFrame:CGRectMake(110, 75, mainWidth - 100, 15)];
        benqi.text = @"您本期参与人次：";
        benqi.textColor = [UIColor lightGrayColor];
        benqi.font = [UIFont systemFontOfSize:12];
        [self addSubview:benqi];
        
        myRenci = [[UILabel alloc] initWithFrame:CGRectMake(205, 75, mainWidth - 100, 15)];
        myRenci.textColor = [UIColor redColor];
        myRenci.font = [UIFont systemFontOfSize:12];
        [self addSubview:myRenci];
        
        UIButton* btnDetail = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-70, 75, 70, 20)];
        btnDetail.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnDetail setTitle:@"查看详情" forState:UIControlStateNormal];
        [btnDetail setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnDetail addTarget:self action:@selector(seeDetailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnDetail];
        
        //获奖者信息
        UIView* bgTA = [[UIView alloc]initWithFrame:CGRectMake(110, 100, mainWidth - 120, 90)];
        bgTA.backgroundColor = [UIColor hexFloatColor:@"ebebeb"];
        bgTA.layer.cornerRadius = 3;
        [self addSubview:bgTA];
        
        UILabel *lbln = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, bgTA.frame.size.width-20, 15)];
        lbln.text = @"获得者：";
        lbln.textColor = [UIColor lightGrayColor];
        lbln.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:lbln];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, bgTA.frame.size.width - 65, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:lblName];
        
        UILabel *benqiTA = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, bgTA.frame.size.width - 20, 15)];
        benqiTA.text = @"本期参与人次：";
        benqiTA.textColor = [UIColor lightGrayColor];
        benqiTA.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:benqiTA];
        
        renci = [[UILabel alloc] initWithFrame:CGRectMake(95, 25, bgTA.frame.size.width - 115, 15)];
        renci.textColor = mainColor;
        renci.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:renci];
        
        UILabel *luky = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, bgTA.frame.size.width - 20, 15)];
        luky.text = @"幸运夺宝码：";
        luky.textColor = [UIColor lightGrayColor];
        luky.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:luky];
        
        lukyNo = [[UILabel alloc] initWithFrame:CGRectMake(85, 45, bgTA.frame.size.width - 115, 15)];
        lukyNo.textColor = mainColor;
        lukyNo.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:lukyNo];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, bgTA.frame.size.width - 20, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [bgTA addSubview:lblTime];
    }
    return self;
}

- (void)setBuyed:(MineBuyedItem*)memitem recode:(MineMyBuyItem*)item
{
    if (!memitem) {
        return;
    }
    if (!item) {
        return;
    }
    buyedItem = memitem;
    [imgPro setImage_oy:oyImageBaseUrl image:item.thumb];
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0)
    {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",item.qishu,myStr];
    lblAllNeed.text = item.zongrenshu;
    myRenci.text = item.gonumber;
    lblName.text = memitem.username;
    lukyNo.text = memitem.huode;
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@",[WenzhanTool formateDateStr:memitem.q_end_time]];
    
    [renci setText:[NSString stringWithFormat: @"%@",memitem.gonumber]];
}

- (void)seeDetailButtonClicked
{
    if(delegate)
    {
        [delegate seeCodeDetailAction:buyedItem.goucode];
    }
}
@end
