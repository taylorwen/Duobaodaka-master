//
//  MineBuyingCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyBuyModel.h"

@protocol MineBuyingViewDelegate <NSObject>
- (void)addGotoCartAction:(MineMyBuyItem*)_item;
@end

@interface MineBuyingCell : UITableViewCell
@property(nonatomic,weak)id<MineBuyingViewDelegate> delegate;
- (void)setBuying:(MineMyBuyItem*)item;
@end
