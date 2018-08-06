//
//  FindPswNextVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "FindPswNextVC.h"
#import "FindPSWModel.h"
#import "UserInstance.h"
#import "LoginModel.h"
#import "FindSetPswVC.h"

#define timeWait    180

@interface FindPswNextVC ()<UITextFieldDelegate>
{
    __block int         leftTime;
    __block NSTimer     *timer;
    __block UITextField *txtCode;
    __block NSString    *txtPhone;
    __block UIButton    *btnResend;
    __block NSString    *myCode;
    __block FindRegSms  *sms;

}
@end

@implementation FindPswNextVC

- (id)initWithPhoneP:(NSString*)phone MycodeP:(NSString*)code
{
    self = [super init];
    if(self)
    {
        txtPhone = phone;
        myCode = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, mainWidth - 32, 15)];
    lbl.text = @"已将验证码发送到您的手机，请注意查收";
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 40, 150, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 3;
    [self.view addSubview:vvv];
    
    txtCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 120, 34)];
    txtCode.backgroundColor = [UIColor whiteColor];
    txtCode.font = [UIFont systemFontOfSize:13];
    txtCode.placeholder = @"请输入6位验证码";
    txtCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtCode.keyboardType = UIKeyboardTypeNumberPad;
    txtCode.delegate = self;
    [vvv addSubview:txtCode];
    
    btnResend = [[UIButton alloc] initWithFrame:CGRectMake(180, 40, mainWidth - 196, 44)];
    btnResend.backgroundColor = [UIColor whiteColor];
    btnResend.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",timeWait] forState:UIControlStateNormal];
    [btnResend setTitleColor:mainColor forState:UIControlStateNormal];
    btnResend.layer.cornerRadius = 5;
    btnResend.layer.borderWidth = 0.5;
    btnResend.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    [btnResend addTarget:self action:@selector(btnPswResendAction) forControlEvents:UIControlEventTouchUpInside];
    [btnResend setEnabled:NO];
    [self.view addSubview:btnResend];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 95, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnPswNextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
    
    leftTime = timeWait;
    if(timer)
        [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionPsw) userInfo:nil repeats:YES];
}

- (void)btnPswNextAction
{
    if(txtCode.text.length != 6)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入正确的验证码"];
        return;
    }
    __weak typeof (self) wSelf = self;
    
    [[XBToastManager ShardInstance]showprogress];
    NSLog(@"%@",myCode);
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":txtPhone,@"code":txtCode.text,@"timestamp":timestamp,@"token":md5Str};
    [FindPSWModel findCompareSeverCode:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if([parser.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            FindSetPswVC* vc = [[FindSetPswVC alloc] initWithStr:txtCode.text phone:txtPhone];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat:@"%@",parser.resultMessage] wait:5.0f];
            return ;
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

- (void)btnPswResendAction
{
    [[XBToastManager ShardInstance] showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"mobile":txtPhone,@"timestamp":timestamp,@"token":md5Str};
    [FindPSWModel findPhoneSms:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        NSError* error = nil;
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        sms = [[FindRegSms alloc] initWithDictionary:dataDict error:&error];
        myCode = sms.mobilecode;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if(![parser.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] showtoast:@"验证码发送已超过当日允许次数"];
            return ;
        }
        leftTime = timeWait;
        [btnResend setEnabled:NO];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
        if(timer)
            [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionPsw) userInfo:nil repeats:YES];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0)
    {
        if(textField.text.length > 5)
            return NO;
        if([string isEqualToString:@"0"])
            return YES;
        if([string intValue] == 0)
            return NO;
    }
    return YES;
}

- (void)timerActionPsw
{
    leftTime--;
    if(leftTime<=0)
    {
        [btnResend setEnabled:YES];
        [btnResend setTitle:@"点击重新发送" forState:UIControlStateNormal];
        [btnResend setTitle:@"点击重新发送" forState:UIControlStateDisabled];
    }
    else
    {
        [btnResend setEnabled:NO];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
    }
}

@end
