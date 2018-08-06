//
//  ProductLotteryCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLotteryCell.h"

@interface ProductLotteryCell ()
{
    UIView      *vvv;
    UIImageView *imgHead;
    UILabel     *lblName;
    UILabel     *lblUserId;
    UILabel     *lblParticipate;
    UILabel     *lblShowtime;
    UILabel     *lblLotteryNumber;
    UILabel     *lblNumber;
    
    UIView      *sss;
    UILabel     *lblTime;
    NSInteger    nowSeconds;
    NSTimer     *timer;


    
}
@end

@implementation ProductLotteryCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        sss = [[UIView alloc]initWithFrame:CGRectMake(10, 5, mainWidth-20, 39)];
        sss.backgroundColor = [UIColor hexFloatColor:@"ff5454"];
        sss.layer.cornerRadius = 3;
        
        UILabel* mylblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainWidth-20, 39)];
        mylblTime.font = [UIFont systemFontOfSize:15];
        mylblTime.textColor = [UIColor whiteColor];
        mylblTime.text = @"揭晓倒计时  ";
        mylblTime.textAlignment = NSTextAlignmentLeft;
        [sss addSubview:mylblTime];
        
        lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainWidth-50, 39)];
        lblTime.font = [UIFont systemFontOfSize:30];
        lblTime.textColor = [UIColor whiteColor];
        lblTime.text = @"00:00:00";
        lblTime.textAlignment = NSTextAlignmentCenter;
        [sss addSubview:lblTime];
        
        UIButton* btnCaculate1 = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-20 - 10 - 80, 5, 80, 29)];
        [btnCaculate1 setTitle:@"计算详情" forState:UIControlStateNormal];
        [btnCaculate1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnCaculate1.titleLabel.font = [UIFont systemFontOfSize:14];
        btnCaculate1.layer.borderWidth = 1;
        btnCaculate1.layer.borderColor = [UIColor whiteColor].CGColor;
        btnCaculate1.layer.cornerRadius = 4;
        [btnCaculate1 addTarget:self action:@selector(calculateClicked1) forControlEvents:UIControlEventTouchUpInside];
        [sss addSubview:btnCaculate1];
        
        vvv = [[UIView alloc]initWithFrame:CGRectMake(10, 10, mainWidth - 20, 150)];
        vvv.backgroundColor = [UIColor whiteColor];
        
        UIImageView* bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth-20, 150)];
        bg1.image = [UIImage imageNamed:@"bg01"];
        [vvv addSubview:bg1];
        
        UIImageView* bg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 41, 41)];
        bg2.image = [UIImage imageNamed:@"bg02"];
        [vvv addSubview:bg2];
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        imgHead.layer.cornerRadius = imgHead.frame.size.height/ 2;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [vvv addSubview:imgHead];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, mainWidth - 80, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:15];
        [vvv addSubview:lblName];
        
        lblUserId = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, mainWidth - 80, 15)];
        lblUserId.textColor = [UIColor grayColor];
        lblUserId.font = [UIFont systemFontOfSize:12];
        [vvv addSubview:lblUserId];
        
        lblParticipate = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, mainWidth - 100, 15)];
        lblParticipate.textColor = [UIColor grayColor];
        lblParticipate.font = [UIFont systemFontOfSize:12];
        [vvv addSubview:lblParticipate];
        
        lblShowtime = [[UILabel alloc] initWithFrame:CGRectMake(70, 80, mainWidth - 100, 15)];
        lblShowtime.textColor = [UIColor grayColor];
        lblShowtime.font = [UIFont systemFontOfSize:12];
        [vvv addSubview:lblShowtime];
        
        lblLotteryNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 122, mainWidth - 100, 15)];
        lblLotteryNumber.textColor = [UIColor grayColor];
        lblLotteryNumber.font = [UIFont systemFontOfSize:12];
        lblLotteryNumber.text = @"幸运号码:      ";
        [vvv addSubview:lblLotteryNumber];
        
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(85, 122, mainWidth - 100, 15)];
        lblNumber.textColor = [UIColor redColor];
        lblNumber.font = [UIFont systemFontOfSize:15];
        [vvv addSubview:lblNumber];
        
        UIButton* btnCaculate = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-40 - 80, 118, 80, 20)];
        [btnCaculate setTitle:@"计算详情" forState:UIControlStateNormal];
        [btnCaculate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnCaculate.titleLabel.font = [UIFont systemFontOfSize:14];
        btnCaculate.layer.borderWidth = 1;
        btnCaculate.layer.borderColor = [UIColor redColor].CGColor;
        btnCaculate.layer.cornerRadius = 4;
        [btnCaculate addTarget:self action:@selector(calculateClicked) forControlEvents:UIControlEventTouchUpInside];
        [vvv addSubview:btnCaculate];
        
    }
    return self;
}

- (void)setMyLottery:(ProductInfo*)lottery myChild:(ProductInfoChild*)infoChild
{
    if(!lottery)
        return;
    if (!infoChild) 
        return;
    if ([lottery.shengyutime intValue] < 0)
    {
        [self addSubview:vvv];
        [imgHead setImage_oy:oyImageBaseUrl image:infoChild.img];
        if ([infoChild.username isEqualToString:@""]) {
            NSString* str = infoChild.mobile;
            NSRange ran = NSMakeRange(3, 4);
            NSString* replace = [str substringWithRange:ran];
            NSString* md5Str = [str stringByReplacingOccurrencesOfString:replace withString:@"***"];
            lblName.text = [NSString stringWithFormat:@"获奖者:   %@",md5Str];
        }else
        {
            lblName.text        = [NSString stringWithFormat:@"获奖者:   %@",infoChild.username ];
        }
        lblUserId.text      = [NSString stringWithFormat:@"用户ID:      %@ [用户终身不变ID]", infoChild.uid];
        lblParticipate.text = [NSString stringWithFormat:@"本期参与:   %@",lottery.gonumber];
        lblShowtime.text    = [NSString stringWithFormat:@"揭晓时间:   %@",[WenzhanTool formateDateStr:lottery.q_end_time]];
        lblNumber.text      = lottery.q_user_code;
    }
    else
    {
        [self addSubview:sss];
        if(timer)
        {
            [timer invalidate];
            timer = nil;
        }
        nowSeconds = [lottery.shengyutime integerValue] * 100;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }

}

- (void)timerAction
{
    if(nowSeconds < 0)
    {
        [timer invalidate];
        timer = nil;
        return;
    }
    nowSeconds--;
    if(nowSeconds <= 0)
    {
        lblTime.text = @"正在揭晓...";
        
        return;
    }
    int m = (int)nowSeconds / 6000;
    NSString* f0 = m > 9 ? [NSString stringWithFormat:@"%d",m] : [@"0" stringByAppendingFormat:@"%d",m];
    int s = (int)(nowSeconds/100) - m*60;
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = nowSeconds % 100;
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    lblTime.text = [NSString stringWithFormat:@"%@:%@:%@",f0,f1,f2];
    
}


- (void)calculateClicked
{
    if (delegate)
    {
        [delegate lotteryDetailClicked];
    }
}

- (void)calculateClicked1
{
    if (delegate)
    {
        [delegate lotteryDetailClicked];
    }
}

@end
