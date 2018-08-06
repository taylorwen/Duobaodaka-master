//
//  CartCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartCell.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface CartCell ()<UITextFieldDelegate>
{
    __weak id<CartCellDelegate> delegate;
    NSMutableDictionary *rightData;
    CartItem    *myItem;
    
    UIImageView *imgrmb;
    UIImageView *imgPro;
    UILabel     *lblTitle;
    UILabel     *lblNotice;
    __block UILabel     *lblLeft;
    
    UIButton    *btnDown;
    UIButton    *btnAdd;
    UITextField *txtNum;
    
    int         maxNum;
    __block CartProduct     *proItem;
}
@end

@implementation CartCell
@synthesize delegate,rightData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgrmb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        imgrmb.image = [UIImage imageNamed:@"tenrmb"];
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 4;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, mainWidth - 110, 15)];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = wordColor;
        lblTitle.numberOfLines = 1;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblNotice = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, mainWidth-110, 15)];
        lblNotice.font = [UIFont systemFontOfSize:12];
        lblNotice.textColor = [UIColor redColor];
        lblNotice.text = @"注: 10元专区奖品，1人次需10夺宝币";
        
        lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, mainWidth - 100, 15)];
        lblLeft.font = [UIFont systemFontOfSize:12];
        lblLeft.textColor = [UIColor lightGrayColor];
        lblLeft.text = @"正在统计...";
        [self addSubview:lblLeft];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, mainWidth - 100, 15)];
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = @"夺宝人次";
        [self addSubview:lbl];
        
        btnDown = [[UIButton alloc] initWithFrame:CGRectMake(180, 60, 30, 30)];
        [btnDown setImage:[UIImage imageNamed:@"btndown_normal"] forState:UIControlStateNormal];
        [btnDown addTarget:self action:@selector(downnum) forControlEvents:UIControlEventTouchUpInside];
        [btnDown setEnabled:NO];
        [self addSubview:btnDown];
        
        txtNum = [[UITextField alloc] initWithFrame:CGRectMake(220, 60, mainWidth - 280, 30)];
        txtNum.layer.borderWidth = 0.5;
        txtNum.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        txtNum.layer.cornerRadius = 3;
        txtNum.font = [UIFont systemFontOfSize:13];
        txtNum.textAlignment = NSTextAlignmentCenter;
        txtNum.enabled = YES;
        txtNum.returnKeyType = UIReturnKeyDone;
        txtNum.delegate = self;
        txtNum.keyboardType = UIKeyboardTypeNumberPad;
        [txtNum addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
        txtNum.clearsOnBeginEditing = YES;
        [self addSubview:txtNum];
        
        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 50, 60, 30, 30)];
        [btnAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(addnum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAdd];
    }
    return self;
}

- (void)setCart:(CartItem*)item
{
    myItem = item;
    [imgPro setImage_oy:nil image:item.thumb];
    NSString* str = item.title;
    NSString* myStr;
    NSRange range = [str rangeOfString:@"&nbsp;"];
    if (range.length > 0) {
        myStr = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else
    {
        myStr = str;
    }
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",item.qishu,myStr];
    txtNum.text = item.gonumber;
    
    if ([item.yunjiage intValue] == 10)
    {
        [self addSubview:imgrmb];
        [self addSubview:lblNotice];
    }
    else
    {
        [imgrmb removeFromSuperview];
        [lblNotice removeFromSuperview];
    }
    
    maxNum = 0;
    
    __weak typeof (self) wSelf = self;
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"sid":item.sid,@"timestamp":timestamp,@"token":token};
    [CartModel getCartState:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        
        proItem = [[CartProduct alloc]initWithDictionary:dataDict error:&error];
        
        if([proItem.shenyurenshu intValue] > 0)
        {
            
            lblLeft.text = [NSString stringWithFormat:@"剩余%d人次",[proItem.shenyurenshu intValue]];
            
            maxNum = [proItem.shenyurenshu intValue];
            
            [wSelf setDis:[item.gonumber intValue]];
        }
        else
        {
            lblLeft.text = @"剩余0人次";
            [wSelf setDis:0];
        }
        
    } failure:^(NSError* error){
        
    }];
    
}

- (void)setDis:(int)num
{
    if(num <=0)
    {
        [btnDown setEnabled:NO];
        [btnAdd setEnabled:NO];
        txtNum.text = @"0";
        myItem.gonumber = 0;
        txtNum.text = myItem.gonumber;
        [CartModel addorUpdateCart:myItem];
        if (delegate)
        {
            [delegate setOpt];
        }
    }
    else
    {
        if(num > 1)
            btnDown.enabled = YES;
        if(num >= maxNum)
        {
            myItem.gonumber = [NSString stringWithFormat:@"%d", maxNum];
            txtNum.text = myItem.gonumber ;
            [CartModel addorUpdateCart:myItem];
            [btnAdd setEnabled:NO];
        }
        else
        {
            [btnAdd setEnabled:YES];
        }
    }
}

- (void)addnum
{
    if([myItem.gonumber intValue] >= maxNum - 1)
    {
        [btnAdd setEnabled:NO];
    }
    [btnDown setEnabled:YES];
    myItem.gonumber = [NSString stringWithFormat:@"%d",[myItem.gonumber intValue] +1];
    txtNum.text = myItem.gonumber;
    [CartModel addorUpdateCart:myItem];
    
    if (delegate)
    {
        [delegate setOpt];
    }
    
}

- (void)downnum
{
    int num = [myItem.gonumber intValue];
    if(num <= 1)
    {
        [btnDown setEnabled:NO];
        myItem.gonumber = [NSString stringWithFormat:@"%d",1];
    }
    else
    {
        myItem.gonumber = [NSString stringWithFormat:@"%d",num - 1];
    }
    [btnAdd setEnabled:YES];
    txtNum.text = myItem.gonumber;
    [CartModel addorUpdateCart:myItem];
    
    if (delegate)
    {
        [delegate setOpt];
    }
    
}

-(void)doneAction:(UIBarButtonItem*)barButton
{
    if ([txtNum.text isEqualToString:@""])
    {
        [[XBToastManager ShardInstance]showtoast:@"夺宝人次不能为零"];
        return;
    }
    else
    {
        if ([txtNum.text intValue] > [proItem.shenyurenshu intValue])
        {
            NSString* str = [NSString stringWithFormat:@"夺宝次数不得超过%@次",proItem.shenyurenshu];
            [[XBToastManager ShardInstance]showtoast:str];
            txtNum.text = proItem.shenyurenshu;
            myItem.gonumber = txtNum.text;
            [CartModel addorUpdateCart:myItem];
            
            if (delegate)
            {
                [delegate setTxtFieldOpt];
            }
        }
        else
        {
            myItem.gonumber = txtNum.text;
            [CartModel addorUpdateCart:myItem];
            
            if (delegate)
            {
                [delegate setTxtFieldOpt];
            }
        }
        [self endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([txtNum.text intValue] > [proItem.shenyurenshu intValue])
    {
        NSString* str = [NSString stringWithFormat:@"夺宝次数不得超过%@次",proItem.shenyurenshu];
        [[XBToastManager ShardInstance]showtoast:str];
        txtNum.text = proItem.shenyurenshu;
        myItem.gonumber = txtNum.text;
        [CartModel addorUpdateCart:myItem];
        
        if (delegate)
        {
            [delegate setTxtFieldOpt];
        }
    }
    else
    {
        myItem.gonumber = txtNum.text;
        [CartModel addorUpdateCart:myItem];
        
        if (delegate)
        {
            [delegate setTxtFieldOpt];
        }
    }
    [textField resignFirstResponder];
    return YES;
    
}
@end