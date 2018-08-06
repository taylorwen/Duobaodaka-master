//
//  LoginVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LoginVC.h"
#import "LoginModel.h"
#import "UserInstance.h"
#import "TabMineVC.h"
#import "RegisterVC.h"
#import "FindPswNextVC.h"
#import "UserModel.h"
#import "FindPswVC.h"
#import "NSString+MD5.h"
#import "NSData+AES.h"
#import "GTMBase64.h"

@interface LoginVC ()
{
    UITextField     *txtUser;
    UITextField     *txtPwd;
//    NSString*       myIPAddress;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIImageView* headimg = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth*0.36)];
    headimg.image = [UIImage imageNamed:@"loginhead.png"];
    [self.view addSubview:headimg];
    
    UIImageView* txt1img = [[UIImageView  alloc]initWithFrame:CGRectMake(10, mainWidth*0.36+10, mainWidth-20, 44)];
    txt1img.image = [UIImage imageNamed:@"输入框"];
    [self.view addSubview:txt1img];

    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(20, mainWidth*0.36+10+12, 20, 20)];
    imgUser.image = [UIImage imageNamed:@"login_name"];
    [self.view addSubview:imgUser];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(45, mainWidth*0.36+10, self.view.frame.size.width - 65, 44)];
    txtUser.placeholder = @"请输入您的手机号";
    txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtUser.font = [UIFont systemFontOfSize:14];
    txtUser.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:txtUser];
    
    UIImageView* txt2img = [[UIImageView  alloc]initWithFrame:CGRectMake(10, mainWidth*0.36+35+20+10, mainWidth-20, 44)];
    txt2img.image = [UIImage imageNamed:@"输入框"];
    [self.view addSubview:txt2img];
    
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(20, mainWidth*0.36+35+20+12+10, 20, 20)];
    imgPwd.image = [UIImage imageNamed:@"login_password"];
    [self.view addSubview:imgPwd];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(45, mainWidth*0.36+35+20+10, self.view.frame.size.width - 65, 44)];
    txtPwd.placeholder = @"请输入您的密码";
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.font = [UIFont systemFontOfSize:14];
    txtPwd.secureTextEntry = YES;
    [self.view addSubview:txtPwd];
    
    UIButton* btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(10, mainWidth*0.36+35+20+45+20, mainWidth - 20, 44)];
    btnLogin.layer.cornerRadius = 17.5;
    btnLogin.backgroundColor = mainColor;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    UIButton* btnFind = [[UIButton alloc] initWithFrame:CGRectMake(0, mainWidth*0.36+35+20+45+44+15+9, 100, 30)];
    [btnFind setTitle:@"找回密码?" forState:UIControlStateNormal];
    btnFind.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnFind setTitleColor:mainColor forState:UIControlStateNormal];
    [btnFind addTarget:self action:@selector(btnFindPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFind];
    
    UILabel* third = [[UILabel alloc]initWithFrame:CGRectMake(10, mainWidth*0.36+35+20+45+44+15+9+40, 200, 20)];
    third.text      = @"其他登录方式";
    third.textColor = [UIColor lightGrayColor];
    third.font      = [UIFont systemFontOfSize:12];
//    [self.view addSubview:third];
    
    UIImageView* thirdLine = [[UIImageView alloc]initWithFrame:CGRectMake(85, mainWidth*0.36+35+20+45+44+15+9+40+10, mainWidth-95, 0.5)];
    thirdLine.backgroundColor = myLineColor;
//    [self.view addSubview:thirdLine];
    
    UIButton* btnQQ = [[UIButton alloc]initWithFrame:CGRectMake((mainWidth-50)/2-50-30, mainWidth*0.36+238, 50, 50)];
    btnQQ.layer.masksToBounds = YES;
    btnQQ.layer.cornerRadius = 25;
    [btnQQ setImage:[UIImage imageNamed:@"登录_03"] forState:UIControlStateNormal];
    [btnQQ addTarget:self action:@selector(btnQQclicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnQQ];
    
    UIButton* btnWechat = [[UIButton alloc]initWithFrame:CGRectMake((mainWidth-50)/2, mainWidth*0.36+238, 50, 50)];
    btnWechat.layer.masksToBounds = YES;
    btnWechat.layer.cornerRadius = 25;
    [btnWechat setImage:[UIImage imageNamed:@"登录_05"] forState:UIControlStateNormal];
//    [self.view addSubview:btnWechat];
    
    UIButton* btnWeibo = [[UIButton alloc]initWithFrame:CGRectMake((mainWidth-50)/2+50+30, mainWidth*0.36+238, 50, 50)];
    btnWeibo.layer.masksToBounds = YES;
    btnWeibo.layer.cornerRadius = 25;
    [btnWeibo setImage:[UIImage imageNamed:@"登录_07"] forState:UIControlStateNormal];
//    [self.view addSubview:btnWeibo];
    
    UILabel* lblAlert = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-50-64-50, mainWidth-20, 45)];
    lblAlert.textColor = [UIColor redColor];
    lblAlert.textAlignment = NSTextAlignmentCenter;
    lblAlert.font = [UIFont systemFontOfSize:13];
    lblAlert.lineBreakMode = NSLineBreakByWordWrapping;
    lblAlert.numberOfLines = 2;
    lblAlert.text = @"苹果公司不会以任何形式参与到夺宝大咖中，本产品所有活动及商品均与苹果公司无关。";
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"0"]) {
        [self.view addSubview:lblAlert];
    }
}

- (void)btnQQclicked
{
    NSLog(@"点击了qq登录");
}

#pragma mark - action
- (void)btnRegAction
{
    RegisterVC* vc  = [[RegisterVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) btnFindPasswordAction
{
    FindPswVC *vc = [[FindPswVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnLoginAction
{
    if(txtUser.text.length==    0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入账号"];
        return;
    }
    if(txtPwd.text.length==     0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入密码"];
        return;
    }
    [[XBToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    
    //---------------请求用户IP地址---------------------------------------
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSString *str=[NSString stringWithFormat:@"http://1111.ip138.com/ic.asp"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:enc]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        [wSelf loginUser:myIPAddress];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[XBToastManager ShardInstance]hideprogress];
        NSLog(@"发生错误！%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)loginUser:(NSString*)string
{
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtUser.text];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":txtUser.text,@"password":txtPwd.text,@"timestamp":timestamp,@"token":token};
    [LoginModel doLogin:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        //JSON解析开始
        NSError* error = nil;
        LoginParser* parser = [[LoginParser alloc] initWithDictionary:dataDict  error:&error];
        LoginStatusParser *status = [[LoginStatusParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([status.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
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
            [userDefaults setObject:parser.user_ip      forKey:@"user_ip"];
            [userDefaults setObject:parser.username     forKey:@"username"];
            [userDefaults setObject:parser.yaoqing      forKey:@"yaoqing"];
            [userDefaults setObject:parser.addgroup     forKey:@"addgroup"];
            [userDefaults setObject:parser.band         forKey:@"band"];
            [userDefaults setObject:parser.img          forKey:@"img"];
            [userDefaults setObject:parser.groupName    forKey:@"groupName"];
            [userDefaults setObject:parser.auth_key     forKey:@"auth_key"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UserInstance ShardInstnce] isUserStillOnline];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
            [wSelf btnBackAction];
        }
        else
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"%@", status.resultMessage ]];
        }
    } failure:^(NSError* error){
        
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@"登录失败"];
    }];
}
@end