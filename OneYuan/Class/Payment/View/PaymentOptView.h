//
//  CartOptView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentOptViewDelegate <NSObject>
- (void)callThirdPartyPaymentAction;
@end

@interface PaymentOptView : UIView
@property(nonatomic,weak)id<PaymentOptViewDelegate> delegate;
@end
