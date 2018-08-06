//
//  CartPayVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/10.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartPayVC.h"
#import "PaymentOptView.h"
#import "PayproCell.h"
#import "UserInstance.h"
#import <BCMMMPay/BCMMMPayViewController.h>
#import <BCMMMPay/BCMMMPay.h>
#import <BeeCloud/BeeCloud.h>
#import <BCAliPay/BCAliPay.h>
#import <BCWXPay/BCWXPay.h>
#import <BCUnionPay/BCUnionPay.h>
#import "CustomInfo.h"
#import "SuccessViewController.h"
#import "CartModel.h"
#import "BeeCloud/BCUtil.h"
#import "AppDelegate.h"
#import "ChargeModel.h"
#import "NSString+MD5.h"
#import "AFNetworking.h"
#import "CartBtnCell.h"
#import "CartShowMoreCell.h"


@interface CartPayVC ()<UITableViewDataSource,UITableViewDelegate,PaymentBtnViewDelegate,PaymentShowViewDelegate,UIAlertViewDelegate>
{
    __block UITableView         *tbView;
    __block PaymentOptView      *viewOpt;
            CartItem            *myItem;
    __block UIImageView         *imgPro;
    __block UILabel             *lblTitle;
    __block UILabel             *lblyungoujia;
    __block NSArray             *arrData;
    __block NSString            *total;         //总需支付金额
    __block NSString            *finalPay;       //抵扣后需要支付的金额
    
    __block NSInteger           row;
    __block NSString            *textMoney;     //测试付款金额
    __block NSString            *pay_type;
    __block ChargeOrder         *orderChar;     //解析到的充值model
    __block ChargeResult        *resultChar;    //充值成功返回model
    __block BuyRequestModel     *requestModel;  //请求购买的参数model
    __block NSString            *myIP;
    NSInteger                   rowIndex;
    __block NSTimer             *timer;
    NSInteger                   nowSeconds;
    __block int                 rupe;
}

@end


@implementation CartPayVC

- (id)initWithTotalMoney:(NSString*)totalMoney
{
    self = [super init];
    if(self)
    {
        total = totalMoney;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    rowIndex = 3;
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [self reloadCartItem];
    NSLog(@"%@",arrData);
}

- (void)reloadCartItem
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
//        [tbView.pullToRefreshView stopAnimating];
        arrData = result;
        
        [tbView reloadData];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if (arrData.count < 3) {
            return arrData.count;
        }else
        {
            return rowIndex;
        }
    }
    if (section == 2) {
        if ([[UserInstance ShardInstnce].score intValue] > 100) {
            if ([[UserInstance ShardInstnce].money intValue] < [total intValue]) {
                return 2;
            }
            
        }else
        {
            return 1;
        }
    }
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }

    if (indexPath.section == 3)
    {
        if (indexPath.row == 1) {
            return 60;
        }
    }
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return 0.01;
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        CartShowMoreCell* v = [[CartShowMoreCell alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 24)];
        [v setPaymentValue:total];
        v.delegate = self;
        return v;
        
    }
    if (section == 2)
    {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 30)];
        
        int a;
        if ([total intValue] < [[UserInstance ShardInstnce].money intValue])
        {
            a = 0;
        }
        else
        {
            a = [total intValue]-[[UserInstance ShardInstnce].money intValue];
        }
        
        NSString* str = [NSString stringWithFormat:@"%d 夺宝币",a];
        
        CGSize s = [str textSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 300, 30)];
        lbl.text = @"其他支付方式：";
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = [UIColor grayColor];
        [vvv addSubview:lbl];
        
        s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(lbl.frame.origin.x + s.width, lbl.frame.origin.y, 300, 30)];
        
        lblCode.text = str;
        lblCode.font = [UIFont systemFontOfSize:15];
        lblCode.textColor = [UIColor redColor];
        [vvv addSubview:lblCode];
        
        return vvv;
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"allProItemCell";
        PayproCell *cell = (PayproCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[PayproCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        [cell setCart:[arrData objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"allProyueCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor grayColor];
            if ([[UserInstance ShardInstnce].money intValue] <= [total intValue]) {
                cell.textLabel.text = [NSString stringWithFormat:@"          余额抵扣: %@夺宝币",[UserInstance ShardInstnce].money];
            }
            else{
                cell.textLabel.text = [NSString stringWithFormat:@"          余额抵扣: %@夺宝币",total];
            }
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"         (账户余额：%@夺宝币)",[UserInstance ShardInstnce].money];
            
            UIImageView* pay = [[UIImageView alloc]initWithFrame:CGRectMake(16, 8.5, 32, 32)];
            pay.image = [UIImage imageNamed:@"yue"];
            [cell addSubview:pay];
            
            UIImageView* sw = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth-41, 16.5, 31, 16)];
            [cell addSubview:sw];
            
            if ([[UserInstance ShardInstnce].money intValue] > 0)
            {
                sw.image = [UIImage imageNamed:@"开"];
            }
            else
            {
                sw.image = [UIImage imageNamed:@"关"];
            }
            
            return cell;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"allProZhiCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = @"           支付宝支付";
            
            UIImageView* pay = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6.5, 36, 36)];
            pay.image = [UIImage imageNamed:@"aliPay"];
            [cell addSubview:pay];
            
            UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth-40, 14.5, 20, 20)];
            int a = [[UserInstance ShardInstnce].money intValue] + [[UserInstance ShardInstnce].score intValue]/100;
            if (a < [total intValue]) {
                img.image = [UIImage imageNamed:@"screening_select"];
            }else
            {
                img.image = [UIImage imageNamed:@"screening_unselect"];
            }
            [cell addSubview:img];
            
            return cell;
        }
    }
    if (indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"proBtnItemCell";
        CartBtnCell *cell = (CartBtnCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[CartBtnCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setCartPay:(CartItem*)item
{
    myItem = item;
    [imgPro setImage_oy:nil image:item.thumb];
    lblTitle.text = [NSString stringWithFormat:@"%@%@",item.qishu,item.title];
    lblyungoujia.text = item.gonumber;
}

- (void)cellCallThirdPartyPaymentAction
{
    //是否需要使用第三方支付
    int r = 0;
    r = [[UserInstance ShardInstnce].money intValue] -[total intValue];
    if (r < 0) {
        //需要启用支付宝支付,支付宝支付金额是减去余额后的差价；
        row = 3;
        pay_type = @"支付宝";
        [self requestOrder:nil];
    }else
    {
        row = 2;
        pay_type = @"余额";
        [self yuEPay];
    }
}

//余额支付
- (void)yuEPay
{
    [[[UIAlertView alloc] initWithTitle:@"您将使用夺宝币付款"
                                message:nil
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
        
        [CartModel removeAllCart];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCart object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReloadUser object:nil];
        
        [self BuySuccessData:nil];
        
    }], nil] show];
    
}

//此处因购买生成订单的接口未完成，所以购买的时候点击支付，先请求充值生成订单接口，然后请求充值成功接口，完成后，自动从余额里面扣除一定数量的金额来请求支付成功接口；
//请求订单，生成订单号；
- (void)requestOrder:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    NSString* uid   = [UserInstance ShardInstnce].uid;
    //抵扣掉余额和咖豆的金额后，还需支付宝支付的金额
    finalPay = [NSString stringWithFormat:@"%d", [total intValue] - [[UserInstance ShardInstnce].money intValue]];
    NSString* money = [NSString stringWithFormat:@"%@", finalPay];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":uid,@"money":money,@"pay_type":pay_type,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [ChargeModel getChargeOrder:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError*      error    = nil;
        orderChar = [[ChargeOrder alloc]initWithDictionary:dataDict error:&error];
        if ([parser.resultCode isEqualToString:@"200"])
        {
            [self aliPay];
        }else
        {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"[%@]%@",parser.resultCode,parser.resultMessage]
                                        message:nil
                               cancelButtonItem:nil
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

//支付宝支付
//只有使用支付宝充值付款的时候，才会调用充值接口，其他的方式不调用；
- (void)aliPay
{
    NSString* subject = [NSString stringWithFormat:@"夺宝大咖iOS:%@",orderChar.code]; //传给支付宝的标题;
    [BCAliPay reqAliPayment:self.customInfo.traceID outTradeNo:orderChar.code subject:subject body:self.customInfo.body totalFee:finalPay scheme:self.customInfo.aliScheme optional:self.customInfo.optional payBlock:^(BOOL success, NSString *strMsg, NSError *error) {
        if (success) {
            [CartModel removeAllCart];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCart object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidReloadUser object:nil];
            //充值成功后调用的接口
            [self verifyPaymentResult:nil];
            
        } else
        {
            NSLog(@"%@",strMsg);
            // 表明支付过程中出现错误，strMsg为错误原因
            [[XBToastManager ShardInstance]hideprogress];
//            [[XBToastManager ShardInstance]showtoast:@"支付失败，用户中途取消" wait:5];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"用户中途取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}

//支付成功后，通过服务器验证是否收到款------------------------------------------------------------
- (void)verifyPaymentResult:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"code":orderChar.code,@"timestamp":timestamp,@"token":token};
    [ChargeModel getVerifyResult:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([parser.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            [self BuySuccessData:nil];
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
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"连接超时" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [timer invalidate];
            timer = nil;
            return;
        }
        [self verifyPaymentResult:nil];
    }
}

//用户购买商品后发送购买的商品信息到服务器
- (void)BuySuccessData:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    
    NSString* uid = [UserInstance ShardInstnce].uid;
    
    NSMutableArray*         requestArr  = [[NSMutableArray alloc] init];
    for (int i=0; i<arrData.count; i++) {
        BuyRequestModel *  model  = [arrData objectAtIndex:i];
        
        NSDictionary*    _dict = @{@"gonumber":[NSString stringWithFormat:@"%d",[model.gonumber intValue]*[model.yunjiage intValue]],@"pid":model.pid,@"qishu":model.qishu,@"sid":model.sid};
        [requestArr addObject:_dict ];
    }
    
    NSString* ip = [UserInstance ShardInstnce].user_ip;
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":uid,
                           @"ip":ip,
                           @"score":@"0",
                           @"goshops":requestArr,
                           @"auth_key":[UserInstance ShardInstnce].auth_key,
                           @"timestamp":timestamp,
                           @"token":token};
    [ChargeModel getBuyResult:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSArray* dataArr = [BuyRequestModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        
        if ([parser.resultCode isEqualToString:@"200"]) {
            [[XBToastManager ShardInstance]hideprogress];
            SuccessViewController* vc = [[SuccessViewController alloc]initWithGoodsId:arrData buyCode:dataArr];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance]hideprogress];
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",parser.resultCode,parser.resultMessage]
                                        message:nil
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                self.tabBarController.selectedIndex = 0;
                [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
            }], nil] show];
        }
        
    }failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];

    }];
    
}

- (void)addMoreItems
{
    rowIndex = arrData.count;
    [tbView reloadData];
}

- (void)showThreeItems
{
    rowIndex = 3;
    [tbView reloadData];
}

@end