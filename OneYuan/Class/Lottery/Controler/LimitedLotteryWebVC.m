//
//  LimitedLotteryWebVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/4.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LimitedLotteryWebVC.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "ProBuyingProgress.h"
#import "Limite3Model.h"
#import "SuperShareVC.h"
#import "RegisterVC.h"
#import "FreeBuySuccessVC.h"
#import "UIViewController+MJPopupViewController.h"
#import "LimitePopoverVC.h"
#import "VOSegmentedControl.h"
#import "BuyRecordPopVC.h"
#import "ActivityRuleVC.h"

@interface LimitedLotteryWebVC ()<LimitePopoverViewDelegate,BuyRecordPopoverViewDelegate,ActivityRulePopoverViewDelegate>
{
    NSUInteger  state;
    UIScrollView* bgScrollView;
    
    NSTimer     *timer1;
    UILabel     *lblTimeH1;
    UILabel     *lblTimeM1;
    UILabel     *lblTimeS1;
    UIImageView *imgTimeBGH1;
    UIImageView *imgTimeBGM1;
    UIImageView *imgTimeBGS1;
    UILabel     *pointF1;
    UILabel     *pointS1;
    NSInteger   nowSeconds1;
    
    ProBuyingProgress   *progress;
    HuaFeiModel* huaitem;
    AutoLotteryModel* lotteryModel;
    LimitePopoverVC       * popVC;
    BuyRecordPopVC          *recordVC;
    ActivityRuleVC          *activityVC;
    
    NSMutableArray* arrData;
    NSMutableArray* arrProItem;
    NSUInteger      indexS;
    NSMutableArray* carMakes;
    
    UIView*         lotteryView;
    UIButton* btnHigh;
    UIButton* btnFree;
}
@property (nonatomic, strong) UILabel *lblLottery;
@end

@implementation LimitedLotteryWebVC
@synthesize lblLottery;
- (id)initWithArray:(NSString*)itemArr
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)removeFromSuperview
{
    if(timer1)
    {
        [timer1 invalidate];
        timer1 = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.title = @"限时揭晓";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-49)];
    bgScrollView.backgroundColor = BG_COLOR;
    bgScrollView.contentSize = CGSizeMake(mainWidth, mainWidth*0.32+80 + (mainWidth-64)*0.56 +10+(mainWidth-64)*0.54+50+49+10);
    [self.view addSubview:bgScrollView];
    
    UIImageView* banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth*0.32)];
    banner.image = [UIImage imageNamed:@"banner"];
    [bgScrollView addSubview:banner];
    
    UIButton* btnRecord = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-90, 10, 80, 30)];
    btnRecord.backgroundColor = [UIColor redColor];
    btnRecord.layer.cornerRadius = 4;
    [btnRecord setTitle:@"参与记录" forState:UIControlStateNormal];
    [btnRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRecord.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRecord addTarget:self action:@selector(paticipateRecordClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:btnRecord];
    
    UILabel* period = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-103, self.view.frame.size.height*0.18 - 30, 80, 15)];
    period.text = @"当前阶段";
    period.textColor = [UIColor whiteColor];
    period.font = [UIFont systemFontOfSize:11];
//    [bgScrollView addSubview:period];
    
    UIImageView* card100 = [[UIImageView alloc]initWithFrame:CGRectMake(32, mainWidth*0.32+70, mainWidth-64, (mainWidth-64)*0.56)];
    card100.image = [UIImage imageNamed:@"goods"];
    [bgScrollView addSubview:card100];
    
    UIButton* btnRule = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-32-90, mainWidth*0.32+70, 80, 30)];
    btnRule.backgroundColor = [UIColor clearColor];
    [btnRule setTitle:@"活动规则>>" forState:UIControlStateNormal];
    [btnRule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRule.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRule addTarget:self action:@selector(activityRuleClicked) forControlEvents:UIControlEventTouchUpInside];
    btnRule.titleLabel.textAlignment = NSTextAlignmentRight;
    [bgScrollView addSubview:btnRule];
    
    indexS = 0;
    [self loadData];
    
}

- (void)loadData
{
    [[XBToastManager ShardInstance]showprogress];
    [Limite3Model getLimiteTimePeriod:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
//        [[XBToastManager ShardInstance]hideprogress];
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        if (datadict == nil) {
            return ;
        }
        NSError* error = nil;
        NSArray* huafeiList = [HuaFeiModel arrayOfModelsFromDictionaries:@[datadict] error:&error];
        if(!arrData)
        {
            arrData = [NSMutableArray arrayWithArray:huafeiList];
        }
        else{
            [arrData addObjectsFromArray:huafeiList];
        }
        //获取当前的时间阶段
        carMakes  = [[NSMutableArray alloc] init];
        for (int i=0; i<arrData.count; i++) {
            HuaFeiModel* model = [arrData objectAtIndex:i];
            NSDictionary* dict;
            
            if ([model.status intValue] == 0) {
                //未开启
                dict = @{@"text":model.xsjx_time1,@"image":@"unopen",@"selectedImage":@"unopen"};
            }
            else if ([model.status intValue] == 1) {
                //进行中
                indexS = i;
                dict = @{@"text":model.xsjx_time1,@"image":@"doing",@"selectedImage":@"doing"};
            }else
            {
                //已揭晓
                dict = @{@"text":model.xsjx_time1,@"image":@"lottery",@"selectedImage":@"lottery"};
            }
            [carMakes addObject:dict];
        }
        NSLog(@"%@",carMakes);
        
        VOSegmentedControl *segctrl4 = [[VOSegmentedControl alloc] initWithSegments:carMakes];
        segctrl4.contentStyle = VOContentStyleImageTop;
        segctrl4.indicatorStyle = VOSegCtrlIndicatorStyleBox;
        segctrl4.animationType = VOSegCtrlAnimationTypeBounce;
        segctrl4.backgroundColor = [UIColor redColor];
        segctrl4.selectedSegmentIndex = indexS;
        segctrl4.allowNoSelection = NO;
        segctrl4.frame = CGRectMake(0, mainWidth*0.32, self.view.frame.size.width, 60);
        segctrl4.selectedTextFont = [UIFont systemFontOfSize:30];
        segctrl4.indicatorCornerRadius = 0;
        segctrl4.textFont = [UIFont systemFontOfSize:14];
        segctrl4.selectedTextFont = [UIFont systemFontOfSize:18];
        
//        self.indicatorLayer.frame = self.scrollLayer.frame;
//        self.indicatorLayer.bounds = [self indicatorBounds];
//        self.indicatorLayer.position = CGPointMake(self.segSize.width * self.selectedSegmentIndex + self.segSize.width / 2, [self indicatorBoundsY]);
//        self.indicatorPos = self.indicatorLayer.position;
        
        [bgScrollView addSubview:segctrl4];
        [segctrl4 setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"4: block --> %@", @(index));
        }];
        [segctrl4 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        
         [self getLimitedProStatus];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
    [[XBToastManager ShardInstance]hideprogress];
}

- (void)getLimitedProStatus
{
    [[XBToastManager ShardInstance]showprogress];
    huaitem = [arrData objectAtIndex:indexS];
    
    NSDictionary* dict = @{@"pid":huaitem.pid};
    [Limite3Model getLimiteHuafei:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        ProStatusModel* statusModel = [[ProStatusModel alloc]initWithDictionary:datadict error:&error];
        
        if ([statusModel.status intValue] == 1)
        {
            //已揭晓视图
            lotteryView = [[UIView alloc]initWithFrame:CGRectMake(0, mainWidth*0.32+80 + (mainWidth-64)*0.56 +10, mainWidth, (mainWidth-64)*0.54+50)];
            lotteryView.backgroundColor = [UIColor clearColor];
            [bgScrollView addSubview:lotteryView];
            
            //已揭晓
            UIImageView* lottery = [[UIImageView alloc]initWithFrame:CGRectMake(32, 5, 60, 19)];
            lottery.image = [UIImage imageNamed:@"lottery"];
            [lotteryView addSubview:lottery];
            
            UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, mainWidth-132, 19)];
            title.text = [NSString stringWithFormat:@"(第%@期) %@",statusModel.qishu,statusModel.title];
            title.textColor = [UIColor grayColor];
            title.font = [UIFont systemFontOfSize:14];
            [lotteryView addSubview:title];
            
            btnHigh = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, mainWidth/2, 49)];
            [btnHigh setTitle:@"高几率夺取" forState:UIControlStateNormal];
            [btnHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnHigh.backgroundColor = [UIColor lightGrayColor];
            btnHigh.titleLabel.font = [UIFont systemFontOfSize:17];
            [btnHigh setEnabled:NO];
            btnHigh.layer.borderColor = [UIColor grayColor].CGColor;
            btnHigh.layer.borderWidth = 0.5;
            [self.view addSubview:btnHigh];
            
            btnFree = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/2, self.view.frame.size.height-49, mainWidth/2, 49)];
            [btnFree setTitle:@"免费夺取" forState:UIControlStateNormal];
            [btnFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnFree.backgroundColor = [UIColor lightGrayColor];
            btnFree.titleLabel.font = [UIFont systemFontOfSize:17];
            [btnFree setEnabled: NO];
            btnFree.layer.borderColor = [UIColor grayColor].CGColor;
            btnFree.layer.borderWidth = 0.5;
            [self.view addSubview:btnFree];
            
            if ([statusModel.canyurenshu intValue] == 0) {
                UIView* bgzero = [[UIView alloc]initWithFrame:CGRectMake(10, 35, lotteryView.frame.size.width-20, (mainWidth-64)*0.54)];
                bgzero.backgroundColor = [UIColor hexFloatColor:@"e9e4d1"];
                [lotteryView addSubview:bgzero];
                
                UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgzero.frame.size.width, bgzero.frame.size.height)];
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:16];
                label.text = @"参与人数为0，不予揭晓";
                label.textAlignment = NSTextAlignmentCenter;
                [bgzero addSubview:label];
            }
            else
            {
                UIImageView* owner = [[UIImageView alloc]initWithFrame:CGRectMake(32, 35, mainWidth-64, (mainWidth-64)*0.54)];
                owner.image = [UIImage imageNamed:@"owner"];
                [lotteryView addSubview:owner];
                
                UILabel* lotteryTime = [[UILabel alloc]initWithFrame:CGRectMake(32, lotteryView.frame.size.height*0.34, mainWidth-70, 30)];
                lotteryTime.text = [NSString stringWithFormat:@"%@",[WenzhanTool formateDateStr:statusModel.server_time]];
                lotteryTime.textColor = [UIColor whiteColor];
                lotteryTime.font = [UIFont systemFontOfSize:14];
                lotteryTime.textAlignment = NSTextAlignmentRight;
                [lotteryView addSubview:lotteryTime];
                
                UIImageView* avatar = [[UIImageView alloc]initWithFrame:CGRectMake(48, lotteryView.frame.size.height*0.6, 60, 60)];
                if (statusModel.img) {
                    [avatar setImage_oy:oyImageBaseUrl image:statusModel.img];
                }
                avatar.layer.cornerRadius = 30;
                avatar.layer.masksToBounds = YES;
                [lotteryView addSubview:avatar];
                
                UILabel* gongxi = [[UILabel alloc]initWithFrame:CGRectMake(118, lotteryView.frame.size.height*0.6, mainWidth-70, 15)];
                gongxi.text = @"恭喜";
                gongxi.textColor = [UIColor redColor];
                gongxi.font = [UIFont systemFontOfSize:14];
                gongxi.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:gongxi];
                
                UILabel* person = [[UILabel alloc]initWithFrame:CGRectMake(158, lotteryView.frame.size.height*0.6, mainWidth-120, 15)];
                person.text = statusModel.username;
                person.textColor = [UIColor grayColor];
                person.font = [UIFont systemFontOfSize:14];
                person.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:person];
                
                UILabel* participate = [[UILabel alloc]initWithFrame:CGRectMake(118, lotteryView.frame.size.height*0.6+20, mainWidth-70, 15)];
                participate.text = @"参与人次：";
                participate.textColor = [UIColor grayColor];
                participate.font = [UIFont systemFontOfSize:12];
                participate.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:participate];
                
                UILabel* parTime = [[UILabel alloc]initWithFrame:CGRectMake(178, lotteryView.frame.size.height*0.6+20, mainWidth-70, 15)];
                parTime.text = statusModel.canyurenshu;
                parTime.textColor = [UIColor redColor];
                parTime.font = [UIFont systemFontOfSize:12];
                parTime.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:parTime];
                
                UILabel* lukyNo = [[UILabel alloc]initWithFrame:CGRectMake(118, lotteryView.frame.size.height*0.6+40, mainWidth-120, 15)];
                lukyNo.text = @"幸运号码：";
                lukyNo.textColor = [UIColor grayColor];
                lukyNo.font = [UIFont systemFontOfSize:12];
                lukyNo.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:lukyNo];
                
                UILabel* lukyNoD = [[UILabel alloc]initWithFrame:CGRectMake(178, lotteryView.frame.size.height*0.6+40, mainWidth-70, 15)];
                lukyNoD.text = statusModel.q_user_code;
                lukyNoD.textColor = [UIColor redColor];
                lukyNoD.font = [UIFont systemFontOfSize:12];
                lukyNoD.textAlignment = NSTextAlignmentLeft;
                [lotteryView addSubview:lukyNoD];
            }

        }
        //未开启
        else if ([statusModel.status intValue] == 0)
        {
            lotteryView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18+80 + (mainWidth-64)*0.56 +10, mainWidth, self.view.frame.size.height - (self.view.frame.size.height*0.18+80 + (mainWidth-64)*0.56) - 49-20-64)];
            lotteryView.backgroundColor = [UIColor clearColor];
            [bgScrollView addSubview:lotteryView];
            
            CGFloat CellWidth = self.view.frame.size.width;
            
            imgTimeBGH1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2, 36, 60, 55)];
            imgTimeBGH1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGH1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGH1];
            
            pointF1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+60, 36, 20, 55)];
            pointF1.font = [UIFont systemFontOfSize:30];
            pointF1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
            pointF1.text = @":";
            pointF1.textAlignment = NSTextAlignmentCenter;
            [lotteryView addSubview:pointF1];
            
            imgTimeBGM1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+80, 36, 60, 55)];
            imgTimeBGM1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGM1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGM1];
            
            pointS1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+140, 36, 20, 55)];
            pointS1.font = [UIFont systemFontOfSize:30];
            pointS1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
            pointS1.text = @":";
            pointS1.textAlignment = NSTextAlignmentCenter;
            [lotteryView addSubview:pointS1];
            
            imgTimeBGS1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+160, 36, 60, 55)];
            imgTimeBGS1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGS1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGS1];
            
            lblTimeH1 = [[UILabel alloc] init];
            lblTimeH1.font = [UIFont systemFontOfSize:30];
            lblTimeH1.textAlignment = NSTextAlignmentCenter;
            lblTimeH1.textColor = mainColor;
            lblTimeH1.text = @"00";
            [imgTimeBGH1 addSubview:lblTimeH1];
            
            lblTimeM1 = [[UILabel alloc] init];
            lblTimeM1.font = [UIFont systemFontOfSize:30];
            lblTimeM1.textAlignment = NSTextAlignmentCenter;
            lblTimeM1.textColor = mainColor;
            lblTimeM1.text = @"00";
            [imgTimeBGM1 addSubview:lblTimeM1];
            
            lblTimeS1 = [[UILabel alloc] init];
            lblTimeS1.font = [UIFont systemFontOfSize:30];
            lblTimeS1.textAlignment = NSTextAlignmentCenter;
            lblTimeS1.textColor = mainColor;
            lblTimeS1.text = @"00";
            [imgTimeBGS1 addSubview:lblTimeS1];
            
            UIImageView* lottery = [[UIImageView alloc]initWithFrame:CGRectMake(32, 115, 60, 19)];
            lottery.image = [UIImage imageNamed:@"unopen"];
            [lotteryView addSubview:lottery];
            
            btnHigh = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, mainWidth/2, 49)];
            [btnHigh setTitle:@"高几率夺取" forState:UIControlStateNormal];
            [btnHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnHigh.backgroundColor = [UIColor lightGrayColor];
            btnHigh.titleLabel.font = [UIFont systemFontOfSize:17];
            [btnHigh setEnabled:NO];
            btnHigh.layer.borderColor = [UIColor grayColor].CGColor;
            btnHigh.layer.borderWidth = 0.5;
            [self.view addSubview:btnHigh];
            
            btnFree = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/2, self.view.frame.size.height-49, mainWidth/2, 49)];
            [btnFree setTitle:@"免费夺取" forState:UIControlStateNormal];
            [btnFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnFree.backgroundColor = [UIColor lightGrayColor];
            btnFree.titleLabel.font = [UIFont systemFontOfSize:17];
            [btnFree setEnabled:NO];
            btnFree.layer.borderColor = [UIColor grayColor].CGColor;
            btnFree.layer.borderWidth = 0.5;
            [self.view addSubview:btnFree];
            
            UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(100, 115, mainWidth-132, 19)];
            title.text = [NSString stringWithFormat:@"(第%@期) %@", statusModel.qishu,statusModel.title];
            title.textColor = [UIColor grayColor];
            title.font = [UIFont systemFontOfSize:14];
            [lotteryView addSubview:title];
            
            progress = [[ProBuyingProgress alloc] initWithFrame:CGRectMake(32, 150, mainWidth - 64, 35)];
            [progress setProgress:[statusModel.shenyurenshu doubleValue] now:[statusModel.canyurenshu doubleValue]];
            [lotteryView addSubview:progress];
            
        }
        else
        {
            //进行中
            lotteryView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18+80 + (mainWidth-64)*0.56 +10, mainWidth, self.view.frame.size.height - (self.view.frame.size.height*0.18+80 + (mainWidth-64)*0.56) - 49-20-64)];
            lotteryView.backgroundColor = [UIColor clearColor];
            [bgScrollView addSubview:lotteryView];
            
            CGFloat CellWidth = self.view.frame.size.width;
            
            imgTimeBGH1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2, 36, 60, 55)];
            imgTimeBGH1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGH1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGH1];
            
            pointF1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+60, 36, 20, 55)];
            pointF1.font = [UIFont systemFontOfSize:30];
            pointF1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
            pointF1.text = @":";
            pointF1.textAlignment = NSTextAlignmentCenter;
            [lotteryView addSubview:pointF1];
            
            imgTimeBGM1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+80, 36, 60, 55)];
            imgTimeBGM1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGM1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGM1];
            
            pointS1 = [[UILabel alloc] initWithFrame:CGRectMake((CellWidth-220)/2+140, 36, 20, 55)];
            pointS1.font = [UIFont systemFontOfSize:30];
            pointS1.textColor = [UIColor hexFloatColor:@"3d3d3d"];
            pointS1.text = @":";
            pointS1.textAlignment = NSTextAlignmentCenter;
            [lotteryView addSubview:pointS1];
            
            imgTimeBGS1 = [[UIImageView alloc] initWithFrame:CGRectMake((CellWidth-220)/2+160, 36, 60, 55)];
            imgTimeBGS1.backgroundColor = [UIColor hexFloatColor:@"3d3d3d"];
            imgTimeBGS1.layer.cornerRadius = 3;
            [lotteryView addSubview:imgTimeBGS1];
            
            lblTimeH1 = [[UILabel alloc] init];
            lblTimeH1.font = [UIFont systemFontOfSize:30];
            lblTimeH1.textAlignment = NSTextAlignmentCenter;
            lblTimeH1.textColor = mainColor;
            lblTimeH1.text = @"00";
            [imgTimeBGH1 addSubview:lblTimeH1];
            
            lblTimeM1 = [[UILabel alloc] init];
            lblTimeM1.font = [UIFont systemFontOfSize:30];
            lblTimeM1.textAlignment = NSTextAlignmentCenter;
            lblTimeM1.textColor = mainColor;
            lblTimeM1.text = @"00";
            [imgTimeBGM1 addSubview:lblTimeM1];
            
            lblTimeS1 = [[UILabel alloc] init];
            lblTimeS1.font = [UIFont systemFontOfSize:30];
            lblTimeS1.textAlignment = NSTextAlignmentCenter;
            lblTimeS1.textColor = mainColor;
            lblTimeS1.text = @"00";
            [imgTimeBGS1 addSubview:lblTimeS1];
            
            UIImageView* lottery = [[UIImageView alloc]initWithFrame:CGRectMake(32, 115, 60, 19)];
            lottery.image = [UIImage imageNamed:@"doing"];
            [lotteryView addSubview:lottery];
            
            if(timer1)
            {
                [timer1 invalidate];
                timer1 = nil;
            }
            nowSeconds1 = [statusModel.open_time intValue];
            timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction1) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
            
            if ([statusModel.shenyurenshu intValue] == 0)
            {
                lottery.image = [UIImage imageNamed:@"full"];
                
                btnHigh = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, mainWidth/2, 49)];
                [btnHigh setTitle:@"高几率夺取" forState:UIControlStateNormal];
                [btnHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnHigh.backgroundColor = [UIColor lightGrayColor];
                btnHigh.titleLabel.font = [UIFont systemFontOfSize:17];
                [btnHigh setEnabled:NO];
                btnHigh.layer.borderColor = [UIColor grayColor].CGColor;
                btnHigh.layer.borderWidth = 0.5;
                [self.view addSubview:btnHigh];
                
                btnFree = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/2, self.view.frame.size.height-49, mainWidth/2, 49)];
                [btnFree setTitle:@"免费夺取" forState:UIControlStateNormal];
                [btnFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnFree.backgroundColor = [UIColor lightGrayColor];
                btnFree.titleLabel.font = [UIFont systemFontOfSize:17];
                [btnFree setEnabled:NO];
                btnFree.layer.borderColor = [UIColor grayColor].CGColor;
                btnFree.layer.borderWidth = 0.5;
                [self.view addSubview:btnFree];
            }else
            {
                btnHigh = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, mainWidth/2, 49)];
                [btnHigh setTitle:@"高几率夺取" forState:UIControlStateNormal];
                [btnHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnHigh.backgroundColor = [UIColor hexFloatColor:@"f97423"];
                btnHigh.titleLabel.font = [UIFont systemFontOfSize:17];
                [btnHigh addTarget:self action:@selector(btnHignClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btnHigh];
                
                btnFree = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/2, self.view.frame.size.height-49, mainWidth/2, 49)];
                [btnFree setTitle:@"免费夺取" forState:UIControlStateNormal];
                [btnFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnFree.backgroundColor = [UIColor redColor];
                btnFree.titleLabel.font = [UIFont systemFontOfSize:17];
                [btnFree addTarget:self action:@selector(btnFreeClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btnFree];
            }
            
            UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(100, 115, mainWidth-132, 19)];
            title.text = [NSString stringWithFormat:@"(第%@期) %@", statusModel.qishu,statusModel.title];
            title.textColor = [UIColor grayColor];
            title.font = [UIFont systemFontOfSize:14];
            [lotteryView addSubview:title];
            
            progress = [[ProBuyingProgress alloc] initWithFrame:CGRectMake(32, 150, mainWidth - 64, 35)];
            [progress setProgress:[statusModel.shenyurenshu doubleValue] now:[statusModel.canyurenshu doubleValue]];
            [lotteryView addSubview:progress];
        }
        [[XBToastManager ShardInstance]hideprogress];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    
    indexS = segmentCtrl.selectedSegmentIndex;
    [lotteryView removeFromSuperview];
    [btnFree removeFromSuperview];
    [btnHigh removeFromSuperview];
    [self getLimitedProStatus];
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
        [self getautoLottery];
        return;
    }
    int m = (int)nowSeconds1 / 3600;        //小时
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

//倒计时结束调用自动揭晓功能
- (void)getautoLottery
{
    [[XBToastManager ShardInstance]showprogress];
    huaitem = [arrData objectAtIndex:indexS];
    
    NSDictionary* dict = @{@"pid":huaitem.pid};
    [Limite3Model getLimiteHuafei:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        lotteryModel = [[AutoLotteryModel alloc]initWithDictionary:datadict error:&error];
        
        [lotteryView removeFromSuperview];
        [btnFree removeFromSuperview];
        [btnHigh removeFromSuperview];
        [self getLimitedProStatus];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

- (void)btnHignClicked
{
    if ([UserInstance ShardInstnce].uid) {
        popVC = nil;
        popVC = [[LimitePopoverVC alloc]initWithUserID:huaitem];
        popVC.delegate = self;
        [self presentPopupViewController:popVC animationType:MJPopupViewAnimationFade];
    }
    else
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)btnFreeClicked
{
    if ([UserInstance ShardInstnce].uid) {
        SuperShareVC* vc = [[SuperShareVC alloc]initWithUserID:[UserInstance ShardInstnce].uid codeId:huaitem.sid];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
//参与夺宝记录
- (void)paticipateRecordClicked
{
    if ([UserInstance ShardInstnce].uid) {
        recordVC = nil;
        recordVC = [[BuyRecordPopVC alloc]initWithUserID:huaitem];
        recordVC.delegate = self;
        [self presentPopupViewController:recordVC animationType:MJPopupViewAnimationFade];
    }
    else
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

//活动规则
- (void)activityRuleClicked
{
    if ([UserInstance ShardInstnce].uid) {
        activityVC = nil;
        activityVC = [[ActivityRuleVC alloc]init];
        activityVC.delegate = self;
        [self presentPopupViewController:activityVC animationType:MJPopupViewAnimationFade];
    }
    else
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)cancelLimiteButtonClicked:(LimitePopoverVC *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    aSecondDetailViewController = nil;
}
@end
