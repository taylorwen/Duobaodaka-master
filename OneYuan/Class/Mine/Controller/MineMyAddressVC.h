//
//  MineMyAddressVC.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderModel.h"

typedef enum
{
    MineAddressType_Common,
    MineAddressType_Select
}MineAddressType;

@protocol MineMyAddressVCDelegate <NSObject>
- (void)refreshMyOrder;
@end

@interface MineMyAddressVC : OneBaseVC
@property(nonatomic,weak)id<MineMyAddressVCDelegate> delegate;
- (id)initWithType:(MineAddressType)type OrderId:(MineMyOrderItem*)item;
@end
