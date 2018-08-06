//
//  CartShowMoreCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

@protocol PaymentShowViewDelegate <NSObject>
- (void)addMoreItems;
- (void)showThreeItems;
@end

@interface CartShowMoreCell : UIView
@property(nonatomic,weak)id<PaymentShowViewDelegate> delegate;
- (void)setPaymentValue:(NSString*)totalMoney;
@end
