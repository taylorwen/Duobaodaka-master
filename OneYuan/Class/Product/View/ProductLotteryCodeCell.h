//
//  ProductLotteryCodeCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductLotteryCodeCell : UITableViewCell

- (void)setCodes:(ProductCodeBuy*)allCodes lotteryItem:(ProductInfo*)item;
@end
