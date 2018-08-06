//
//  ShowOrderItemCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowOrderModel.h"

@protocol ShowOrderItemDelegate <NSObject>
-(void)doUsernameClicked:(NSUInteger)index;

@end

@interface ShowOrderItemCell : UITableViewCell
@property(nonatomic,weak) id<ShowOrderItemDelegate> delegate;
- (void)setShow:(ShowOrderItem*)item;
@end
