//
//  ProductCalculateVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductCalculateVC.h"
#import "ProductModel.h"
#import "Calculate100VC.h"
#import "LotteryWebsiteVC.h"

@interface ProductCalculateVC ()
{
    UILabel* lukyNo;
    ProductInfo         *myInfo;
    ProductInfoChild    *myInfoChild;
}
@end

@implementation ProductCalculateVC
- (id)initWithGoodsId:(ProductInfo*)info codeId:(ProductInfoChild*)infoChild
{
    self = [super init];
    if(self)
    {
        myInfo = info;
        myInfoChild = infoChild;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"计算结果";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIScrollView* scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.contentSize = CGSizeMake(mainWidth, 770);
    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    //-------------------------------------------------------------------------------------------------
    UIView* vvv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 80)];
    vvv.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:vvv];
    
    UILabel* calculate = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 200, 24)];
    calculate.text = @"计算结果";
    calculate.font = [UIFont systemFontOfSize:17];
    calculate.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv addSubview:calculate];
    
    UILabel* No = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 100, 15)];
    No.text = @"幸运号码:";
    No.font = [UIFont systemFontOfSize:14];
    No.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv addSubview:No];
    
    lukyNo = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 15)];
    lukyNo.font = [UIFont systemFontOfSize:14];
    lukyNo.textColor = [UIColor redColor];
    lukyNo.text = myInfo.q_user_code;
    [vvv addSubview:lukyNo];
    //-------------------------------------------------------------------------------------------------
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, mainWidth, mainWidth/3.6)];
    img.image = [UIImage imageNamed:@"Calculate"];
    [scroll addSubview:img];
    //-------------------------------------------------------------------------------------------------
    UIView* vvv1 = [[UIView alloc]initWithFrame:CGRectMake(0, 80+mainWidth/3.6, mainWidth, 100)];
    vvv1.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:vvv1];
    
    UILabel* calculate1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 200, 24)];
    calculate1.text = @"数值A";
    calculate1.font = [UIFont systemFontOfSize:17];
    calculate1.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv1 addSubview:calculate1];
    
    UILabel* No1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 44, mainWidth-32, 30)];
    No1.text = @"= 截取该奖品开奖时间点前 最后100条全站奖品参与记录的时间 将这100个时间相加之和";
    No1.font = [UIFont systemFontOfSize:11];
    No1.textColor = [UIColor hexFloatColor:@"666666"];
    No1.lineBreakMode = NSLineBreakByWordWrapping;
    No1.numberOfLines = 2;
    [vvv1 addSubview:No1];
    
    UILabel* No11 = [[UILabel alloc]initWithFrame:CGRectMake(16, 80, 100, 15)];
    No11.text = @"= ";
    No11.font = [UIFont systemFontOfSize:11];
    No11.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv1 addSubview:No11];
    
    UILabel* No111 = [[UILabel alloc]initWithFrame:CGRectMake(26, 80, 100, 15)];
    No111.text = myInfo.q_user_code;
    No111.font = [UIFont systemFontOfSize:11];
    No111.textColor = [UIColor redColor];
    [vvv1 addSubview:No111];
    
    UIButton* btnCaculate = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-40 - 60, 79, 80, 20)];
    [btnCaculate setTitle:@"展开" forState:UIControlStateNormal];
    [btnCaculate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnCaculate.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCaculate addTarget:self action:@selector(calculateClicking) forControlEvents:UIControlEventTouchUpInside];
    [vvv1 addSubview:btnCaculate];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 99.5, mainWidth, 0.5)];
    line.backgroundColor = myLineColor;
    [vvv1 addSubview:line];
    //-------------------------------------------------------------------------------------------------
    UIView* number2 = [[UIView alloc]initWithFrame:CGRectMake(0, 180+mainWidth/3.6, mainWidth, 100)];
    number2.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:number2];
    
    UILabel* calculate133 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 200, 24)];
    calculate133.text = @"数值B";
    calculate133.font = [UIFont systemFontOfSize:17];
    calculate133.textColor = [UIColor hexFloatColor:@"666666"];
    [number2 addSubview:calculate133];
    
    UILabel* No133 = [[UILabel alloc]initWithFrame:CGRectMake(16, 44, mainWidth-32, 30)];
    No133.text = @"= 最新一起时时彩开奖号码";
    No133.font = [UIFont systemFontOfSize:11];
    No133.textColor = [UIColor hexFloatColor:@"666666"];
    No133.lineBreakMode = NSLineBreakByWordWrapping;
    No133.numberOfLines = 2;
    [number2 addSubview:No133];
    
    UILabel* No1133 = [[UILabel alloc]initWithFrame:CGRectMake(16, 80, 100, 15)];
    No1133.text = @"= ";
    No1133.font = [UIFont systemFontOfSize:11];
    No1133.textColor = [UIColor hexFloatColor:@"666666"];
    [number2 addSubview:No1133];
    
    //时时彩号码
    UILabel* No11133 = [[UILabel alloc]initWithFrame:CGRectMake(26, 80, 100, 15)];
    No11133.text = myInfo.lottery_no;
    No11133.font = [UIFont systemFontOfSize:11];
    No11133.textColor = [UIColor redColor];
    [number2 addSubview:No11133];
    
    UILabel* No11133ff = [[UILabel alloc]initWithFrame:CGRectMake(100, 80, 200, 15)];
    No11133ff.text = [NSString stringWithFormat:@"(第%@期)",myInfo.lottery_time];
    No11133ff.font = [UIFont systemFontOfSize:11];
    No11133ff.textColor = [UIColor grayColor];
    [number2 addSubview:No11133ff];
    
    UIButton* btnCaculate33 = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-40 - 60, 79, 80, 20)];
    [btnCaculate33 setTitle:@"开奖查询" forState:UIControlStateNormal];
    [btnCaculate33 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnCaculate33.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCaculate33 addTarget:self action:@selector(OpencalculateURL) forControlEvents:UIControlEventTouchUpInside];
    [number2 addSubview:btnCaculate33];
    
    UIImageView* line33 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 99.5, mainWidth, 0.5)];
    line33.backgroundColor = myLineColor;
    [number2 addSubview:line33];

    //-------------------------------------------------------------------------------------------------
    UIView* vvv2 = [[UIView alloc]initWithFrame:CGRectMake(0, 280+mainWidth/3.6, mainWidth, 100)];
    vvv2.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:vvv2];
    
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 99.5, mainWidth, 0.5)];
    line1.backgroundColor = myLineColor;
    [vvv2 addSubview:line1];
    
    UILabel* calculate11 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 200, 24)];
    calculate11.text = @"数值C";
    calculate11.font = [UIFont systemFontOfSize:17];
    calculate11.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv2 addSubview:calculate11];
    
    UILabel* No2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 44, mainWidth-32, 15)];
    No2.text = @"= 本奖品总需参与人次";
    No2.font = [UIFont systemFontOfSize:11];
    No2.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv2 addSubview:No2];
    
    UILabel* No22 = [[UILabel alloc]initWithFrame:CGRectMake(16, 69, 100, 15)];
    No22.text = @"= ";
    No22.font = [UIFont systemFontOfSize:11];
    No22.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv2 addSubview:No22];
    
    UILabel* No222 = [[UILabel alloc]initWithFrame:CGRectMake(26, 69, 100, 15)];
    No222.text = myInfo.zongrenshu;
    No222.font = [UIFont systemFontOfSize:11];
    No222.textColor = [UIColor redColor];
    [vvv2 addSubview:No222];
    
    UILabel* No2222 = [[UILabel alloc]initWithFrame:CGRectMake(65, 69, 100, 15)];
    No2222.text = [NSString stringWithFormat:@"(第%@期)",myInfo.qishu];
    No2222.font = [UIFont systemFontOfSize:11];
    No2222.textColor = [UIColor hexFloatColor:@"666666"];
    [vvv2 addSubview:No2222];
    
    //-------------------------------------------------------------------------------------------------
    UIView* rule = [[UIView alloc]initWithFrame:CGRectMake(0, 380+mainWidth/3.6+10, mainWidth, 100)];
    rule.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:rule];
    
    UILabel* ruleTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    ruleTitle.font = [UIFont systemFontOfSize:17];
    ruleTitle.textColor = [UIColor hexFloatColor:@"666666"];
    ruleTitle.text = @"幸运号码计算规则";
    [rule addSubview:ruleTitle];
    
    UIImageView* point_1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 11, 11)];
    point_1.image = [UIImage imageNamed:@"point_01"];
    [rule addSubview:point_1];
    
    UILabel* title_point01 = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, mainWidth-40, 39)];
    title_point01.font = [UIFont systemFontOfSize:13];
    title_point01.textColor = [UIColor grayColor];
    title_point01.text = @"奖品的最后一个号码分配完毕后，将公示该分配时间点前本站全部奖品的最后一百个参与时间。";
    title_point01.lineBreakMode = NSLineBreakByWordWrapping;
    title_point01.numberOfLines = 3;
    [rule addSubview:title_point01];
    
    UIImageView* point_2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 11, 11)];
    point_2.image = [UIImage imageNamed:@"point_02"];
    [rule addSubview:point_2];
    
    UILabel* title_point02 = [[UILabel alloc]initWithFrame:CGRectMake(30, 85, mainWidth-40, 50)];
    title_point02.font = [UIFont systemFontOfSize:13];
    title_point02.textColor = [UIColor grayColor];
    title_point02.text = @"将这个一百个时间的数值进行求和（得出数值A）（每个时间按时、分、秒、毫秒的顺序组合，如20：15：25.362则为201525362）";
    title_point02.lineBreakMode = NSLineBreakByWordWrapping;
    title_point02.numberOfLines = 3;
    [rule addSubview:title_point02];
    
    UIImageView* point_3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 145, 11, 11)];
    point_3.image = [UIImage imageNamed:@"point_03"];
    [rule addSubview:point_3];
    
    UILabel* title_point03 = [[UILabel alloc]initWithFrame:CGRectMake(30, 140, mainWidth-40, 50)];
    title_point03.font = [UIFont systemFontOfSize:13];
    title_point03.textColor = [UIColor grayColor];
    title_point03.text = @"(数值A+最新一期时时彩开奖号码B）除以该奖品总需人次（数值C）得到的余数+原始数 10000001，得到最终幸运号码，拥有该幸运号码者，直接获得该奖品。";
    title_point03.lineBreakMode = NSLineBreakByWordWrapping;
    title_point03.numberOfLines = 3;
    [rule addSubview:title_point03];
}

- (void)calculateClicking
{
    Calculate100VC* vc = [[Calculate100VC alloc]initWithGoodsId:myInfo.pid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)OpencalculateURL
{
    LotteryWebsiteVC* vc = [[LotteryWebsiteVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
