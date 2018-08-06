//
//  PersonOrderCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/9/1.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderModel.h"

@protocol PersonOrderCellDelegate <NSObject>
@end

@interface PersonOrderCell : UITableViewCell
@property(nonatomic,weak)id<PersonOrderCellDelegate> delegate;
- (void)setPersonOrder:(MineMyOrderItem*)item;
@end
