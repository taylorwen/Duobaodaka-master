//
//  MineUnshowOrderCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineShowOrderModel.h"

@protocol MineShowOrderDelegate <NSObject>
- (void)goToShowOrderAction:(MineUnshowOrderItem*)myItem;

@end

@interface MineUnshowOrderCell : UITableViewCell
@property(nonatomic,weak)id<MineShowOrderDelegate> delegate;

- (void)setMyOrder:(MineUnshowOrderItem*)item;

@end
