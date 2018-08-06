//
//  SearchCartView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCartViewDelegate <NSObject>
- (void)gotoCart;
@end

@interface SearchCartView : UIView
@property(nonatomic,weak)id<SearchCartViewDelegate> delegate;
-(void)setCartNum:(int)count;
@end
