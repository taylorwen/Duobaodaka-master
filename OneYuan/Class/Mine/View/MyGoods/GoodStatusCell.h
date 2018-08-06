//
//  GoodStatusCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderTransModel.h"

@protocol GoodStatusCellDelegate <NSObject>
- (void)btnStatusTranAction;
@end

@interface GoodStatusCell : UITableViewCell
@property (nonatomic,weak)id <GoodStatusCellDelegate> delegate;
- (void)setStatus:(NSArray*)listArr Model:(MineMyOrderTrans*)item;
@end
