//
//  PersonBuyRecordCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyBuyModel.h"

@protocol PersonBuyRecordCellDelegate <NSObject>
- (void)tapTALotteryUsername:(NSString*)item;
@end

@interface PersonBuyRecordCell : UITableViewCell
@property(nonatomic,weak)id<PersonBuyRecordCellDelegate> delegate;
- (void)setBuyed:(MineBuyedItem*)item recode:(MineMyBuyItem*)recode;
@end