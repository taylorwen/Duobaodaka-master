//
//  CartEmptyView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartEmptyViewDelegate
- (void)doLogin;
@end

@interface CartEmptyView : UIView
@property (nonatomic,weak)id<CartEmptyViewDelegate> delegate;
- (void)setEmpty;
@end



