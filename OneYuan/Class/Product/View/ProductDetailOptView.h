//
//  ProductDetailOptView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDetailOptViewDelegate <NSObject>
- (void)addToCartAction;
- (void)addGotoCartAction;
- (void)gotoCartAction;
@end

@interface ProductDetailOptView : UIView
@property(nonatomic,weak)id<ProductDetailOptViewDelegate> delegate;

- (void)setCartNum:(int)count;
@end
