//
//  LotteryHistoryCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LotteryHistoryCell.h"

@interface LotteryHistoryCell ()
{
    UILabel         *lblTitle;
    UIImageView     *imgAvatar;
    
    //第一行
    UILabel         *lblHuojiang;
    UILabel         *lblUsername;
    //第二行
    UILabel         *lblUserId;
    //第三行
    UILabel         *lblLukyNumber;
    UILabel         *lblNumber;
    //第四行
    UILabel         *lblParti;
    UILabel         *lblTimes;
    UILabel         *lblRen;
    
}
@end
@implementation LotteryHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, mainWidth-20, 17)];
        lblTitle.font = [UIFont systemFontOfSize:16];
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.numberOfLines = 1;
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.text = @"";
        [self addSubview:lblTitle];
        
        imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 60, 60)];
        imgAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imgAvatar.layer.borderWidth = 1;
        imgAvatar.layer.cornerRadius = 30;
        imgAvatar.layer.masksToBounds = YES;
        imgAvatar.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgAvatar];
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 36, mainWidth, 0.5)];
        line.backgroundColor = myDarkLineColor;
        [self addSubview:line];
        
        //第一行
        lblHuojiang = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, mainWidth-20, 13)];
        lblHuojiang.font = [UIFont systemFontOfSize:12];
        lblHuojiang.lineBreakMode = NSLineBreakByWordWrapping;
        lblHuojiang.numberOfLines = 1;
        lblHuojiang.textColor = [UIColor lightGrayColor];
        lblHuojiang.text = @"获奖者:";
        [self addSubview:lblHuojiang];
        
        lblUsername = [[UILabel alloc]initWithFrame:CGRectMake(140, 45, mainWidth-20, 13)];
        lblUsername.font = [UIFont systemFontOfSize:12];
        lblUsername.lineBreakMode = NSLineBreakByWordWrapping;
        lblUsername.numberOfLines = 1;
        lblUsername.textColor = [UIColor hexFloatColor:@"456DC5"];
        lblUsername.text = @"";
        [self addSubview:lblUsername];
        
        //第二行
        lblUserId = [[UILabel alloc]initWithFrame:CGRectMake(80, 63, mainWidth-20, 13)];
        lblUserId.font = [UIFont systemFontOfSize:12];
        lblUserId.lineBreakMode = NSLineBreakByWordWrapping;
        lblUserId.numberOfLines = 1;
        lblUserId.textColor = [UIColor lightGrayColor];
        lblUserId.text = @"用户ID:";
        [self addSubview:lblUserId];
        
        //第三行
        lblLukyNumber = [[UILabel alloc]initWithFrame:CGRectMake(80, 81, mainWidth-20, 13)];
        lblLukyNumber.font = [UIFont systemFontOfSize:12];
        lblLukyNumber.lineBreakMode = NSLineBreakByWordWrapping;
        lblLukyNumber.numberOfLines = 1;
        lblLukyNumber.textColor = [UIColor lightGrayColor];
        lblLukyNumber.text = @"幸运号码:";
        [self addSubview:lblLukyNumber];
        
        lblNumber = [[UILabel alloc]initWithFrame:CGRectMake(140, 81, mainWidth-20, 13)];
        lblNumber.font = [UIFont systemFontOfSize:12];
        lblNumber.lineBreakMode = NSLineBreakByWordWrapping;
        lblNumber.numberOfLines = 1;
        lblNumber.textColor = [UIColor redColor];
        lblNumber.text = @"10000021";
        [self addSubview:lblNumber];
        
        //第四行
        lblParti = [[UILabel alloc]initWithFrame:CGRectMake(80, 99, mainWidth-20, 13)];
        lblParti.font = [UIFont systemFontOfSize:12];
        lblParti.lineBreakMode = NSLineBreakByWordWrapping;
        lblParti.numberOfLines = 1;
        lblParti.textColor = [UIColor lightGrayColor];
        lblParti.text = @"本期参与:";
        [self addSubview:lblParti];
        
        lblTimes = [[UILabel alloc]initWithFrame:CGRectMake(140, 99, mainWidth-20, 13)];
        lblTimes.font = [UIFont systemFontOfSize:12];
        lblTimes.lineBreakMode = NSLineBreakByWordWrapping;
        lblTimes.numberOfLines = 1;
        lblTimes.textColor = [UIColor redColor];
        lblTimes.text = @"";
        [self addSubview:lblTimes];
        
        lblRen = [[UILabel alloc]init];
        lblRen.font = [UIFont systemFontOfSize:12];
        lblRen.lineBreakMode = NSLineBreakByWordWrapping;
        lblRen.numberOfLines = 1;
        lblRen.textColor = [UIColor lightGrayColor];
        lblRen.text = @"人次";
        [self addSubview:lblRen];
        
    }
    return self;
}

- (void)setMyLottery:(HistoryLotteryModel*)item
{
    if (!item) {
        return;
    }
    
    lblTitle.text = [NSString stringWithFormat:@"第%@期 揭晓时间: %@",item.qishu,[WenzhanTool formateDateStr:item.q_end_time]];
    [imgAvatar setImage_oy:oyImageBaseUrl image:item.uphoto];
    lblUsername.text = item.username;
    lblUserId.text = [NSString stringWithFormat:@"用户ID:      %@ [用户终身不变ID]",item.uid];
    lblNumber.text = item.q_user_code;
    lblTimes.text = item.gonumber;
    CGSize s = [lblTimes.text textSizeWithFont:lblTimes.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblRen.frame = CGRectMake(lblTimes.frame.origin.x + s.width + 5, 99, 100, 13);
    
    
}
@end
