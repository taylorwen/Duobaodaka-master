//
//  FindPswVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/28.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "FindPswVC.h"
#import "FindPSWModel.h"
#import "FindPswNextVC.h"

@interface FindPswVC () <UITextFieldDelegate>
{
    __block int         leftTime;
    __block NSTimer     *timer;
    __block UITextField *txtCode;
    __block UITextField *txtPhone;
    __block UIButton    *btnResend;
    __block NSString    *myCode;
    __block FindRegSms      *sms;
}
@end

@implementation FindPswVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"找回密码";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 15, mainWidth - 32, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 3;
    [self.view addSubview:vvv];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    img.image = [UIImage imageNamed:@"login_name"];
    [vvv addSubview:img];
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, mainWidth - 80, 34)];
    txtPhone.backgroundColor = [UIColor whiteColor];
    txtPhone.font = [UIFont systemFontOfSize:13];
    txtPhone.placeholder = @"请输入您的手机号";
    txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    txtPhone.delegate = self;
    [vvv addSubview:txtPhone];
    [txtPhone becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 75, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnPswAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0)
    {
        if(textField.text.length > 10)
            return NO;
        if([string isEqualToString:@"0"])
            return YES;
        if([string intValue] == 0)
            return NO;
    }
    return YES;
}

- (void)btnPswAction
{
    if(![[Jxb_Common_Common sharedInstance] validatePhone:txtPhone.text])
    {
        [[XBToastManager ShardInstance] showtoast:@"输入的手机号不正确"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance]showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone.text];
    NSString* md5Str = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"mobile":txtPhone.text,@"timestamp":timestamp,@"token":md5Str};
    [FindPSWModel findPhoneSms:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        NSError* error = nil;
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        sms = [[FindRegSms alloc] initWithDictionary:dataDict error:&error];
        myCode = sms.mobilecode;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if([parser.resultCode isEqualToString:@"200"])
        {
            FindPswNextVC* vc = [[FindPswNextVC alloc]initWithPhoneP:txtPhone.text MycodeP:myCode];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([parser.resultCode isEqualToString:@"201"])
        {
            [[XBToastManager ShardInstance]showtoast:@"手机号不正确"];
            return ;
        }
        else if ([parser.resultCode isEqualToString:@"202"])
        {
            [[XBToastManager ShardInstance]showtoast:@"账号不存在"];
            return ;
        }
        else if ([parser.resultCode isEqualToString:@"203"])
        {
            [[XBToastManager ShardInstance]showtoast:@"该手机号初始化过注册但还没有通过验证码"];
            return ;
        }
        else
        {
            [[XBToastManager ShardInstance] showtoast:@"验证码已经发送到你的手机，不允许在一定时间内连续发送验证码"];
            return ;
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
}
@end
