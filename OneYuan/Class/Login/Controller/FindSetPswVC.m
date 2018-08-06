//
//  FindSetPswVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "FindSetPswVC.h"
#import "FindPSWModel.h"
#import "UserInstance.h"
#import "LoginModel.h"

@interface FindSetPswVC ()<UITextFieldDelegate>
{
    NSString* myPhone;
    NSString* mobileCode;
    
    __block UITextField     *txtPwd;
}
@end

@implementation FindSetPswVC

- (id)initWithStr:(NSString*)str phone:(NSString*)phone
{
    self = [super init];
    if(self)
    {
        myPhone = phone;
        mobileCode = str;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
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
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    img.image = [UIImage imageNamed:@"login_password"];
    [vvv addSubview:img];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, mainWidth - 80, 34)];
    txtPwd.backgroundColor = [UIColor whiteColor];
    txtPwd.font = [UIFont systemFontOfSize:13];
    txtPwd.placeholder = @"请输入长度6-20位的登录密码";
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.keyboardType = UIKeyboardAppearanceDefault;
    txtPwd.secureTextEntry = YES;
    txtPwd.delegate = self;
    [vvv addSubview:txtPwd];
    [txtPwd becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 75, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"更新密码" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnSetPswAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0 && textField.text.length > 19)
    {
        return false;
    }
    return YES;
}

- (void)btnSetPswAction
{
    if(txtPwd.text.length < 6 || txtPwd.text.length > 20)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入6-20位的密码"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,myPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":myPhone,@"mobilecode":mobileCode,@"password":txtPwd.text,@"timestamp":timestamp,@"token":md5Str};
    [FindPSWModel reSetPassword:dict success:^(AFHTTPRequestOperation* operation1, NSObject* result1){
        NSError* error = nil;
        OneBaseParser* r = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result1 error:&error];
        if(![r.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"%@",r.resultMessage]];
            return ;
        }
        [[XBToastManager ShardInstance]hideprogress];
        [wSelf doLogin];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
    }];
    
    
}

//注册成功后跳转到登陆页面；
- (void)doLogin
{
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,myPhone];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":myPhone,@"password":txtPwd.text,@"timestamp":timestamp,@"token":md5Str};
    [LoginModel doLogin:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        LoginParser* parser = [[LoginParser alloc] initWithDictionary:dataDict error:&error];
        OneBaseParser* statusCode = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([statusCode.resultCode isEqualToString:@"200"])
        {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:parser.mobile       forKey:@"mobile"];
            [userDefaults setObject:parser.mobilecode   forKey:@"mobilecode"];
            [userDefaults setObject:parser.email        forKey:@"email"];
            [userDefaults setObject:parser.emailcode    forKey:@"emailcode"];
            [userDefaults setObject:parser.groupid      forKey:@"groupid"];
            [userDefaults setObject:parser.jingyan      forKey:@"jingyan"];
            [userDefaults setObject:parser.login        forKey:@"login"];
            [userDefaults setObject:parser.money        forKey:@"money"];
            [userDefaults setObject:parser.passcode     forKey:@"passcode"];
            [userDefaults setObject:parser.password     forKey:@"password"];
            [userDefaults setObject:parser.qianming     forKey:@"qianming"];
            [userDefaults setObject:parser.reg_key      forKey:@"reg_key"];
            [userDefaults setObject:parser.score        forKey:@"score"];
            [userDefaults setObject:parser.time         forKey:@"time"];
            [userDefaults setObject:parser.uid          forKey:@"uid"];
            [userDefaults setObject:parser.username     forKey:@"username"];
            [userDefaults setObject:parser.yaoqing      forKey:@"yaoqing"];
            [userDefaults setObject:parser.addgroup     forKey:@"addgroup"];
            [userDefaults setObject:parser.band         forKey:@"band"];
            [userDefaults setObject:parser.img          forKey:@"img"];
            [userDefaults setObject:parser.groupName    forKey:@"groupName"];
            [userDefaults setObject:parser.user_ip      forKey:@"user_ip"];
            [userDefaults setObject:parser.auth_key     forKey:@"auth_key"];
            
            [[UserInstance ShardInstnce] isUserStillOnline];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [wSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }
        else{
            [[XBToastManager ShardInstance] hideprogress];
            if([statusCode.resultCode isEqualToString:@"204"])
            {
                [[XBToastManager ShardInstance] showtoast:@"您输入的密码不正确"];
            }
            else
                [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"登录失败:%@",statusCode.resultCode]];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@"登录失败"];
    }];
    
}

@end
