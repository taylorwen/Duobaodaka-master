//
//  ProductBuyCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdcutBuyModel.h"

@protocol ProductBuyCellDelegate <NSObject>
- (void)tapUsername:(NSString*)userId;
@end

@interface ProductBuyCell : UITableViewCell
@property(nonatomic,weak)id<ProductBuyCellDelegate> delegate;
- (void)setBuy:(ProdcutBuyItem*)item;
@end
