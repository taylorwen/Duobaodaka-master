//
//  ProductLotteryOptView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"
#import "ProductModel.h"

@protocol ProductLotteryOptViewDelegate <NSObject>
-(void)gotoDetailAction;
-(void)gotoCartAction;
@end

@interface ProductLotteryOptView : UIView
@property(nonatomic,weak)id<ProductLotteryOptViewDelegate> delegate;
- (void)setBtnPeriod:(ProductNextPeriod*)period;
@end
