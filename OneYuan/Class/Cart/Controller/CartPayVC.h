//
//  CartPayVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/10.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseVC.h"
#import "CartModel.h"
#import "CustomInfo.h"

@interface CartPayVC : OneBaseVC
@property (strong, nonatomic) CustomInfo* customInfo;


- (void)setCartPay:(CartItem*)item;
- (id)initWithTotalMoney:(NSString*)totalMoney;
@end
