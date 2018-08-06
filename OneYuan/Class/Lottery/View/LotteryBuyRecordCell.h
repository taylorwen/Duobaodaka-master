//
//  LotteryBuyRecordCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdcutBuyModel.h"

@protocol LotteryBuyRecordCellDelegate <NSObject>
- (void)tapLotteryUsername:(NSString*)item;
@end

@interface LotteryBuyRecordCell : UITableViewCell
@property(nonatomic,weak)id<LotteryBuyRecordCellDelegate> delegate;
- (void)setLotteryRecord:(ProdcutBuyItem*)item;
@end
