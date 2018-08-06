//
//  MineLoginView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineLoginViewDelegate
- (void)doLogin;
@end

@interface MineLoginView : UIView

@property (nonatomic,weak)id<MineLoginViewDelegate> delegate;

@end
