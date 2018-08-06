//
//  PersonBuyingRecordCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyBuyModel.h"

@protocol PersonBuyingViewDelegate <NSObject>
- (void)addPersonGotoCartAction:(MineMyBuyItem*)_item;
@end

@interface PersonBuyingRecordCell : UITableViewCell
@property(nonatomic,weak)id<PersonBuyingViewDelegate> delegate;
- (void)setBuying:(MineMyBuyItem*)item;
@end
