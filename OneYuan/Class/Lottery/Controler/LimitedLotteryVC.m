//
//  LimitedLotteryVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LimitedLotteryVC.h"
#import "MCPagerView.h"
#import "LDProgressView.h"
#import "HomeModel.h"
#import <JT3DScrollView.h>
#import "Limite3Model.h"
#import "CartModel.h"
#import "ShopCartVC.h"
#import "CartInstance.h"
#import "StatementVC.h"

@interface LimitedLotteryVC ()<MCPagerViewDelegate,UIScrollViewDelegate>
{
//    UIScrollView        *scrollView;
    MCPagerView         *pagerView;
    int                 index;
    LDProgressView      *progress;
    NSArray             *itemArray;
    
    NSTimer* timer1;
    UILabel     *lblTimeH1;
    UILabel     *lblTimeM1;
    UILabel     *lblTimeS1;
    UIImageView *imgTimeBGH1;
    UIImageView *imgTimeBGM1;
    UIImageView *imgTimeBGS1;
    UILabel     *pointF1;
    UILabel     *pointS1;
    NSInteger    nowSeconds1;
    
    NSTimer* timer2;
    UILabel     *lblTimeH2;
    UILabel     *lblTimeM2;
    UILabel     *lblTimeS2;
    UIImageView *imgTimeBGH2;
    UIImageView *imgTimeBGM2;
    UIImageView *imgTimeBGS2;
    UILabel     *pointF2;
    UILabel     *pointS2;
    NSInteger    nowSeconds2;
    
    NSTimer     *timer3;
    UILabel     *lblTimeH3;
    UILabel     *lblTimeM3;
    UILabel     *lblTimeS3;
    UIImageView *imgTimeBGH3;
    UIImageView *imgTimeBGM3;
    UIImageView *imgTimeBGS3;
    UILabel     *pointF3;
    UILabel     *pointS3;
    NSInteger    nowSeconds3;
    
    __block NSMutableArray      *arrData;
    ThreeProModel* item0;
    ThreeProModel* item1;
    ThreeProModel* item2;
    
}
@property (strong, nonatomic) JT3DScrollView *scrollView;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) UIButton *previousButton;
@end

@implementation LimitedLotteryVC
@synthesize scrollView;
- (void)removeFromSuperview
{
    if(timer1)
    {
        [timer1 invalidate];
        timer1 = nil;
    }
    if(timer2)
    {
        [timer2 invalidate];
        timer2 = nil;
    }
    if(timer3)
    {
        [timer3 invalidate];
        timer3 = nil;
    }
}


- (id)initWithArray:(NSArray*)itemArr
{
    self = [super init];
    if(self)
    {
        itemArray = itemArr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"限时揭晓";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self actionCustomRightBtnWithNrlImage:@"" htlImage:@"" title:@"活动说明" action:^{
        StatementVC* vc = [[StatementVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.image = [UIImage imageNamed:@"limitedBG"];
    [self.view addSubview:bg];
    
    scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(32, self.view.frame.size.height*0.14, mainWidth-64, mainHeight/1.5)];
    [self.view addSubview:scrollView];
    self.scrollView.effect = JT3DScrollViewEffectDepth;
    
    [self loadLimitedPro:nil];
    
}

- (void)loadLimitedPro:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    [Limite3Model getLimite3Products:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        if (block!= NULL)
            block();
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSArray* list = [ThreeProModel arrayOfModelsFromDictionaries:@[datadict] error:NULL];
        if (!arrData) {
            arrData = [NSMutableArray arrayWithArray:list];
        }
        else
        {
            [arrData addObjectsFromArray:list];
        }
        if (arrData.count != 0)
        {
            if (arrData.count == 1) {
                [self createCardWithColor];
            }else if (arrData.count == 2)
            {
                [self createCardWithColor];
                [self createCardWithColor1];
            }else
            {
                [self createCardWithColor];
                [self createCardWithColor1];
                [self createCardWithColor2];
            }
        }else
        {
            [[XBToastManager ShardInstance]hideprogress];
            return ;
        }
        [[XBToastManager ShardInstance]hideprogress];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}
#define vWidth      view.frame.size.width
#define vHeight     view.frame.size.height
- (void)createCardWithColor
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    
    CGFloat x = self.scrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(x + width, height);
    
    ThreeProModel* item = [arrData objectAtIndex:0];
    item0 = item;
    
    UIImageView* limite10 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39, 39)];
    [view addSubview:limite10];
    
    UIImageView* imagePro = [[UIImageView alloc]initWithFrame:CGRectMake((vWidth-vHeight+200)/2, 10, vHeight-180-20, vHeight-180-20)];
    [imagePro setImage_oy:oyImageBaseUrl image:item.thumb];
    [view addSubview:imagePro];
    
    UILabel* proTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-180, vWidth-20, 15)];
    proTitle.text = [NSString stringWithFormat:@"(第%@期) %@",item.qishu,item.title];
    proTitle.textColor = [UIColor grayColor];
    proTitle.font = [UIFont systemFontOfSize:15];
    [view addSubview:proTitle];
    
    UILabel* zong = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-160, vWidth-20, 15)];
    zong.text = [NSString stringWithFormat:@"总需人数：%@",item.zongrenshu];
    zong.textColor = [UIColor grayColor];
    zong.font = [UIFont systemFontOfSize:15];
    [view addSubview:zong];
    
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, vHeight-139.5, vWidth, 0.5)];
    line1.backgroundColor = [UIColor hexFloatColor:@"666666"];
    [view addSubview:line1];

    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, vHeight-70, vWidth, 0.5)];
    line.backgroundColor = [UIColor hexFloatColor:@"666666"];
    [view addSubview:line];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, vHeight-139, vWidth, 139)];
    bgView.backgroundColor = BG_GRAY_COLOR;
    [view addSubview:bgView];
    if ([item.open_time intValue]<0 && [item.canyurenshu intValue]==0) {
        //参与人数为零，不予揭晓
        UILabel* alertLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, vWidth, 20)];
        alertLable.text = @"参与人数为0，不予揭晓";
        alertLable.font = [UIFont systemFontOfSize:17];
        alertLable.textColor = [UIColor grayColor];
        alertLable.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:alertLable];
        
    }
    else if ([item.open_time intValue] <= 0 && [item.canyurenshu intValue]!=0) {
        //已揭晓
        limite10.image = [UIImage imageNamed:@"limite10"];
        
        UILabel* jiexiao = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-140, vWidth-20, 70)];
        jiexiao.text = [NSString stringWithFormat:@"已揭晓"];
        jiexiao.textColor = [UIColor grayColor];
        jiexiao.textAlignment = NSTextAlignmentLeft;
        jiexiao.font = [UIFont systemFontOfSize:30];
        [view addSubview:jiexiao];
        
        AttributedLabel* joint = [[AttributedLabel alloc]initWithFrame:CGRectMake(mainWidth/2, vHeight-120, 100, 70)];
        joint.text = [NSString stringWithFormat:@"参与人数：%@",item.canyurenshu];
        [joint setFont:[UIFont systemFontOfSize:18] fromIndex:0 length:joint.text.length];
        [joint setColor:[UIColor grayColor] fromIndex:0 length:5];
        [joint setColor:mainColor fromIndex:5 length:item.canyurenshu.length];
        joint.textColor = [UIColor grayColor];
        joint.textAlignment = NSTextAlignmentRight;
        joint.font = [UIFont systemFontOfSize:18];
        [view addSubview:joint];
        
        
        UIImageView* headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, vHeight-75, 50, 50)];
        [headImg setImage_oy:oyImageBaseUrl image:item.thumb];
        headImg.layer.masksToBounds = YES;
        headImg.layer.cornerRadius = 25;
        [view addSubview:headImg];
        
        UILabel* title1 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-75, vWidth-65-10, 15)];
        title1.text = [NSString stringWithFormat:@"恭喜 %@ 中奖了 %@",item.username,item.title];
        title1.textColor = [UIColor grayColor];
        title1.font = [UIFont systemFontOfSize:12];
        [view addSubview:title1];
        
        AttributedLabel* title2 = [[AttributedLabel alloc]initWithFrame:CGRectMake(65, vHeight-55, vWidth-65-10, 15)];
        title2.text = [NSString stringWithFormat:@"幸运号码：%@",item.q_user_code];
        [title2 setColor:mainColor fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:0 length:5];
        [title2 setColor:[UIColor grayColor] fromIndex:0 length:5];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:12];
        [view addSubview:title2];
        
        UILabel* title3 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-35, vWidth-75, 15)];
        NSString* time = [WenzhanTool formateDateStr:item.xsjx_time];
        title3.text = [NSString stringWithFormat:@"揭晓时间：%@",time];
        title3.textColor = [UIColor grayColor];
        title3.font = [UIFont systemFontOfSize:12];
        [view addSubview:title3];
        
    }
    else
    {
        CGFloat CellWidth = view.frame.size.width;
        //未揭晓
        limite10.image = [UIImage imageNamed:@"unlimite10"];
        
        UIImageView* clockR = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 36, 36)];
        clockR.image = [UIImage imageNamed:@"clockR"];
        [bgView addSubview:clockR];
        
        UILabel* title2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, CellWidth-60, 15)];
        title2.text = [NSString stringWithFormat:@"揭晓倒计时"];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:title2];
        
        imgTimeBGH1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2, 36, 60, 40)];
        imgTimeBGH1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGH1.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGH1];
        
        pointF1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+60, 36, 20, 40)];
        pointF1.font = [UIFont systemFontOfSize:25];
        pointF1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointF1.text = @":";
        pointF1.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointF1];
        
        imgTimeBGM1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+80, 36, 60, 40)];
        imgTimeBGM1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGM1.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGM1];
        
        pointS1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+140, 36, 20, 40)];
        pointS1.font = [UIFont systemFontOfSize:25];
        pointS1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointS1.text = @":";
        pointS1.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointS1];
        
        imgTimeBGS1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+160, 36, 60, 40)];
        imgTimeBGS1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGS1.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGS1];
        
        lblTimeH1 = [[UILabel alloc] init];
        lblTimeH1.font = [UIFont systemFontOfSize:25];
        lblTimeH1.textColor = mainColor;
        lblTimeH1.text = @"00";
        [imgTimeBGH1 addSubview:lblTimeH1];
        
        lblTimeM1 = [[UILabel alloc] init];
        lblTimeM1.font = [UIFont systemFontOfSize:25];
        lblTimeM1.textColor = mainColor;
        lblTimeM1.text = @"00";
        [imgTimeBGM1 addSubview:lblTimeM1];
        
        lblTimeS1 = [[UILabel alloc] init];
        lblTimeS1.font = [UIFont systemFontOfSize:25];
        lblTimeS1.textColor = mainColor;
        lblTimeS1.text = @"00";
        [imgTimeBGS1 addSubview:lblTimeS1];
        
        if(timer1)
        {
            [timer1 invalidate];
            timer1 = nil;
        }
        nowSeconds1 = [item.open_time integerValue];
        timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction1) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
        
        UIButton* buyNow1 = [[UIButton alloc]initWithFrame:CGRectMake((CellWidth-220)/2, 90, 220, 40)];
        buyNow1.layer.cornerRadius = 3;
        buyNow1.layer.cornerRadius = 3;
        buyNow1.titleLabel.font = [UIFont systemFontOfSize:20];
        [bgView addSubview:buyNow1];
        
        if ([item.shenyurenshu intValue] == 0)
        {
            [buyNow1 setTitle:@"已满员" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:[UIColor lightGrayColor]];
            [buyNow1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        else
        {
            [buyNow1 setTitle:@"立即夺宝" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:mainColor];
            [buyNow1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buyNow1 addTarget:self action:@selector(addAndGotoCartAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

- (void)createCardWithColor1
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    
    CGFloat x = self.scrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8.0;
    
    UIImageView* limite10 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39, 39)];
    [view addSubview:limite10];
    
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(x + width, height);
    
    ThreeProModel* item = [arrData objectAtIndex:1];
    item1 = item;
    
    UIImageView* imagePro = [[UIImageView alloc]initWithFrame:CGRectMake((vWidth-vHeight+200)/2, 10, vHeight-180-20, vHeight-180-20)];
    [imagePro setImage_oy:oyImageBaseUrl image:item.thumb];
    [view addSubview:imagePro];
    
    UILabel* proTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-180, vWidth-20, 15)];
    proTitle.text = [NSString stringWithFormat:@"(第%@期) %@",item.qishu,item.title];
    proTitle.textColor = [UIColor grayColor];
    proTitle.font = [UIFont systemFontOfSize:15];
    [view addSubview:proTitle];
    
    UILabel* zong = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-160, vWidth-20, 15)];
    zong.text = [NSString stringWithFormat:@"总需人数：%@",item.zongrenshu];
    zong.textColor = [UIColor grayColor];
    zong.font = [UIFont systemFontOfSize:15];
    [view addSubview:zong];
    
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, vHeight-139.5, vWidth, 0.5)];
    line1.backgroundColor = [UIColor hexFloatColor:@"666666"];
    [view addSubview:line1];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, vHeight-139, vWidth, 139)];
    bgView.backgroundColor = BG_GRAY_COLOR;
    [view addSubview:bgView];
    
    if ([item.open_time intValue] < 0 && [item.canyurenshu intValue]==0) {
        //参与人数为零，不予揭晓
        UILabel* alertLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, vWidth, 20)];
        alertLable.text = @"参与人数为0，不予揭晓";
        alertLable.font = [UIFont systemFontOfSize:17];
        alertLable.textColor = [UIColor grayColor];
        alertLable.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:alertLable];
        
    }
    else if ([item.open_time intValue] <= 0 && [item.canyurenshu intValue]!=0) {
        //已揭晓
        limite10.image = [UIImage imageNamed:@"limite15"];
        
        UILabel* jiexiao = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-140, vWidth-20, 70)];
        jiexiao.text = [NSString stringWithFormat:@"已揭晓"];
        jiexiao.textColor = [UIColor grayColor];
        jiexiao.textAlignment = NSTextAlignmentLeft;
        jiexiao.font = [UIFont systemFontOfSize:30];
        [view addSubview:jiexiao];
        
        AttributedLabel* joint = [[AttributedLabel alloc]initWithFrame:CGRectMake(mainWidth/2, vHeight-120, vWidth-20, 70)];
        joint.text = [NSString stringWithFormat:@"参与人数：%@",item.canyurenshu];
        [joint setFont:[UIFont systemFontOfSize:18] fromIndex:0 length:joint.text.length];
        [joint setColor:[UIColor grayColor] fromIndex:0 length:5];
        [joint setColor:mainColor fromIndex:5 length:item.canyurenshu.length];
        joint.textColor = [UIColor grayColor];
        joint.textAlignment = NSTextAlignmentRight;
        joint.font = [UIFont systemFontOfSize:18];
        [view addSubview:joint];
        
        
        UIImageView* headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, vHeight-75, 50, 50)];
        [headImg setImage_oy:oyImageBaseUrl image:item.thumb];
        headImg.layer.masksToBounds = YES;
        headImg.layer.cornerRadius = 25;
        [view addSubview:headImg];
        
        UILabel* title1 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-75, vWidth-65-10, 15)];
        title1.text = [NSString stringWithFormat:@"恭喜 %@ 中奖了 %@",item.username,item.title];
        title1.textColor = [UIColor grayColor];
        title1.font = [UIFont systemFontOfSize:12];
        [view addSubview:title1];
        
        AttributedLabel* title2 = [[AttributedLabel alloc]initWithFrame:CGRectMake(65, vHeight-55, vWidth-65-10, 15)];
        title2.text = [NSString stringWithFormat:@"幸运号码：%@",item.q_user_code];
        [title2 setColor:mainColor fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:0 length:5];
        [title2 setColor:[UIColor grayColor] fromIndex:0 length:5];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:12];
        [view addSubview:title2];
        
        UILabel* title3 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-35, vWidth-65-10, 15)];
        NSString* time = [WenzhanTool formateDateStr:item.xsjx_time];
        title3.text = [NSString stringWithFormat:@"揭晓时间：%@",time];
        title3.textColor = [UIColor grayColor];
        title3.font = [UIFont systemFontOfSize:12];
        [view addSubview:title3];
        
    }
    else
    {
        CGFloat CellWidth = view.frame.size.width;
        
        //未揭晓
        limite10.image = [UIImage imageNamed:@"unlimite15"];
        
        UIImageView* clockR = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 36, 36)];
        clockR.image = [UIImage imageNamed:@"clockR"];
        [bgView addSubview:clockR];
        
        UILabel* title2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, CellWidth-60, 15)];
        title2.text = [NSString stringWithFormat:@"揭晓倒计时"];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:title2];
        
        imgTimeBGH2 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2, 36, 60, 40)];
        imgTimeBGH2.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGH2.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGH2];
        
        pointF2 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+60, 36, 20, 40)];
        pointF2.font = [UIFont systemFontOfSize:25];
        pointF2.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointF2.text = @":";
        pointF2.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointF2];
        
        imgTimeBGM2 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+80, 36, 60, 40)];
        imgTimeBGM2.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGM2.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGM2];
        
        pointS2 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+140, 36, 20, 40)];
        pointS2.font = [UIFont systemFontOfSize:25];
        pointS2.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointS2.text = @":";
        pointS2.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointS2];
        
        imgTimeBGS2 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+160, 36, 60, 40)];
        imgTimeBGS2.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGS2.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGS2];
        
        lblTimeH2 = [[UILabel alloc] init];
        lblTimeH2.font = [UIFont systemFontOfSize:25];
        lblTimeH2.textColor = mainColor;
        lblTimeH2.text = @"00";
        [imgTimeBGH2 addSubview:lblTimeH2];
        
        lblTimeM2 = [[UILabel alloc] init];
        lblTimeM2.font = [UIFont systemFontOfSize:25];
        lblTimeM2.textColor = mainColor;
        lblTimeM2.text = @"00";
        [imgTimeBGM2 addSubview:lblTimeM2];
        
        lblTimeS2 = [[UILabel alloc] init];
        lblTimeS2.font = [UIFont systemFontOfSize:25];
        lblTimeS2.textColor = mainColor;
        lblTimeS2.text = @"00";
        [imgTimeBGS2 addSubview:lblTimeS2];
        
        if(timer2)
        {
            [timer2 invalidate];
            timer2 = nil;
        }
        nowSeconds2 = [item.open_time integerValue];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction2) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
        
        
        UIButton* buyNow1 = [[UIButton alloc]initWithFrame:CGRectMake((CellWidth-220)/2, 90, 220, 40)];
        buyNow1.layer.cornerRadius = 3;
        buyNow1.titleLabel.font = [UIFont systemFontOfSize:20];
        [bgView addSubview:buyNow1];
        
        if ([item.shenyurenshu intValue] == 0)
        {
            [buyNow1 setTitle:@"已满员" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:[UIColor lightGrayColor]];
            [buyNow1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        else
        {
            [buyNow1 setTitle:@"立即夺宝" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:mainColor];
            [buyNow1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buyNow1 addTarget:self action:@selector(addAndGotoCartAction1) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
}

- (void)createCardWithColor2
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    
    CGFloat x = self.scrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8.0;
    
    UIImageView* limite10 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39, 39)];
    limite10.image = [UIImage imageNamed:@"limite22"];
    [view addSubview:limite10];
    
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(x + width, height);
    
    ThreeProModel* item = [arrData objectAtIndex:2];
    item2 = item;
    
    UIImageView* imagePro = [[UIImageView alloc]initWithFrame:CGRectMake((vWidth-vHeight+200)/2, 10, vHeight-180-20, vHeight-180-20)];
    [imagePro setImage_oy:oyImageBaseUrl image:item.thumb];
    [view addSubview:imagePro];
    
    UILabel* proTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-180, vWidth-20, 15)];
    proTitle.text = [NSString stringWithFormat:@"(第%@期) %@",item.qishu,item.title];
    proTitle.textColor = [UIColor grayColor];
    proTitle.font = [UIFont systemFontOfSize:15];
    [view addSubview:proTitle];
    
    UILabel* zong = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-160, vWidth-20, 15)];
    zong.text = [NSString stringWithFormat:@"总需人数：%@",item.zongrenshu];
    zong.textColor = [UIColor grayColor];
    zong.font = [UIFont systemFontOfSize:15];
    [view addSubview:zong];
    
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, vHeight-139.5, vWidth, 0.5)];
    line1.backgroundColor = myLineColor;
    [view addSubview:line1];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, vHeight-139, vWidth, 139)];
    bgView.backgroundColor = BG_GRAY_COLOR;
    [view addSubview:bgView];
    
    if ([item.open_time intValue]<0 && [item.canyurenshu intValue]==0)
    {
        //参与人数为零，不予揭晓
        UILabel* alertLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, vWidth, 20)];
        alertLable.text = @"参与人数为0，不予揭晓";
        alertLable.font = [UIFont systemFontOfSize:17];
        alertLable.textColor = [UIColor grayColor];
        alertLable.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:alertLable];
        
    }
    else if ([item.open_time intValue] <= 0 && [item.canyurenshu intValue]!=0)
    {
        //已揭晓
        limite10.image = [UIImage imageNamed:@"limite22"];
        
        UILabel* jiexiao = [[UILabel alloc]initWithFrame:CGRectMake(10, vHeight-140, vWidth-20, 70)];
        jiexiao.text = [NSString stringWithFormat:@"已揭晓"];
        jiexiao.textColor = [UIColor grayColor];
        jiexiao.textAlignment = NSTextAlignmentLeft;
        jiexiao.font = [UIFont systemFontOfSize:30];
        [view addSubview:jiexiao];
        
        AttributedLabel* joint = [[AttributedLabel alloc]initWithFrame:CGRectMake(mainWidth/2, vHeight-120, vWidth-20, 70)];
        joint.text = [NSString stringWithFormat:@"参与人数：%@",item.canyurenshu];
        [joint setFont:[UIFont systemFontOfSize:18] fromIndex:0 length:joint.text.length];
        [joint setColor:[UIColor grayColor] fromIndex:0 length:5];
        [joint setColor:mainColor fromIndex:5 length:item.canyurenshu.length];
        joint.textColor = [UIColor grayColor];
        joint.textAlignment = NSTextAlignmentRight;
        joint.font = [UIFont systemFontOfSize:18];
        [view addSubview:joint];
        
        
        UIImageView* headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, vHeight-75, 50, 50)];
        [headImg setImage_oy:oyImageBaseUrl image:item.thumb];
        headImg.layer.masksToBounds = YES;
        headImg.layer.cornerRadius = 25;
        [view addSubview:headImg];
        
        UILabel* title1 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-75, vWidth-65-10, 15)];
        title1.text = [NSString stringWithFormat:@"恭喜 %@ 中奖了 %@",item.username,item.title];
        title1.textColor = [UIColor grayColor];
        title1.font = [UIFont systemFontOfSize:12];
        [view addSubview:title1];
        
        AttributedLabel* title2 = [[AttributedLabel alloc]initWithFrame:CGRectMake(65, vHeight-55, vWidth-65-10, 15)];
        title2.text = [NSString stringWithFormat:@"幸运号码：%@",item.q_user_code];
        [title2 setColor:mainColor fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:5 length:item.q_user_code.length];
        [title2 setFont:[UIFont systemFontOfSize:12] fromIndex:0 length:5];
        [title2 setColor:[UIColor grayColor] fromIndex:0 length:5];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:12];
        [view addSubview:title2];
        
        UILabel* title3 = [[UILabel alloc]initWithFrame:CGRectMake(65, vHeight-35, vWidth-65-10, 15)];
        NSString* time = [WenzhanTool formateDateStr:item.xsjx_time];
        title3.text = [NSString stringWithFormat:@"揭晓时间：%@",time];
        title3.textColor = [UIColor grayColor];
        title3.font = [UIFont systemFontOfSize:12];
        [view addSubview:title3];
        
    }
    else
    {
        CGFloat CellWidth = view.frame.size.width;
        
        //未揭晓
        limite10.image = [UIImage imageNamed:@"unlimite22"];
        
        UIImageView* clockR = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 36, 36)];
        clockR.image = [UIImage imageNamed:@"clockR"];
        [bgView addSubview:clockR];
        
        UILabel* title2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, CellWidth-60, 15)];
        title2.text = [NSString stringWithFormat:@"揭晓倒计时"];
        title2.textColor = [UIColor grayColor];
        title2.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:title2];
        
        imgTimeBGH3 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2, 36, 60, 40)];
        imgTimeBGH3.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGH3.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGH3];
        
        pointF3 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+60, 36, 20, 40)];
        pointF3.font = [UIFont systemFontOfSize:25];
        pointF3.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointF3.text = @":";
        pointF3.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointF3];
        
        imgTimeBGM3 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+80, 36, 60, 40)];
        imgTimeBGM3.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGM3.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGM3];
        
        pointS3 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+140, 36, 20, 40)];
        pointS3.font = [UIFont systemFontOfSize:25];
        pointS3.textColor = [UIColor hexFloatColor:@"3d3d3d"];
        pointS3.text = @":";
        pointS3.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:pointS3];
        
        imgTimeBGS3 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+160, 36, 60, 40)];
        imgTimeBGS3.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
        imgTimeBGS3.layer.cornerRadius = 3;
        [bgView addSubview:imgTimeBGS3];
        
        lblTimeH3 = [[UILabel alloc] init];
        lblTimeH3.font = [UIFont systemFontOfSize:25];
        lblTimeH3.textColor = mainColor;
        lblTimeH3.text = @"00";
        [imgTimeBGH3 addSubview:lblTimeH3];
        
        lblTimeM3 = [[UILabel alloc] init];
        lblTimeM3.font = [UIFont systemFontOfSize:25];
        lblTimeM3.textColor = mainColor;
        lblTimeM3.text = @"00";
        [imgTimeBGM3 addSubview:lblTimeM3];
        
        lblTimeS3 = [[UILabel alloc] init];
        lblTimeS3.font = [UIFont systemFontOfSize:25];
        lblTimeS3.textColor = mainColor;
        lblTimeS3.text = @"00";
        [imgTimeBGS3 addSubview:lblTimeS3];
        
        if(timer3)
        {
            [timer3 invalidate];
            timer3 = nil;
        }
        nowSeconds3 = [item.open_time integerValue];
        timer3 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction3) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];
        
        UIButton* buyNow1 = [[UIButton alloc]initWithFrame:CGRectMake((CellWidth-220)/2, 90, 220, 40)];
        buyNow1.layer.cornerRadius = 3;
        buyNow1.layer.cornerRadius = 3;
        buyNow1.titleLabel.font = [UIFont systemFontOfSize:20];
        [bgView addSubview:buyNow1];
        
        if ([item.shenyurenshu intValue] == 0)
        {
            [buyNow1 setTitle:@"已满员" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:[UIColor lightGrayColor]];
            [buyNow1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        else
        {
            [buyNow1 setTitle:@"立即夺宝" forState:UIControlStateNormal];
            [buyNow1 setBackgroundColor:mainColor];
            [buyNow1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buyNow1 addTarget:self action:@selector(addAndGotoCartAction2) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)timerAction1
{
    if(nowSeconds1 < 0)
    {
        [timer1 invalidate];
        timer1 = nil;
        return;
    }
    nowSeconds1--;
    if(nowSeconds1 <= 0)
    {
        [self createCardWithColor];
        
        return;
    }
    int m = (int)nowSeconds1 / 3600;         //小时
    NSString* f0 = m > 9 ? [NSString stringWithFormat:@"%d",m] : [@"0" stringByAppendingFormat:@"%d",m];
    int s = (int)(nowSeconds1/60) - m*60;   //分钟
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = (int)(nowSeconds1 - m*3600 - s*60);              //秒
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    
    lblTimeH1.text = [NSString stringWithFormat:@"%@",f0];
    CGSize sss = [lblTimeH1.text textSizeWithFont:lblTimeH1.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeH1.frame = CGRectMake((imgTimeBGH1.frame.size.width - sss.width) / 2, (imgTimeBGH1.frame.size.height - sss.height) /2, sss.width, sss.height);
    
    lblTimeM1.text = [NSString stringWithFormat:@"%@",f1];
    CGSize sss1 = [lblTimeM1.text textSizeWithFont:lblTimeM1.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeM1.frame = CGRectMake((imgTimeBGM1.frame.size.width - sss.width) / 2, (imgTimeBGM1.frame.size.height - sss1.height) /2, sss1.width, sss1.height);
    
    lblTimeS1.text = [NSString stringWithFormat:@"%@",f2];
    CGSize sss2 = [lblTimeS1.text textSizeWithFont:lblTimeS1.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeS1.frame = CGRectMake((imgTimeBGS1.frame.size.width - sss2.width) / 2, (imgTimeBGS1.frame.size.height - sss2.height) /2, sss2.width, sss2.height);
    
}

- (void)timerAction2
{
    if(nowSeconds2 < 0)
    {
        [timer2 invalidate];
        timer2 = nil;
        return;
    }
    nowSeconds2--;
    if(nowSeconds2 <= 0)
    {
        [self createCardWithColor1];
        return;
    }
    int m = (int)nowSeconds2 / 3600;         //小时
    NSString* f0 = m > 9 ? [NSString stringWithFormat:@"%d",m] : [@"0" stringByAppendingFormat:@"%d",m];
    int s = (int)(nowSeconds2/60) - m*60;   //分钟
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = (int)(nowSeconds2 - m*3600 - s*60);              //秒
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    
    lblTimeH2.text = [NSString stringWithFormat:@"%@",f0];
    CGSize sss = [lblTimeH2.text textSizeWithFont:lblTimeH2.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeH2.frame = CGRectMake((imgTimeBGH2.frame.size.width - sss.width) / 2, (imgTimeBGH2.frame.size.height - sss.height) /2, sss.width, sss.height);
    
    lblTimeM2.text = [NSString stringWithFormat:@"%@",f1];
    CGSize sss1 = [lblTimeM2.text textSizeWithFont:lblTimeM2.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeM2.frame = CGRectMake((imgTimeBGM2.frame.size.width - sss.width) / 2, (imgTimeBGM2.frame.size.height - sss1.height) /2, sss1.width, sss1.height);
    
    lblTimeS2.text = [NSString stringWithFormat:@"%@",f2];
    CGSize sss2 = [lblTimeS2.text textSizeWithFont:lblTimeS2.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeS2.frame = CGRectMake((imgTimeBGS2.frame.size.width - sss2.width) / 2, (imgTimeBGS2.frame.size.height - sss2.height) /2, sss2.width, sss2.height);
    
}

- (void)timerAction3
{
    if(nowSeconds3 < 0)
    {
        [timer3 invalidate];
        timer3 = nil;
        return;
    }
    nowSeconds3--;
    if(nowSeconds3 <= 0)
    {
        [self createCardWithColor2];
        
        return;
    }
    int m = (int)nowSeconds3 / 3600;         //小时
    NSString* f0 = m > 9 ? [NSString stringWithFormat:@"%d",m] : [@"0" stringByAppendingFormat:@"%d",m];
    int s = (int)(nowSeconds3/60) - m*60;   //分钟
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = (int)(nowSeconds3 - m*3600 - s*60);              //秒
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    
    lblTimeH3.text = [NSString stringWithFormat:@"%@",f0];
    CGSize sss = [lblTimeH3.text textSizeWithFont:lblTimeH3.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeH3.frame = CGRectMake((imgTimeBGH3.frame.size.width - sss.width) / 2, (imgTimeBGH3.frame.size.height - sss.height) /2, sss.width, sss.height);
    
    lblTimeM3.text = [NSString stringWithFormat:@"%@",f1];
    CGSize sss1 = [lblTimeM3.text textSizeWithFont:lblTimeM3.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeM3.frame = CGRectMake((imgTimeBGM3.frame.size.width - sss.width) / 2, (imgTimeBGM3.frame.size.height - sss1.height) /2, sss1.width, sss1.height);
    
    lblTimeS3.text = [NSString stringWithFormat:@"%@",f2];
    CGSize sss2 = [lblTimeS3.text textSizeWithFont:lblTimeS3.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTimeS3.frame = CGRectMake((imgTimeBGS3.frame.size.width - sss2.width) / 2, (imgTimeBGS3.frame.size.height - sss2.height) /2, sss2.width, sss2.height);
    
}

- (void)addAndGotoCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",item0._id];
    item.title = item0.title;
    item.qishu = item0.qishu;
    item.yunjiage = item0.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = item0.sid;
    item.money = item0.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,item0.thumb];
    
    UIImageView* imgPro = [[UIImageView alloc]initWithImage:[UIImage imageNamed:item0.thumb]];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    
    
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addAndGotoCartAction1
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",item1._id];
    item.title = item1.title;
    item.qishu = item1.qishu;
    item.yunjiage = item1.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = item1.sid;
    item.money = item1.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,item1.thumb];
    
    UIImageView* imgPro = [[UIImageView alloc]initWithImage:[UIImage imageNamed:item1.thumb]];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    
    
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addAndGotoCartAction2
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",item2._id];
    item.title = item2.title;
    item.qishu = item2.qishu;
    item.yunjiage = item2.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = item2.sid;
    item.money = item2.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,item2.thumb];
    
    UIImageView* imgPro = [[UIImageView alloc]initWithImage:[UIImage imageNamed:item2.thumb]];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    
    
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
