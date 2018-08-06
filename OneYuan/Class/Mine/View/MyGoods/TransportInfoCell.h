//
//  TransportInfoCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderTransModel.h"

@protocol TransportInfoCellDelegate <NSObject>
- (void)btnCheckTranAction:(MineMyOrderTrans*)item;
@end

@interface TransportInfoCell : UITableViewCell
@property (nonatomic,weak)id <TransportInfoCellDelegate> delegate;
- (void)setTrans:(MineMyOrderTrans*)item;
@end
