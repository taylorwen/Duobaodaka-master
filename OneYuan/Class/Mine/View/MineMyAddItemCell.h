//
//  MineMyAddItemCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyAddressModel.h"

@protocol MineMyAddItemCellDelegate <NSObject>
- (void)setDefault:(int)addressId;
@end


@interface MineMyAddItemCell : UITableViewCell
@property(nonatomic,weak)id<MineMyAddItemCellDelegate> delegate;
- (void)setAddress:(MineMyAddressItem*)item bShow:(BOOL)bShow;
@end
