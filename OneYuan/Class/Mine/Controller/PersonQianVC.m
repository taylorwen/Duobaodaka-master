//
//  PersonQianVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/4.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "PersonQianVC.h"
#import "PersonModel.h"

@interface PersonQianVC ()<UITextFieldDelegate>
{
    __block UITextField* txtPhone;
}
@end

@implementation PersonQianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置签名";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 25, mainWidth-32, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 5;
    [self.view addSubview:vvv];
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, mainWidth - 52, 34)];
    txtPhone.backgroundColor = [UIColor whiteColor];
    txtPhone.font = [UIFont systemFontOfSize:13];
    txtPhone.placeholder = @"请输入您的签名";
    txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhone.keyboardType = UIKeyboardTypeDefault;
    txtPhone.delegate = self;
    [vvv addSubview:txtPhone];
    [txtPhone becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 80, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"确认修改" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnChangeSigniture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
    
}

- (void)btnChangeSigniture
{
    [[XBToastManager ShardInstance]showprogress];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* userId = [UserInstance ShardInstnce].uid;
    NSDictionary* dict = @{@"uid":userId,@"qianming":txtPhone.text,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [PersonModel doEditQianming:dict success:^(AFHTTPRequestOperation *operation, NSObject *result)
     {
         NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
         NSError* error = nil;
         QianmingModel *user = [[QianmingModel alloc]initWithDictionary:dataDict error:&error];
         OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
         if ([parser.resultCode isEqualToString:@"200"]) {
             [[XBToastManager ShardInstance]hideprogress];
             
             NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:user.qianming forKey:@"qianming"];
             
             [[UserInstance ShardInstnce] isUserStillOnline];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [[XBToastManager ShardInstance]showtoast:@"修改昵称失败！"];
         }
         
     }failure:^(NSError *error)
     {
         [[XBToastManager ShardInstance]hideprogress];
     }];
    
    [[XBToastManager ShardInstance]hideprogress];
}


@end
