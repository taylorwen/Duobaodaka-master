//
//  MineUserView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineUserView.h"
#import "UserInstance.h"

@interface MineUserView ()
{
    __weak id<MineUserViewDelegate> delegate;
}
@end

@implementation MineUserView
@synthesize  delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 140)];
        v.backgroundColor = [UIColor whiteColor];
        [self addSubview:v];
        
        //背景图
        UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pcenterbg"]];
        bg.frame = CGRectMake(0, 0, mainWidth, 140);
        [v addSubview:bg];
        
        UIButton* btnAvatar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        btnAvatar.layer.masksToBounds = YES;
        btnAvatar.layer.cornerRadius = 1;
        btnAvatar.backgroundColor = [UIColor clearColor];
        [btnAvatar addTarget:self action:@selector(imgHeadClicked) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btnAvatar];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 30;
        [img setImage:[UIImage imageNamed:@"noimage"]];
        [img setImage_oy:oyImageBaseUrl image:[UserInstance ShardInstnce].img];
        [v addSubview:img];
        
        UIButton* btnPay = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 90, 58, 80, 30)];
        [btnPay setTitle:@"充值" forState:UIControlStateNormal];
        [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPay setBackgroundColor:mainColor];
        btnPay.titleLabel.font = [UIFont systemFontOfSize:13];
        btnPay.layer.cornerRadius = 4;
        [btnPay addTarget:self action:@selector(btnPayAction) forControlEvents:UIControlEventTouchUpInside];
        [v  addSubview:btnPay];
        
        UILabel* lblName = [[UILabel alloc] init];
        lblName.text = [UserInstance ShardInstnce].username;
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblName];
        lblName.frame = CGRectMake(80, 20, mainWidth - 80 - 16, 15);
        
        UILabel* lblPhone = [[UILabel alloc] init];
        lblPhone.text = [NSString stringWithFormat:@"(%@)",[UserInstance ShardInstnce].mobile];
        lblPhone.textColor = [UIColor whiteColor];
        lblPhone.font = [UIFont systemFontOfSize:14];
        lblPhone.frame = CGRectMake(80 + 5, 40, 200, 14) ;
        [v addSubview:lblPhone];
        
        int num;
        NSString* levelNum = [UserInstance ShardInstnce].groupName;
        if ([levelNum isEqualToString:@"夺宝新手"])
        {
            num = 1;
        }else if ([levelNum isEqualToString:@"夺宝中将"])
        {
            num = 2;
        }else if ([levelNum isEqualToString:@"夺宝大将"])
        {
            num = 3;
        }
        
        UIImageView* imgLevel = [[UIImageView alloc] initWithFrame:CGRectMake(85, 67.5, 12, 12)];
        NSString* level = [NSString stringWithFormat:@"degree%d",num];
        imgLevel.image = [UIImage imageNamed:level];
        [v addSubview:imgLevel];
        
        UILabel* lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(102, 68, 200, 12)];
        lblLevel.textColor = [UIColor lightGrayColor];
        lblLevel.text = levelNum;
        lblLevel.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblLevel];
        
        UILabel* lblExp = [[UILabel alloc] initWithFrame:CGRectMake(160, 68, 200, 12)];
        lblExp.textColor = [UIColor lightGrayColor];
        lblExp.text = [NSString stringWithFormat:@"经验值:%@",[UserInstance ShardInstnce].jingyan];
        lblExp.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblExp];
        
        UILabel* lblFufen1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 112, 200, 12)];
        lblFufen1.textColor = [UIColor whiteColor];
        lblFufen1.text = @"可用咖豆:";
        lblFufen1.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblFufen1];
        
        UILabel* lblFufen2 = [[UILabel alloc] initWithFrame:CGRectMake(65, 112, 200, 12)];
        lblFufen2.textColor = mainColor;
        lblFufen2.text = [UserInstance ShardInstnce].score;
        lblFufen2.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblFufen2];
        
        UILabel* lblMoney1 = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth/2+10, 112, 200, 12)];
        lblMoney1.textColor = [UIColor whiteColor];
        lblMoney1.text = @"可用夺宝币:";
        lblMoney1.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblMoney1];
        
        UILabel* lblMoney2 = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth/2+20+55, 112, 200, 12)];
        lblMoney2.textColor = mainColor;
        lblMoney2.text = [UserInstance ShardInstnce].money;
        lblMoney2.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblMoney2];
        
        //底部画线
        UIImageView* horiLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 101, mainWidth, 0.5)];
        horiLine.backgroundColor = [UIColor whiteColor];
        [v addSubview:horiLine];
        
        UIImageView* vertLine = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2-0.25, 101, 0.5, 39)];
        vertLine.backgroundColor = [UIColor whiteColor];
        [v addSubview:vertLine];
    }
    return self;
}

- (void)btnPayAction
{
    if(delegate)
    {
        [delegate btnPayAction];
    }
}

- (void)imgHeadClicked
{
    if (delegate) {
        [delegate imgHeadClicked];
    }
}
@end
