//
//  OneBaseVC.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneBaseVC : XBBaseVC

- (void)addCartAnimation:(UIImageView*)sourceView;

#pragma mark - Empty
- (void)showEmpty;
- (void)showEmpty:(CGRect)frame;
- (void)hideEmpty;

#pragma mark - load
- (void)showLoad;
- (void)hideLoad;
@end
