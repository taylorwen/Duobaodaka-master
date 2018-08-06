//
//  PersonPasswordVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/5.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonPasswordVC.h"
#import "PersonModel.h"
#import "LoginVC.h"

@interface PersonPasswordVC ()<UITextFieldDelegate>
{
    __block UITextField* txtOld;
    __block UITextField* txtNew;
    
}
@end

@implementation PersonPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 15, mainWidth-32, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 5;
    [self.view addSubview:vvv];
    
    txtOld = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, mainWidth - 52, 34)];
    txtOld.backgroundColor = [UIColor whiteColor];
    txtOld.font = [UIFont systemFontOfSize:13];
    txtOld.placeholder = @"请输入您的旧密码";
    txtOld.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtOld.keyboardType = UIKeyboardTypeDefault;
    txtOld.secureTextEntry = YES;
    txtOld.delegate = self;
    UIImageView* img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    txtOld.leftView = img1;
    txtOld.leftViewMode = UITextFieldViewModeAlways;
    [vvv addSubview:txtOld];
    [txtOld becomeFirstResponder];
    
    UIView* vvv1 = [[UIView alloc] initWithFrame:CGRectMake(16, 75, mainWidth-32, 44)];
    vvv1.backgroundColor = [UIColor whiteColor];
    vvv1.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv1.layer.borderWidth = 0.5;
    vvv1.layer.cornerRadius = 5;
    [self.view addSubview:vvv1];
    
    txtNew = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, mainWidth - 52, 34)];
    txtNew.backgroundColor = [UIColor whiteColor];
    txtNew.font = [UIFont systemFontOfSize:13];
    txtNew.placeholder = @"请输入您的新密码";
    txtNew.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtNew.keyboardType = UIKeyboardTypeDefault;
    txtNew.secureTextEntry = YES;
    txtNew.delegate = self;
    UIImageView* img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    txtNew.leftView = img2;
    txtNew.leftViewMode = UITextFieldViewModeAlways;
    [vvv1 addSubview:txtNew];
    [txtNew becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 135, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"确认修改" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnChangePsw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

- (void)btnChangePsw
{
   
    if (txtOld.text.length < 6)
    {
        [[XBToastManager ShardInstance]showtoast:@"输入旧密码格式不正确，请重新输入"];
        return;
    }
    if (txtNew.text.length < 6)
    {
        [[XBToastManager ShardInstance]showtoast:@"输入新密码格式不正确，请重新输入"];
        return;
    }
    [[XBToastManager ShardInstance]showprogress];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* userId = [UserInstance ShardInstnce].uid;
    NSString* mobile = [UserInstance ShardInstnce].mobile;
    NSDictionary* dict = @{@"uid":userId,@"mobile":mobile,@"password":txtOld.text,@"newPassword":txtNew.text,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [PersonModel doChangePassword:dict success:^(AFHTTPRequestOperation *operation, NSObject *result)
     {

         OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
         if ([parser.resultCode isEqualToString:@"200"]) {
             [[XBToastManager ShardInstance]hideprogress];
             [[UserInstance ShardInstnce] logout];
             
             NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
             [userdefaults setObject:nil forKey:@"uid"];
             [userdefaults synchronize];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kDidUserLogout object:nil];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
             
         }
         else
         {
             [[XBToastManager ShardInstance]showtoast:@"修改密码失败！"];
         }
         
         
         
         
     }failure:^(NSError *error)
     {
         [[XBToastManager ShardInstance]hideprogress];
     }];
    
    [[XBToastManager ShardInstance]hideprogress];
}
@end
