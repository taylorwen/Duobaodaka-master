//
//  RegisterPswVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "RegisterPswVC.h"
#import "RegModel.h"
#import "LoginModel.h"

@interface RegisterPswVC ()<UITextFieldDelegate>
{
    UITextField*    txtPwd;
    NSString*       myPhone;
    NSString*       mobileCode;
}
@end

@implementation RegisterPswVC
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
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, mainWidth, 49)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel*    lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 49)];
    lblPhone.text = @"密码";
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lblPhone];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, mainWidth - 75, 49)];
    txtPwd.backgroundColor = [UIColor clearColor];
    txtPwd.font = [UIFont systemFontOfSize:14];
    txtPwd.placeholder = @"请设置密码";
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.keyboardType = UIKeyboardTypeDefault;
    txtPwd.delegate = self;
    txtPwd.secureTextEntry = YES;
    [bgView addSubview:txtPwd];
    [txtPwd becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 110, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    btnDone.userInteractionEnabled = YES;
    [btnDone setTitle:@"完成注册" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnDoRegister) forControlEvents:UIControlEventTouchUpInside];
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

- (void)btnDoRegister
{
    if(txtPwd.text.length < 6 || txtPwd.text.length > 20)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入6-20位的密码"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    //---------------请求用户IP地址---------------------------------------
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSString *str=[NSString stringWithFormat:@"http://1111.ip138.com/ic.asp"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:enc]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[XBToastManager ShardInstance]hideprogress];
        NSData* data = (NSData*)responseObject;
        NSString* strData = [[NSString alloc]initWithData:data encoding:enc];
        
        NSRange range       = [strData rangeOfString:@"来自："];
        NSString* a         = [strData substringFromIndex:range.location+range.length];
        NSRange range1      = [a rangeOfString:@"</center>"];
        NSString* address   = [a substringToIndex:range1.location];
        
        NSRange ran         = [strData rangeOfString:@"["];
        NSString* A         = [strData substringFromIndex:ran.location+ran.length];
        NSRange ran1        = [A rangeOfString:@"]"];
        NSString* IP        = [A substringToIndex:ran1.location];
        
        NSString* myIPAddress = [NSString stringWithFormat:@"[iOS]%@,%@",address,IP];
        NSLog(@"获取到的数据为：%@",myIPAddress);
        [wSelf registerUser:myIPAddress];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[XBToastManager ShardInstance]hideprogress];
        NSLog(@"发生错误！%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)registerUser:(NSString*)string
{
    __weak typeof (self) wSelf = self;
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,myPhone];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":myPhone,@"mobilecode":mobileCode,@"password":txtPwd.text,@"user_ip":string,@"register_plat":@"AppStore",@"register_channel":@"iOS",@"timestamp":timestamp,@"token":token};
    
    [RegModel regPhoneCode:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if([parser.resultCode isEqualToString:@"200"])
        {
            [wSelf doLogin];
        }
        else
        {
            [[XBToastManager ShardInstance]hideprogress];
            [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat:@"%@",parser.resultMessage] wait:3.0f];
        }
        
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
    //登录----------------------------
    NSDictionary* dict = @{@"mobile":myPhone,@"password":txtPwd.text,@"timestamp":timestamp,@"token":md5Str};
    
    [LoginModel doLogin:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        LoginParser* parser = [[LoginParser alloc] initWithDictionary:dataDict error:&error];//解析到login的model中
        OneBaseParser* statusCode = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([statusCode.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance]hideprogress];
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
