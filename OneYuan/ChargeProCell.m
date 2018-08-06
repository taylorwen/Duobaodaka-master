//
//  PayproCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/20.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ChargeProCell.h"
#import "UIImage+ImageEffects.h"
#import "MineChargeVC.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface ChargeProCell ()<UITextFieldDelegate>
{
    __weak id<ChargeProCellDelegate> delegate;
    
    CartItem    *myItem;
    UIImageView *imgPro;
    UILabel     *lblTitle;
    __block UILabel     *lblLeft;
    NSString    *lblYunjiage;
    
    UIButton    *wushi;
    UIButton    *yibai;
    UIButton    *liangbai;
    UIButton    *wubai;
    UIButton    *yiqian;
    UITextField *inputMoney;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    MineChargeVC        *viewController;

}

@end

@implementation ChargeProCell
@synthesize delegate,wubai,yiqian,yibai,liangbai,wushi;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat perWidth = (mainWidth-40)/3;
        CGFloat perHeight = 30;
        
        wushi = [[UIButton alloc]initWithFrame: CGRectMake(10, 10, perWidth, perHeight)];
        [wushi setTitle:@"50" forState:UIControlStateNormal];
        [wushi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [wushi setBackgroundImage:[UIImage imageNamed:@"ChargeUnselect"] forState: UIControlStateNormal];
        [wushi setBackgroundImage:[UIImage imageNamed:@"ChargeSelected"] forState: UIControlStateSelected];
        wushi.titleLabel.font = [UIFont systemFontOfSize:13];
        wushi.layer.cornerRadius = 4;
        wushi.selected = YES;
        [wushi addTarget:self action:@selector(selectAmount50) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:wushi];
        
        yibai = [[UIButton alloc] initWithFrame:CGRectMake(10*2+perWidth, 10, perWidth, perHeight)];
        [yibai setTitle:@"100" forState:UIControlStateNormal];
        [yibai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [yibai setBackgroundColor:[UIColor clearColor]];
        [yibai setBackgroundImage:[UIImage imageNamed:@"ChargeUnselect"] forState: UIControlStateNormal];
        [yibai setBackgroundImage:[UIImage imageNamed:@"ChargeSelected"] forState:UIControlStateSelected];
        yibai.titleLabel.font = [UIFont systemFontOfSize:13];
        yibai.layer.cornerRadius = 4;
        [yibai addTarget:self action:@selector(selectAmount100) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:yibai];

        liangbai = [[UIButton alloc] initWithFrame:CGRectMake(10*3+perWidth*2, 10, perWidth, perHeight)];
        [liangbai setTitle:@"200" forState:UIControlStateNormal];
        [liangbai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [liangbai setBackgroundImage:[UIImage imageNamed:@"ChargeUnselect"] forState: UIControlStateNormal];
        [liangbai setBackgroundImage:[UIImage imageNamed:@"ChargeSelected"] forState: UIControlStateSelected];
        liangbai.titleLabel.font = [UIFont systemFontOfSize:13];
        liangbai.layer.cornerRadius = 4;
        [liangbai addTarget:self action:@selector(selectAmount200) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:liangbai];

        wubai = [[UIButton alloc] initWithFrame:CGRectMake(10, 10+perHeight+15, perWidth, perHeight)];
        [wubai setTitle:@"500" forState:UIControlStateNormal];
        [wubai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [wubai setBackgroundImage:[UIImage imageNamed:@"ChargeUnselect"] forState: UIControlStateNormal];
        [wubai setBackgroundImage:[UIImage imageNamed:@"ChargeSelected"] forState: UIControlStateSelected];
        wubai.titleLabel.font = [UIFont systemFontOfSize:13];
        wubai.layer.cornerRadius = 4;
        [wubai addTarget:self action:@selector(selectAmount500) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:wubai];

        yiqian = [[UIButton alloc] initWithFrame:CGRectMake(10*2+perWidth, 10+perHeight+15, perWidth, perHeight)];
        [yiqian setTitle:@"1000" forState:UIControlStateNormal];
        [yiqian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [yiqian setBackgroundImage:[UIImage imageNamed:@"ChargeUnselect"] forState: UIControlStateNormal];
        [yiqian setBackgroundImage:[UIImage imageNamed:@"ChargeSelected"] forState: UIControlStateSelected];
        yiqian.titleLabel.font = [UIFont systemFontOfSize:13];
        yiqian.layer.cornerRadius = 4;
        [yiqian addTarget:self action:@selector(selectAmount1000) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:yiqian];

        inputMoney = [[UITextField alloc]initWithFrame:CGRectMake(10*3+perWidth*2, 10+perHeight+15, perWidth, perHeight)];
        inputMoney.placeholder = @"输入金额";
        inputMoney.borderStyle = UITextBorderStyleNone;
        inputMoney.returnKeyType = UIReturnKeyDone;
        inputMoney.delegate = self;
        inputMoney.keyboardType = UIKeyboardTypeNumberPad;
        inputMoney.textAlignment = NSTextAlignmentCenter;
        inputMoney.clearsOnBeginEditing = YES;
        inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
        [inputMoney addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
        [self.contentView addSubview:inputMoney];
        
        returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:viewController];
        
    }
    return self;
}

- (void)selectAmount50
{
    if(delegate)
    {
        [delegate getChargeMoneyAmount:0];
    }
    NSLog(@"select 50 rmb");
    wushi.selected = YES;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
    
}

- (void)selectAmount100
{
    if(delegate)
    {
        [delegate getChargeMoneyAmount:1];
    }
    NSLog(@"select 100 rmb");
    wushi.selected = NO;
    yibai.selected = YES;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
    
}

- (void)selectAmount200
{
    NSLog(@"select 200 rmb");
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = YES;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
    if(delegate)
    {
        [delegate getChargeMoneyAmount:2];
    }
}

- (void)selectAmount500
{
    NSLog(@"select 500 rmb");
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = YES;
    yiqian.selected = NO;
    inputMoney.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
    if(delegate)
    {
        [delegate getChargeMoneyAmount:3];
    }
    
}

- (void)selectAmount1000
{
    NSLog(@"select 1000 rmb");
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = YES;
    inputMoney.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeUnselect"];
    if(delegate)
    {
        [delegate getChargeMoneyAmount:4];
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.selected = YES;
    inputMoney.background = [UIImage imageNamed:@"ChargeSelected"];
    return YES;
}

-(void)doneAction:(UIBarButtonItem*)barButton
{
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeSelected"];
    if (delegate)
    {
        [delegate textfieldChangeMoney:[inputMoney.text intValue]];
    }
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    wushi.selected = NO;
    yibai.selected = NO;
    liangbai.selected = NO;
    wubai.selected = NO;
    yiqian.selected = NO;
    inputMoney.background = [UIImage imageNamed:@"ChargeSelected"];
    if (delegate)
    {
        [delegate textfieldChangeMoney:[inputMoney.text intValue]];
    }
    [textField resignFirstResponder];
    return YES;
    
}
@end
