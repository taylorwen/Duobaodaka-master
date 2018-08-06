//
//  CartCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

@protocol CartCellDelegate
- (void)setOpt;
- (void)setTxtFieldOpt;
@end

@interface CartCell : UITableViewCell

@property(nonatomic,weak)id<CartCellDelegate> delegate;
@property (nonatomic ,strong) NSMutableDictionary *rightData;
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex ,NSInteger money ,NSString *key);

- (void)setCart:(CartItem*)item;
@end