//
//  MineShowOrderCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineShowOrderCell.h"
#import "WenzhanTool.h"

@interface MineShowOrderCell ()
{
    UIImageView     *imgPro;
    
    UILabel         *lblTitle;
    UILabel         *lblIP;
    UILabel         *lblContent;
    UILabel         *lblTime;
    UILabel         *lblState;
    UILabel         *lblFufen;
}
@end

@implementation MineShowOrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, mainWidth - 120, 40)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitle.numberOfLines = 2;
        [self addSubview:lblTitle];
        
        lblIP = [[UILabel alloc] initWithFrame:CGRectMake(110, 65, mainWidth - 120, 15)];
        lblIP.textColor = [UIColor lightGrayColor];
        lblIP.font = [UIFont systemFontOfSize:11];
        lblIP.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblIP];
        
        lblContent = [[UILabel alloc] init];
        lblContent.font = [UIFont systemFontOfSize:11];
        lblContent.textColor = [UIColor lightGrayColor];
        lblContent.frame = CGRectMake(110, 30, mainWidth - 120, 40);
        lblContent.numberOfLines = 2;
        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblContent];
        
        lblFufen = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, mainWidth - 120, 15)];
        lblFufen.textColor = [UIColor lightGrayColor];
        lblFufen.font = [UIFont systemFontOfSize:11];
//        [self addSubview:lblFufen];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, mainWidth - 120, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblTime];
        
        
        UILabel* lblS = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, mainWidth - 120, 15)];
        lblS.textColor = [UIColor lightGrayColor];
        lblS.font = [UIFont systemFontOfSize:11];
        lblS.text = @"状态：";
//        [self addSubview:lblS];
        
        lblState = [[UILabel alloc] initWithFrame:CGRectMake(155, 90, mainWidth - 120, 15)];
        lblState.textColor = [UIColor lightGrayColor];
        lblState.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblState];
        
        

    }
    return self;
}

- (void)setMyPost:(MineShowOrderItem *)item
{
    if (!item) {
        return;
    }
    [imgPro setImage_oy:oyImageBaseUrl image:item.sd_thumbs];
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
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",item.sd_qishu,myStr];
    lblIP.text = [NSString stringWithFormat:@"用户IP:%@",item.sd_ip];
    lblTime.text = [NSString stringWithFormat:@"晒单时间:%@",[WenzhanTool formateDateStr:item.sd_time]];
    lblFufen.text = [NSString stringWithFormat:@"奖励积分：%@",item.gonumber];
    
//    if ([item.postState intValue] == 0)
//    {
//        lblState.text = @"正在审核";
//        lblState.textColor = mainColor;
//    }
//    else if ([item.postState intValue] == 1)
//    {
//        lblState.text = @"审核失败";
//        lblState.textColor = [UIColor grayColor];
//    }
//    else if ([item.postState integerValue] == 2)
//    {
//        lblState.text = @"审核通过";
//        lblState.textColor = [UIColor hexFloatColor:@"41c012"];
//    }
}

@end
