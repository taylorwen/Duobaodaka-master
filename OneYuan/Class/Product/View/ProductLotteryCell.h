//
//  ProductLotteryCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol goLotteryDetail
- (void)lotteryDetailClicked;
@end

@interface ProductLotteryCell : UITableViewCell
@property(nonatomic,weak)id<goLotteryDetail> delegate;
- (void)setMyLottery:(ProductInfo*)lottery myChild:(ProductInfoChild*)infoChild;
@end
