//
//  AddToCartView.h
//  MasterDuoBao
//
//  Created by 黄锋 on 15/9/25.
//  Copyright © 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef void(^CloseBlock)(void);

@interface AddToCartView : UIView

@property(nonatomic, strong) ProductInfo *productInfo;

@property(nonatomic, strong) UIButton *closeButton;

@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, copy) CloseBlock closeBlock;


@end
