//
//  RegisterNextVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "RegisterNextVC.h"
#import "RegModel.h"
#import "RegisterPswVC.h"

#define timeWait    180

@interface RegisterNextVC ()<UITextFieldDelegate>
{
    NSString*       txtPhone;
    NSString*       txtCode;
    
    UITextField*    txtMycode;
    UIButton*       btnResend;
    NSTimer*        timer;
    __block int         leftTime;
}
@end

@implementation RegisterNextVC
- (void)viewWillDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
    }
    [super viewWillDisappear:animated];
}

- (id)initWithPhone:(NSString*)phone Mycode:(NSString*)code
{
    self = [super init];
    if(self)
    {
        txtPhone    = phone;
        txtCode     = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"验证手机";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf btnBackAction];
    }];
    
    UILabel*    send = [[UILabel alloc]initWithFrame:CGRectMake(16, 30, mainWidth-32, 20)];
    send.text = [NSString stringWithFormat:@"验证码已发送至 %@",txtPhone];
    send.textColor = [UIColor grayColor];
    send.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:send];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, mainWidth, 49)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel*    lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 49)];
    lblPhone.text = @"验证码";
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lblPhone];
    
    txtMycode = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, mainWidth - 75, 49)];
    txtMycode.backgroundColor = [UIColor clearColor];
    txtMycode.font = [UIFont systemFontOfSize:14];
    txtMycode.placeholder = @"";
    txtMycode.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtMycode.keyboardType = UIKeyboardTypeNumberPad;
    txtMycode.delegate = self;
    [bgView addSubview:txtMycode];
    [txtMycode becomeFirstResponder];
    
    btnResend = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth - 37)/2+21, 9.5, (mainWidth - 37)/2, 30)];
    btnResend.backgroundColor = mainColor;
    btnResend.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",timeWait] forState:UIControlStateNormal];
    [btnResend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnResend.layer.cornerRadius = 5;
    btnResend.layer.borderWidth = 0.5;
    [btnResend addTarget:self action:@selector(btnResendAction) forControlEvents:UIControlEventTouchUpInside];
    [btnResend setEnabled:NO];
    [bgView addSubview:btnResend];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 140, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    btnDone.userInteractionEnabled = YES;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnRegNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
    
    leftTime = timeWait;
    if(timer)
        [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionR) userInfo:nil repeats:YES];
}

- (void)btnRegNext
{
    if(txtMycode.text.length != 6)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入正确的验证码"];
        return;
    }
    [[XBToastManager ShardInstance]showprogress];
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"reg_key":txtPhone,@"code":txtMycode.text,@"timestamp":timestamp,@"token":md5Str};
    [RegModel regCompareSeverCode:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if([parser.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            RegisterPswVC* vc = [[RegisterPswVC alloc]initWithStr:txtMycode.text phone:txtPhone];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat:@"%@",parser.resultMessage] wait:5.0f];
            return ;
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

//发送验证码
- (void)btnResendAction
{
    [[XBToastManager ShardInstance] showprogress];
    if (txtPhone.length < 11) {
        [[XBToastManager ShardInstance]hideprogress];
        [[XBToastManager ShardInstance]showtoast:@"手机号不正确"];
        return;
    }
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":txtPhone,@"timestamp":timestamp,@"token":md5Str};
    [RegModel regPhoneSms:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if([parser.resultCode isEqualToString:@"203"])
        {
            [[XBToastManager ShardInstance] showtoast:@"该手机号已经注册"];
            return ;
        }
        
        leftTime = timeWait;
        [btnResend setEnabled:NO];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
        
        if(timer)
            [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionR) userInfo:nil repeats:YES];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}

- (void)timerActionR
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

- (void)btnBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
@end
