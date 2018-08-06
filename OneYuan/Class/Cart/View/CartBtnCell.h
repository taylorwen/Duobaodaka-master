//
//  CartBtnCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/2.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentBtnViewDelegate <NSObject>
- (void)cellCallThirdPartyPaymentAction;
@end

@interface CartBtnCell : UITableViewCell
@property(nonatomic,weak)id<PaymentBtnViewDelegate> delegate;

@end
