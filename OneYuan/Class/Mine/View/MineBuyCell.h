//
//  MineBuyCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyBuyModel.h"

@protocol MineBuyViewDelegate <NSObject>
- (void)seeCodeDetailAction:(NSString*)mycodes;
@end

@interface MineBuyCell : UITableViewCell
@property(nonatomic,weak)id<MineBuyViewDelegate> delegate;
- (void)setBuyed:(MineBuyedItem*)item recode:(MineMyBuyItem*)recode;
@end
