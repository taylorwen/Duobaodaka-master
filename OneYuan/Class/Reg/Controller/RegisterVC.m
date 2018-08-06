//
//  RegisterVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "RegisterVC.h"
#import "RegModel.h"
#import "RegisterNextVC.h"
#import "FindPswNextVC.h"
#import "FindPswVC.h"
#import "SettingSecureVC.h"

@interface RegisterVC ()<UITextFieldDelegate>
{
    UITextField*    txtPhone;
}
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, mainWidth, 49)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel*    lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 49)];
    lblPhone.text = @"手机号";
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lblPhone];
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, mainWidth - 75, 49)];
    txtPhone.backgroundColor = [UIColor clearColor];
    txtPhone.font = [UIFont systemFontOfSize:14];
    txtPhone.placeholder = @"";
    txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    txtPhone.delegate = self;
    [bgView addSubview:txtPhone];
    [txtPhone becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 95, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    btnDone.userInteractionEnabled = YES;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnRegMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
    
    //右边
    UIButton* btnReg = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 136, 95+44+15, 120, 20)];
    [btnReg setTitle:@"已有账号？点击登录" forState:UIControlStateNormal];
    btnReg.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnReg setTitleColor:mainColor forState:UIControlStateNormal];
    [btnReg addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReg];
    
    UIButton* btnFind = [[UIButton alloc] initWithFrame:CGRectMake(0, 95+44+15, 100, 20)];
    [btnFind setTitle:@"找回密码?" forState:UIControlStateNormal];
    btnFind.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnFind setTitleColor:mainColor forState:UIControlStateNormal];
    [btnFind addTarget:self action:@selector(btnFindPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFind];
    
    //隐私条款勾选
    UIButton* btnSec = [[UIButton alloc]initWithFrame:CGRectMake(16, 195.5, 13, 13)];
    [btnSec setImage:[UIImage imageNamed:@"ckb1"] forState:UIControlStateNormal];
    [btnSec setImage:[UIImage imageNamed:@"ckb2"] forState:UIControlStateSelected];
    [btnSec addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSec];
    
    UILabel* accept = [[UILabel alloc]initWithFrame:CGRectMake(33, 180, 200, 44)];
    accept.text = @"我已阅读并同意《               》";
    accept.textColor = [UIColor grayColor];
    accept.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:accept];
    
    UIButton* btnUser = [[UIButton alloc]initWithFrame:CGRectMake(135, 180, 60, 44)];
    [btnUser setTitleColor:mainColor forState:UIControlStateNormal];
    [btnUser setTitle:@"用户协议" forState:UIControlStateNormal];
    btnUser.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnUser addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUser];
    
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

- (void)btnRegMobile
{
    if(![[Jxb_Common_Common sharedInstance] validatePhone:txtPhone.text])
    {
        [[XBToastManager ShardInstance] showtoast:@"手机号不正确"];
        return;
    }
    [[XBToastManager ShardInstance] showprogress];
    if (txtPhone.text.length == 0) {
        [[XBToastManager ShardInstance]hideprogress];
        [[XBToastManager ShardInstance]showtoast:@"手机号为空"];
        return;
    }
    if (txtPhone.text.length < 11) {
        [[XBToastManager ShardInstance]hideprogress];
        [[XBToastManager ShardInstance]showtoast:@"手机号不正确"];
        return;
    }
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@2254412559616338026L",timestamp,txtPhone.text];
    NSString* md5Str = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"mobile":txtPhone.text,@"timestamp":timestamp,@"token":md5Str};
    [RegModel regPhoneSms:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        RegSms* p = [[RegSms alloc] initWithDictionary:dataDict error:&error];
        NSLog(@"%@",p.mobilecode);
        OneBaseParser* statusCode = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([statusCode.resultCode isEqualToString:@"200"])
        {
            RegisterNextVC* vc = [[RegisterNextVC alloc] initWithPhone:txtPhone.text Mycode:p.mobilecode];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"%@",statusCode.resultMessage]];
            return ;
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
    
    
}

#pragma mark - action
- (void)btnLoginAction
{
    LoginVC* vc  = [[LoginVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) btnFindPasswordAction
{
    FindPswVC *vc = [[FindPswVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

-(void)userClick
{
    SettingSecureVC* vc = [[SettingSecureVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
