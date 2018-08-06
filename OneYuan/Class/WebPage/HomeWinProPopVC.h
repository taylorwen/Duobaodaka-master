//
//  HomeWinProPopVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/27.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol HomeWinPopoverViewDelegate;

@interface HomeWinProPopVC : UIViewController
@property (nonatomic,assign) id <HomeWinPopoverViewDelegate>delegate;
- (id)initWithWinProInfo:(WinProModel*)item;
@end

@protocol HomeWinPopoverViewDelegate <NSObject>
@optional
- (void)cancelWinButtonClicked:(HomeWinProPopVC*)homePopOverVC;
- (void)goNextWinButtonClicked:(HomeWinProPopVC*)homeOverVC;
@end
