//
//  ShopCartEmptyView.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCartEmptyViewDelegate
- (void)doGoshoping;
@end

@interface ShopCartEmptyView : UIView
@property (nonatomic,weak)id<ShopCartEmptyViewDelegate> delegate;
- (void)setShopEmpty;
@end
