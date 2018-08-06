//
//  HomeWinProPopVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/27.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol TabMinePopoverViewDelegate;

@interface TabMinePopVC : UIViewController
@property (nonatomic,assign) id <TabMinePopoverViewDelegate>delegate;
- (id)initWithWinProInfo:(WinProModel*)item;
@end

@protocol TabMinePopoverViewDelegate <NSObject>
@optional
- (void)cancelTabMineButtonClicked:(TabMinePopVC*)homePopOverVC;
- (void)goNextTabMineButton1Clicked:(TabMinePopVC*)homeOverVC;
- (void)goNextTabMineButton2Clicked:(TabMinePopVC*)homeOverVC;
- (void)goNextTabMineButton3Clicked:(TabMinePopVC*)homeOverVC;
- (void)goNextTabMineButton4Clicked:(TabMinePopVC*)homeOverVC;
- (void)goNextTabMineButton5Clicked:(TabMinePopVC*)homeOverVC;
@end
