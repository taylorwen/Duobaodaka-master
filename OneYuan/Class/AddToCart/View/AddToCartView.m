//
//  AddToCartView.m
//  MasterDuoBao
//
//  Created by 黄锋 on 15/9/25.
//  Copyright © 2015年 wenzhan. All rights reserved.
//

#import "AddToCartView.h"

#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"

#import "EGOImageView.h"

#import "UIImageView+NoMapMode.h"

#import "CartModel.h"

#import "CartInstance.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Font [UIFont systemFontOfSize:10]

@interface AddToCartView () <UITextFieldDelegate>

@property(nonatomic, strong) EGOImageView *pic;
@property(nonatomic, strong) UILabel *qishu;
@property(nonatomic, strong) UILabel *goodsName;
@property(nonatomic, strong) UILabel *total;
@property(nonatomic, strong) UILabel *last;

@property(nonatomic, strong)UILabel *lable;

@property(nonatomic, strong) UIButton *subButton;
@property(nonatomic, strong) UIButton *addButton;

@end

@implementation AddToCartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Width, 174)];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        
        _pic = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        _pic.layer.masksToBounds = YES;
        _pic.layer.cornerRadius = 3;
        [self addSubview:_pic];
        
        _qishu = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 50, 10)];
        //_qishu.text = @"(第123期)";
        _qishu.font = Font;
        [mainView addSubview:_qishu];
        
        _goodsName = [[UILabel alloc] initWithFrame:CGRectMake(180, 30, Width - 190, 10)];
        // _goodsName.text = @"iPhone6 Plus 64GB 颜色随机";
        _goodsName.font = Font;
        [mainView addSubview:_goodsName];
        
        _total = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 150, 10)];
        //_total.text = @"总需 6886 人次";
        _total.font = Font;
        [mainView addSubview:_total];
        
        _last = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 150, 10)];
        //_last.text = @"剩余 1234 人次";
        _last.font = Font;
        [mainView addSubview:_last];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = CGRectMake(Width - 25, 5, 20, 20);
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        //[_closeButton setTitle:@"关" forState:UIControlStateNormal];
        [mainView addSubview:_closeButton];
        
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(10, 90, Width - 20, 0.5)];
        line0.backgroundColor = [UIColor lightGrayColor];
        line0.alpha = .5;
        [mainView addSubview:line0];
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 100, 12)];
        lable.text = @"参与人次：";
        lable.font = [UIFont systemFontOfSize:12];
        [mainView addSubview:lable];
        
        UIView *yuanjiaoview = [[UIView alloc] initWithFrame:CGRectMake(Width - 110, 95, 100, 32)];
        yuanjiaoview.layer.masksToBounds = YES;
        yuanjiaoview.layer.cornerRadius = 16;
        yuanjiaoview.layer.borderWidth = 1;
        yuanjiaoview.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        [mainView addSubview:yuanjiaoview];
        
        _subButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _subButton.frame = CGRectMake(0, 0, 30, 32);
        [_subButton setTitle:@"-" forState:UIControlStateNormal];
        [_subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [yuanjiaoview addSubview:_subButton];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, 40, 32)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentCenter;
        [_textField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        _textField.font = [UIFont systemFontOfSize:13];
        //_textField.text = @"10";
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.enabled = YES;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
        _textField.clearsOnBeginEditing = YES;
        [yuanjiaoview addSubview:_textField];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.frame = CGRectMake(70, 0, 30, 32);
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [yuanjiaoview addSubview:_addButton];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 132, Width - 20, .5)];
        line1.backgroundColor = [UIColor lightGrayColor];
        line0.alpha = .5;
        [mainView addSubview:line1];
        
        UILabel *winlable = [[UILabel alloc] initWithFrame:CGRectMake(10, 147, 100, 12)];
        winlable.text = @"获奖几率：";
        winlable.font = [UIFont systemFontOfSize:12];
        [mainView addSubview:winlable];
        
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(Width - 100, 140, 50, 32)];
        _lable.font = [UIFont systemFontOfSize:12];
        _lable.textAlignment = NSTextAlignmentRight;
        _lable.textColor = [UIColor hexFloatColor:@"eda200"];
        _lable.textAlignment = NSTextAlignmentRight;
        //_lable.text = @"90";
        [mainView addSubview:_lable];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(Width - 50, 155, 10, 10)];
        lable1.text = @"%";
        lable1.font = Font;
        lable1.textColor = [UIColor hexFloatColor:@"eda200"];
        [mainView addSubview:lable1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 194, Width, 40);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.backgroundColor = [UIColor hexFloatColor:@"eda200"];
        [button addTarget:self action:@selector(determineAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)subButtonAction:(UIButton *)button
{
    _textField.text = [NSString stringWithFormat:@"%d", [_textField.text intValue] > 1 ? [_textField.text intValue] - 1 : 1 ];
    _lable.text = [NSString stringWithFormat:@"%.2f",100.0 * [_textField.text intValue] / [_productInfo.zongrenshu intValue]];
    _subButton.enabled = [_textField.text intValue] > 1;
    _addButton.enabled = [_textField.text intValue] < [_productInfo.shenyurenshu intValue];
}

- (void)addButtonAction:(UIButton *)button
{
    _textField.text = [NSString stringWithFormat:@"%d", [_textField.text intValue] < [_productInfo.shenyurenshu intValue] ? [_textField.text intValue] + 1 : [_textField.text intValue]];
    _lable.text = [NSString stringWithFormat:@"%.2f",100.0 * [_textField.text intValue] / [_productInfo.zongrenshu intValue]];
    _subButton.enabled = [_textField.text intValue] > 1;
    _addButton.enabled = [_textField.text intValue] < [_productInfo.shenyurenshu intValue];
}

- (void)doneAction:(UIBarButtonItem*)barButton
{
    [self textFieldShouldReturn:_textField];
}

- (void)setProductInfo:(ProductInfo *)productInfo
{
    _productInfo = productInfo;
    //配置
    [_pic setImage_oy:oyImageBaseUrl image:productInfo.thumb];
    _qishu.text = [NSString stringWithFormat:@"(第%@期)",productInfo.qishu];
    CGRect rect = _goodsName.frame;
    rect.origin.x = CGRectGetMaxX([_qishu.text boundingRectWithSize:CGSizeMake(50, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font} context:nil]) + 120;
    _goodsName.frame = rect;
    NSString *str = [productInfo.title stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    _goodsName.text = str;
    _total.text = [NSString stringWithFormat:@"总需 %@ 人次",productInfo.zongrenshu];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余 %@ 人次", productInfo.shenyurenshu]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, productInfo.shenyurenshu.length)];
    _last.attributedText = attributedString;
    _textField.text = [NSString stringWithFormat:@"%d", 10 < [productInfo.shenyurenshu intValue] ? 10 : [productInfo.shenyurenshu intValue]];
    _subButton.enabled = [_textField.text intValue] > 1;
    _addButton.enabled = [_textField.text intValue] < [_productInfo.shenyurenshu intValue];
    _lable.text = [NSString stringWithFormat:@"%.2f",100.0 * [_textField.text intValue] / [_productInfo.zongrenshu intValue]];
}

- (void)determineAction
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",_productInfo.pid];
    item.title = _productInfo.title;
    item.qishu = _productInfo.qishu;
    item.yunjiage = _productInfo.yunjiage;
    item.gonumber = _textField.text;
    item.sid = _productInfo.sid;
    item.money = _productInfo.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_productInfo.thumb];
    [[CartInstance ShartInstance] addToCart:item imgPro:nil type:addCartType_Opt];
    if (_closeBlock) {
        _closeBlock();
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *str = textField.text ;
    if ([str intValue] > 0 && [str intValue] <= [_productInfo.shenyurenshu intValue] && [str rangeOfString:@"."].location == NSNotFound) {
        _lable.text = [NSString stringWithFormat:@"%.2f",100.0 * [str intValue] / [_productInfo.zongrenshu intValue]];
        _subButton.enabled = [_textField.text intValue] > 1;
        _addButton.enabled = [_textField.text intValue] < [_productInfo.shenyurenshu intValue];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_textField.text isEqualToString:@""] || [_textField.text intValue] == 0)
    {
        [[XBToastManager ShardInstance]showtoast:@"夺宝人次不能为零"];
        return NO;
    }
    if ([_textField.text intValue] < 0){
        [[XBToastManager ShardInstance]showtoast:@"夺宝人次不能为负"];
        _textField.text = @"";
        return NO;
    }
    if ([_textField.text intValue] > [_productInfo.shenyurenshu intValue])
    {
        NSString* str = [NSString stringWithFormat:@"夺宝次数不得超过%@次",_productInfo.shenyurenshu];
        [[XBToastManager ShardInstance]showtoast:str];
        _textField.text = @"";
        return NO;
    }
    [self endEditing:YES];
    _textField.text = [NSString stringWithFormat:@"%d", [_textField.text intValue]];
    _subButton.enabled = [_textField.text intValue] > 1;
    _addButton.enabled = [_textField.text intValue] < [_productInfo.shenyurenshu intValue];
    return YES;
}

@end
