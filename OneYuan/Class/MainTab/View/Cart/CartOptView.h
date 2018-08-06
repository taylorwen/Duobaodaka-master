//
//  CartOptView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartOptViewDelegate <NSObject>
- (void)cartCalcAction:(NSString*)totalPrice;
@end

@interface CartOptView : UIView 
@property(nonatomic,weak)id<CartOptViewDelegate> delegate;
- (void)setOpt;
//-(void)quantity:(NSInteger)quantity money:(NSInteger)money key:(NSString *)key;
@end
