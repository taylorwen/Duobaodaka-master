//
//  MineOrderCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderModel.h"

@protocol MineMyOrderCellDelegate <NSObject>
- (void)confirmOrder:(MineMyOrderItem*)item;
- (void)confirmShip:(MineMyOrderItem*)item;
- (void)checkShowOrder:(MineMyOrderItem*)item;

@end

@interface MineOrderCell : UITableViewCell
@property(nonatomic,weak)id<MineMyOrderCellDelegate> delegate;
- (void)setMyOrder:(MineMyOrderItem*)item;
@end
