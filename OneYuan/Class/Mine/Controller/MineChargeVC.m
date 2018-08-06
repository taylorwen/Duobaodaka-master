//
//  MineChargeVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineChargeVC.h"
#import "MineChargeOptView.h"
#import "ChargeProCell.h"
#import <BCMMMPay/BCMMMPayViewController.h>
#import <BCMMMPay/BCMMMPay.h>
#import <BeeCloud/BeeCloud.h>
#import <BCAliPay/BCAliPay.h>
#import <BCWXPay/BCWXPay.h>
#import <BCUnionPay/BCUnionPay.h>
#import "CustomInfo.h"
#import "SuccessViewController.h"
#import "BeeCloud/BCUtil.h"
#import "AppDelegate.h"
#import "ChargeModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

@interface MineChargeVC ()<ChargeOptViewDelegate,UITableViewDataSource,UITableViewDelegate,ChargeProCellDelegate>
{
    __block MineChargeOptView       *viewOpt;
    __block UITableView             *tbView;
    __block NSUInteger              row;
    __block int                     chargeMoney;//传过来的充值金额
    __block NSString                *pay_type;
    __block ChargeOrder             *orderChar;
    __block paymentVerifyModel      *verifyR;
    __block NSTimer                 *timer;
    NSInteger                       nowSeconds;
    __block int            rupe;
    
}
@property (strong, nonatomic) CustomInfo* customInfo;
@end

@implementation MineChargeVC
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
    self.title = @"充值";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    CGFloat margin = 0;
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        margin = 49;
        viewOpt = [[MineChargeOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 112, mainWidth, 49)];
        viewOpt.delegate = self;
        [self.view addSubview:viewOpt];
    }
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - margin) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    //赋一个初始值
    chargeMoney = 50;
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    if (indexPath.section == 1) {
        return 100;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 44)];
        
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(16,14, 200, 16)];
        lblCode.text = @"选择充值金额(元)";
        lblCode.font = [UIFont systemFontOfSize:15];
        lblCode.textColor = [UIColor grayColor];
        [vvv addSubview:lblCode];
        return vvv;
    }
    
    if (section == 2) {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 44)];
        
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(16,14, 200, 16)];
        lblCode.text = @"选择充值方式";
        lblCode.font = [UIFont systemFontOfSize:15];
        lblCode.textColor = [UIColor grayColor];
        [vvv addSubview:lblCode];
        
        return vvv;
    }
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"allProItemCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* lblRead1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, mainWidth, 15)];
        lblRead1.text = @"每支付1元购买大咖盘空间，系统将会";
        lblRead1.textAlignment = NSTextAlignmentCenter;
        lblRead1.font = [UIFont systemFontOfSize:14];
        lblRead1.textColor = [UIColor grayColor];
        [cell addSubview:lblRead1];
        
        UILabel* lblRead2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, mainWidth, 15)];
        lblRead2.text = @"赠送1个夺宝币可用于夺宝，支付的款项将无法退回。";
        lblRead2.textAlignment = NSTextAlignmentCenter;
        lblRead2.font = [UIFont systemFontOfSize:14];
        lblRead2.textColor = [UIColor grayColor];
        [cell addSubview:lblRead2];
        return cell;
        
    }
    
    if (indexPath.section == 1) {
            static NSString *CellIdentifier = @"allProItemCell";
            ChargeProCell *cell = (ChargeProCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[ChargeProCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"allProItemCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = @"             支付宝支付";
            
            UIImageView* pay = [[UIImageView alloc]initWithFrame:CGRectMake(16, 4, 52, 52)];
            pay.image = [UIImage imageNamed:@"aliPay"];
            [cell addSubview:pay];
            UIView* bgcell = [[UIView alloc]initWithFrame:cell.frame];
            bgcell.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
            bgcell.layer.borderWidth = 0.5;
            UIImageView* bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screening_select"]];
            bgImage.frame = CGRectMake(mainWidth-50, 20, 20, 20);
            [bgcell addSubview:bgImage];
            cell.selectedBackgroundView = bgcell;
            
            UIView* bgnormalcell = [[UIView alloc]initWithFrame:cell.frame];
            UIImageView* linebottom1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59, mainWidth, 1)];
            linebottom1.backgroundColor = BG_GRAY_COLOR;
            [cell addSubview:linebottom1];
            UIImageView* linetop1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 1)];
            linetop1.backgroundColor = BG_GRAY_COLOR;
            [cell addSubview:linetop1];
            UIImageView* bgImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screening_select"]];
            bgImage1.frame = CGRectMake(mainWidth-50, 20, 20, 20);
            [bgnormalcell addSubview:bgImage1];
            cell.backgroundView = bgnormalcell;
            
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"allProItemCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = @"                微信支付";
            UIImageView* pay = [[UIImageView alloc]initWithFrame:CGRectMake(16, 4, 52, 52)];
            pay.image = [UIImage imageNamed:@"wxPay"];
            [cell addSubview:pay];
            UIView* bgcell = [[UIView alloc]initWithFrame:cell.frame];
            bgcell.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
            bgcell.layer.borderWidth = 0.5;
            UIImageView* bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screening_select"]];
            bgImage.frame = CGRectMake(mainWidth-80, 20, 20, 20);
            [bgcell addSubview:bgImage];
            cell.selectedBackgroundView = bgcell;
            
            UIView* bgnormalcell = [[UIView alloc]initWithFrame:cell.frame];
            UIImageView* linebottom1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59, mainWidth, 1)];
            linebottom1.backgroundColor = BG_GRAY_COLOR;
            [cell addSubview:linebottom1];
            UIImageView* linetop1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 1)];
            linetop1.backgroundColor = BG_GRAY_COLOR;
            [cell addSubview:linetop1];
            UIImageView* bgImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screening_unselect"]];
            bgImage1.frame = CGRectMake(mainWidth-40, 20, 20, 20);
            [bgnormalcell addSubview:bgImage1];
            cell.backgroundView = bgnormalcell;
            
            return cell;
        }
    }
    static NSString *CellIdentifier = @"allProItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            row = 3;
            NSLog(@"%ld",(long)row);
        }
        if (indexPath.row == 1) {
            row = 4;
        }
    }
}

//获取到的充值金额
-(void)getChargeMoneyAmount:(int)index
{
    if (index == 0) {
        NSLog(@"选中的是50元");
        chargeMoney = 50;
    }
    else if (index == 1)
    {
        NSLog(@"选中的是100元");
        chargeMoney = 100;
        
    }
    else if (index == 2)
    {
        NSLog(@"选中的是200元");
        chargeMoney = 200;
        
    }
    else if (index == 3)
    {
        NSLog(@"选中的是500元");
        chargeMoney = 500;
        
    }
    else if (index == 4)
    {
        NSLog(@"选中的是1000元");
        chargeMoney = 1000;
    }
}

-(void)textfieldChangeMoney:(int)index
{
    chargeMoney = index;
}

//点击充值的按钮
- (void)chargeCallThirdPartyPayAction
{
    if ([UserInstance ShardInstnce].uid)
    {
        _customInfo = [[CustomInfo alloc]init];
        _customInfo.outTradeNo = [[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _customInfo.body = [NSString stringWithFormat:@"%@",[[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        _customInfo.traceID = @"ios_duobaodaka";
        _customInfo.subject = _customInfo.outTradeNo;
        _customInfo.optional = nil;
        _customInfo.aliScheme = @"DakaPayDemo";
        
        if (!chargeMoney)
        {
            
            [[[UIAlertView alloc] initWithTitle:@"未选择充值金额"
                                        message:@""
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];

        }else
        {
            NSLog(@"使用支付宝支付的金额是%d",chargeMoney);
            pay_type = @"支付宝";
            [self requestOrder:nil];
        }
    }
    else
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    }
}

//请求订单，生成订单号；
- (void)requestOrder:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* uid   = [UserInstance ShardInstnce].uid;
    NSString* money = [NSString stringWithFormat:@"%d", chargeMoney ];
    
    NSDictionary* dict = @{@"uid":uid,@"money":money,@"pay_type":pay_type,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [ChargeModel getChargeOrder:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError*      error    = nil;
        orderChar = [[ChargeOrder alloc]initWithDictionary:dataDict error:&error];
        if ([parser.resultCode isEqualToString:@"200"])
        {
            [self aliPay:nil];
            
        }else
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",parser.resultMessage]
                                        message:@""
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

- (void)aliPay:(void (^)(void))block
{
    NSString* subject = [NSString stringWithFormat:@"夺宝大咖iOS:%@",orderChar.code]; //传给支付宝的标题;
    [BCAliPay reqAliPayment:self.customInfo.traceID outTradeNo:self.customInfo.outTradeNo subject:subject body:self.customInfo.body totalFee:[NSString stringWithFormat:@"%d",chargeMoney] scheme:self.customInfo.aliScheme optional:self.customInfo.optional payBlock:^(BOOL success, NSString *strMsg, NSError *error) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidReloadUser object:nil];
            //充值成功后调用调用接口
            [self verifyPaymentResult:nil];
        } else {
            NSLog(@"%@",strMsg);
            [[XBToastManager ShardInstance] hideprogress];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"用户中途取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

//支付成功后，通过服务器验证是否收到款------------------------------------------------------------
- (void)verifyPaymentResult:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    NSDictionary* dict = @{@"code":orderChar.code};
    [ChargeModel getVerifyResult:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([parser.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance]showtoast:@"充值成功" wait:5.0f];
            //支付成功后的跳转方法
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            for (int i = 0; i<6; i++)
            {
                rupe = i;
                if(timer)
                {
                    [timer invalidate];
                    timer = nil;
                }
                nowSeconds = 5;
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPaymentAction) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
            
        }
        
        
    }failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

- (void)timerPaymentAction
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
        if (rupe == 5) {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance] showtoast:@"连接超时，请联系客服人员" wait:5.0f];
            [timer invalidate];
            timer = nil;
            return;
        }
        [self verifyPaymentResult:nil];
    }
}

@end
