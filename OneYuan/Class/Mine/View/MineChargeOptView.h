//
//  MineChargeOptView.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChargeOptViewDelegate <NSObject>
- (void)chargeCallThirdPartyPayAction;
@end

@interface MineChargeOptView : UIView
@property(nonatomic,weak)id<ChargeOptViewDelegate> delegate;
@end