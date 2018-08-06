//
//  LimitePopoverVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/21.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LimitePopoverVC.h"
#import "Limite3Model.h"
#import "CustomInfo.h"
#import <BeeCloud/BeeCloud.h>
#import <BCAliPay/BCAliPay.h>
#import "ChargeModel.h"
#import "NSString+MD5.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface LimitePopoverVC ()<UITextFieldDelegate>
{
    NSString* rateNum;
    
    UIButton    *btnDown;
    UIButton    *btnAdd;
    UITextField *txtNum;
    UILabel     *patiCount;
    UIButton*   btnNext;
    UIView*     bg;
    UIView*     paymentView;
    UIButton*   btnPay;
    
    HuaFeiModel* huaitem;
    ProStatusModel* statusModel;
    ChargeOrder*    orderChar;
    CustomInfo* customInfo;
    __block ChargeResult        *resultChar;    //充值成功返回model
    
    NSTimer     *timer;
    NSInteger   nowSeconds;
    NSString*   money;
}
@end

@implementation LimitePopoverVC
- (id)initWithUserID:(HuaFeiModel*)item
{
    self = [super init];
    if(self)
    {
        huaitem = item;
    }
    return self;
}

- (void)removeFromSuperview
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self getLimitedProStatus];
    [self initBuyView];
}

- (void)getLimitedProStatus
{
    [[XBToastManager ShardInstance]showprogress];
    NSDictionary* dict = @{@"pid":huaitem.pid};
    [Limite3Model getLimiteHuafei:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([parser.resultCode isEqualToString:@"200"]) {
            statusModel = [[ProStatusModel alloc]initWithDictionary:datadict error:&error];
        }
        else
        {
            [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat: @"%@",parser.resultMessage]];
        }
        [[XBToastManager ShardInstance]hideprogress];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

- (void)initBuyView
{
    bg = [[UIView alloc]initWithFrame:CGRectMake(32, (self.view.frame.size.height-mainWidth*1.2)/2, mainWidth-64, mainWidth*1.2)];
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.masksToBounds = YES;
    bg.layer.cornerRadius = 10;
    [self.view addSubview:bg];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth-32-22-7, (self.view.frame.size.height-mainWidth*1.2)/2-15, 44, 44)];
    [close setImage:[UIImage imageNamed:@"red_cha"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UILabel* huafei = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, bg.frame.size.width, 30)];
    huafei.textColor = [UIColor grayColor];
    huafei.font = [UIFont systemFontOfSize:25];
    huafei.text = @"100元话费 全网通";
    huafei.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:huafei];
    
    UIImageView* mobileHuafei = [[UIImageView alloc]initWithFrame:CGRectMake(32, 70, bg.frame.size.width-64, (bg.frame.size.width-64)*0.5)];
    mobileHuafei.image = [UIImage imageNamed:@"goods"];
    [bg addSubview:mobileHuafei];
    
    UIView* paticipateBG = [[UIView alloc]initWithFrame:CGRectMake(20, 110+(bg.frame.size.width-64)*0.5, bg.frame.size.width-40, 50)];
    paticipateBG.backgroundColor = [UIColor lightGrayColor];
    paticipateBG.layer.masksToBounds = YES;
    paticipateBG.layer.cornerRadius = 25;
    paticipateBG.layer.borderColor = [UIColor lightGrayColor].CGColor;
    paticipateBG.layer.borderWidth = 0.5;
    [bg addSubview:paticipateBG];
    
    btnDown = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [btnDown setTitle:@"-" forState:UIControlStateNormal];
    btnDown.titleLabel.font = [UIFont systemFontOfSize:27];
    [btnDown addTarget:self action:@selector(downnum) forControlEvents:UIControlEventTouchUpInside];
    btnDown.titleLabel.textAlignment = NSTextAlignmentCenter;
    [paticipateBG addSubview:btnDown];
    
    patiCount = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 50)];
    patiCount.backgroundColor = [UIColor whiteColor];
    patiCount.textColor = [UIColor lightGrayColor];
    patiCount.font = [UIFont systemFontOfSize:14];
    patiCount.text = @"   参与份数：";
    [paticipateBG addSubview:patiCount];
    
    txtNum = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, paticipateBG.frame.size.width-130-50, 50)];
    txtNum.backgroundColor = [UIColor whiteColor];
    txtNum.font = [UIFont systemFontOfSize:13];
    txtNum.textAlignment = NSTextAlignmentCenter;
    txtNum.enabled = YES;
    txtNum.returnKeyType = UIReturnKeyDone;
    txtNum.delegate = self;
    txtNum.text = @"10";
    txtNum.keyboardType = UIKeyboardTypeNumberPad;
    txtNum.clearsOnBeginEditing = YES;
    [txtNum addDoneOnKeyboardWithTarget:self action:@selector(doneTxtAction:)];
    [paticipateBG addSubview:txtNum];
    
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(paticipateBG.frame.size.width-40, 10, 30, 30)];
    [btnAdd setTitle:@"+" forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:27];
    btnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnAdd addTarget:self action:@selector(addnum) forControlEvents:UIControlEventTouchUpInside];
    [paticipateBG addSubview:btnAdd];
    
    UILabel* rate = [[UILabel alloc]initWithFrame:CGRectMake(0, 80+(bg.frame.size.width-64)*0.5, bg.frame.size.width, 20)];
    rate.textColor = [UIColor grayColor];
    rate.font = [UIFont systemFontOfSize:14];
    NSString* handroud = @"100";
    CGFloat rating = [txtNum.text doubleValue]/[handroud doubleValue];
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
    CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &rating);
    CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
    rate.text = [NSString stringWithFormat:@"获奖几率：%@",numberString];
    rate.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:rate];
    
    btnNext = [[UIButton alloc]initWithFrame:CGRectMake(32, 180+(bg.frame.size.width-64)*0.5, bg.frame.size.width-64, 40)];
    btnNext.layer.masksToBounds = YES;
    btnNext.layer.cornerRadius = 6;
    [btnNext setBackgroundColor:[UIColor redColor]];
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNext.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnNext addTarget:self action:@selector(improveNextClicked) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnNext];
    
    UILabel* perFen = [[UILabel alloc]initWithFrame:CGRectMake(0, 180+(bg.frame.size.width-64)*0.5+40+20, bg.frame.size.width, 20)];
    perFen.textColor = [UIColor grayColor];
    perFen.font = [UIFont systemFontOfSize:14];
    perFen.text = @"100元话费分成100等份（每份一元）";
    perFen.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:perFen];
    
    UILabel* perRate = [[UILabel alloc]initWithFrame:CGRectMake(0, 180+(bg.frame.size.width-64)*0.5+60+20, bg.frame.size.width, 20)];
    perRate.textColor = [UIColor grayColor];
    perRate.font = [UIFont systemFontOfSize:14];
    perRate.text = @"10分钟内购买份数越多，获得话费几率就越高";
    perRate.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:perRate];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    nowSeconds = [statusModel.open_time intValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionHua) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)addnum
{
    if ([txtNum.text intValue] >= [statusModel.shenyurenshu intValue]) {
        [btnAdd setEnabled:NO];
        txtNum.text = statusModel.shenyurenshu;
    }
    [btnDown setEnabled:YES];
    txtNum.text = [NSString stringWithFormat:@"%d",[txtNum.text intValue]+1];
    
}

- (void)downnum
{
    if ([txtNum.text intValue] <= 1) {
        [btnDown setEnabled:NO];
        txtNum.text = @"1";
    }else
    {
        [btnDown setEnabled:YES];
        txtNum.text = [NSString stringWithFormat:@"%d",[txtNum.text intValue]-1];
    }
    [btnAdd setEnabled:YES];
}

-(void)doneTxtAction:(UIBarButtonItem*)barButton
{
    if ([txtNum.text isEqualToString:@""])
    {
        [[XBToastManager ShardInstance]showtoast:@"夺宝人次不能为零"];
        return;
    }else
    {
        if ([txtNum.text intValue] >= [statusModel.shenyurenshu intValue]) {
            [[XBToastManager ShardInstance]showtoast:@"夺宝人次不可多余剩余人次" wait:2.0f];
            txtNum.text = statusModel.shenyurenshu;
        }
    }
}

- (void)closePopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
        [self.delegate cancelLimiteButtonClicked:self];
    }
}

//倒计时结束，则本期已揭晓，禁止再购买
- (void)timerActionHua
{
    if (nowSeconds < 0) {
        [timer invalidate];
        timer = nil;
        return;
    }
    nowSeconds--;
    if (nowSeconds <= 0) {
        [btnNext setEnabled:NO];
        [btnNext setBackgroundColor:[UIColor lightGrayColor]];
        [btnNext setTitle:@"本期已结束" forState:UIControlStateNormal];
        [self initBuyView];
    }
}

- (void)improveNextClicked
{
    //初始化支付的数据
    
    customInfo = [[CustomInfo alloc]init];
    customInfo.outTradeNo = [[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    customInfo.body = [NSString stringWithFormat:@"%@",[[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    customInfo.traceID = @"ios_duobaodaka";
    customInfo.subject = customInfo.outTradeNo;
    customInfo.optional = nil;
    customInfo.aliScheme = @"DakaPayDemo";
    
    bg.hidden = YES;
    [self initPayment];
}

- (void)initPayment
{
    paymentView = [[UIView alloc]initWithFrame:CGRectMake(32, self.view.frame.size.height*0.2, mainWidth-64, self.view.frame.size.height*0.6)];
    paymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paymentView];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(paymentView.frame.size.width-15, -4, 19, 19)];
    [close setImage:[UIImage imageNamed:@"btn1Home"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [paymentView addSubview:close];
    
    UILabel* huafei = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, paymentView.frame.size.width, 30)];
    huafei.textColor = [UIColor grayColor];
    huafei.font = [UIFont systemFontOfSize:25];
    huafei.text = @"100元话费 全网通";
    huafei.textAlignment = NSTextAlignmentCenter;
    [paymentView addSubview:huafei];
    
    UILabel* lblPati = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, paymentView.frame.size.width-20, 20)];
    lblPati.textColor = [UIColor grayColor];
    lblPati.font = [UIFont systemFontOfSize:14];
    lblPati.text = @"参与份数：";
    lblPati.textAlignment = NSTextAlignmentLeft;
    [paymentView addSubview:lblPati];
    
    UILabel* lblPatiNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, paymentView.frame.size.width-20, 20)];
    lblPatiNum.textColor = [UIColor grayColor];
    lblPatiNum.font = [UIFont systemFontOfSize:14];
    lblPatiNum.text = [NSString stringWithFormat:@"%@份", txtNum.text];
    lblPatiNum.textAlignment = NSTextAlignmentRight;
    [paymentView addSubview:lblPatiNum];
    
    UILabel* lblPay = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, paymentView.frame.size.width-20, 20)];
    lblPay.textColor = [UIColor grayColor];
    lblPay.font = [UIFont systemFontOfSize:14];
    lblPay.text = @"需要支付：";
    lblPay.textAlignment = NSTextAlignmentLeft;
    [paymentView addSubview:lblPay];
    
    UILabel* lblPayNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, paymentView.frame.size.width-20, 20)];
    lblPayNum.textColor = [UIColor grayColor];
    lblPayNum.font = [UIFont systemFontOfSize:14];
    lblPayNum.text = [NSString stringWithFormat:@"%@元", txtNum.text];
    lblPayNum.textAlignment = NSTextAlignmentRight;
    [paymentView addSubview:lblPayNum];
    
    UILabel* payType = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, paymentView.frame.size.width-20, 20)];
    payType.textColor = [UIColor grayColor];
    payType.font = [UIFont systemFontOfSize:16];
    payType.text = @"支付方式";
    payType.textAlignment = NSTextAlignmentCenter;
    [paymentView addSubview:payType];
    
    UIImageView* aliPayimg = [[UIImageView alloc]initWithFrame:CGRectMake((paymentView.frame.size.width-80)/2, 230, 80, 80)];
    aliPayimg.image = [UIImage imageNamed:@"aliPay"];
    [paymentView addSubview:aliPayimg];
    
    btnPay = [[UIButton alloc]initWithFrame:CGRectMake(32, paymentView.frame.size.height-60, paymentView.frame.size.width-64, 40)];
    btnPay.layer.masksToBounds = YES;
    btnPay.layer.cornerRadius = 6;
    [btnPay setBackgroundColor:[UIColor redColor]];
    [btnPay setTitle:@"结算" forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPay.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnPay addTarget:self action:@selector(paymentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [paymentView addSubview:btnPay];
}

//开始购买
//初始化订单信息
- (void)paymentButtonClicked
{
    [[XBToastManager ShardInstance]showprogress];
    NSString* uid   = [UserInstance ShardInstnce].uid;
    
    money = [NSString stringWithFormat:@"%@", txtNum.text];
    NSString* pay_type = @"支付宝";
    NSDictionary* dict = @{@"uid":uid,@"money":money,@"pay_type":pay_type};
    [ChargeModel getChargeOrder:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError*      error    = nil;
        if ([parser.resultCode isEqualToString:@"200"])
        {
            orderChar = [[ChargeOrder alloc]initWithDictionary:dataDict error:&error];
            [self aliPayAction];
        }
        else if ([parser.resultCode isEqualToString:@"201"])
        {
            [[[UIAlertView alloc] initWithTitle:@"用户ID错误"
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        else if ([parser.resultCode isEqualToString:@"202"])
        {
            [[[UIAlertView alloc] initWithTitle:@"支付金额错误"
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        else if ([parser.resultCode isEqualToString:@"203"])
        {
            [[[UIAlertView alloc] initWithTitle:@"支付方式错误"
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        else if ([parser.resultCode isEqualToString:@"204"])
        {
            [[[UIAlertView alloc] initWithTitle:@"用户不存在"
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

//只有使用支付宝充值付款的时候，才会调用充值接口，其他的方式不调用；
- (void)aliPayAction
{
    NSString* subject = [NSString stringWithFormat:@"夺宝大咖iOS： %@",orderChar.code]; //传给支付宝的标题;
    [BCAliPay reqAliPayment:customInfo.traceID outTradeNo:customInfo.outTradeNo subject:subject body:customInfo.body totalFee:money scheme:customInfo.aliScheme optional:customInfo.optional payBlock:^(BOOL success, NSString *strMsg, NSError *error) {
        if (success) {
            //充值成功后调用的接口
            [self sendData:nil];
        } else
        {
            NSLog(@"%@",strMsg);
            // 表明支付过程中出现错误，strMsg为错误原因
            [[XBToastManager ShardInstance]hideprogress];
            [[[UIAlertView alloc] initWithTitle:@"支付失败"
                                        message:@"用户中途取消"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
    }];
    
}

//充值返回数据，使用后，账户余额不变；
- (void)sendData:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    NSString* uid   = [UserInstance ShardInstnce].uid;
    NSString* moneyF = [NSString stringWithFormat:@"%@.00", money];
    NSString* code  = orderChar.code;
    NSString* str   = [NSString stringWithFormat:@"uid=%@&money=%@&code=%@Judu2015duobaodaka",uid,moneyF,code];
    NSString* md5Str= [NSString md5:str];
    
    NSDictionary* dict = @{@"uid":uid,@"money":money,@"pay_type":@"支付宝",@"code":code,@"entryStr":md5Str};
    [ChargeModel getChargeResult:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError*    error    = nil;
        
        OneBaseParser* resultStatus = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        //提交充值数据成功并返回200，则继续下一步；
        if ([resultStatus.resultCode isEqualToString:@"200"])
        {
            resultChar = [[ChargeResult alloc]initWithDictionary:dataDict error:&error];
//            [self loadAutoBuy];
            [self HighRateBuySuccessData:nil];
            
        }else
        {
            
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@请求参数错误，请联系客服", resultStatus.resultCode]
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        
        [[[UIAlertView alloc] initWithTitle:@"购买失败"
                                    message:@"支付宝金额已转至您的夺宝大咖个人账户(01)"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            
        }], nil] show];
        
        [[XBToastManager ShardInstance] hideprogress];
    }];
    [[XBToastManager ShardInstance] hideprogress];
}

//用户购买商品后发送购买的商品信息到服务器
- (void)HighRateBuySuccessData:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    
    NSString* uid = [UserInstance ShardInstnce].uid;
    NSString* ip = [UserInstance ShardInstnce].user_ip;
    
    NSMutableArray*         requestArr  = [[NSMutableArray alloc] init];
//        BuyRequestModel *  model  = [arrData objectAtIndex:i];
    
        NSDictionary*    _dict = @{@"gonumber":money,@"pid":huaitem.pid,@"qishu":huaitem.qishu,@"sid":huaitem.sid};
    
        [requestArr addObject:_dict ];

    
    NSDictionary* dict = @{@"uid":uid,@"ip":ip,@"score":@"0",@"goshops":requestArr};
    [ChargeModel getBuyResult:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
//        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
//        NSArray* dataArr = [BuyRequestModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        
        if ([parser.resultCode isEqualToString:@"200"]) {
            //购买成功
            [[XBToastManager ShardInstance]showtoast:@"高几率夺取成功" wait:3.0];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
                [self.delegate cancelLimiteButtonClicked:self];
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"夺取失败"
                                        message:[NSString stringWithFormat:@"%@",parser.resultMessage]
                               cancelButtonItem:nil
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
                    [self.delegate cancelLimiteButtonClicked:self];
                }
                
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        
        [[[UIAlertView alloc] initWithTitle:@"错误（03）"
                                    message:@"请稍后到我的夺宝记录中查看"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            [[XBToastManager ShardInstance] hideprogress];
            [self.navigationController popViewControllerAnimated:YES];
        }], nil] show];
    }];
    
}

- (void)loadAutoBuy
{
    [[XBToastManager ShardInstance]showprogress];
    //传入sid，自动购买最新的一期
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"sid":huaitem.sid};
    [Limite3Model getautoBuy:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([parser.resultCode isEqualToString:@"200"]) {
            //购买成功
            [[XBToastManager ShardInstance]showtoast:@"高几率夺取成功" wait:3.0];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
                [self.delegate cancelLimiteButtonClicked:self];
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"夺取失败"
                                        message:[NSString stringWithFormat:@"%@",parser.resultMessage]
                               cancelButtonItem:nil
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
                    [self.delegate cancelLimiteButtonClicked:self];
                }
                
            }], nil] show];
        }
        
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

@end
