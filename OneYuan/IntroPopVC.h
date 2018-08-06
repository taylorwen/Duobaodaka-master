//
//  HomePopOverVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroPopoverViewDelegate;

@interface IntroPopVC : UIViewController
@property (assign, nonatomic) id <IntroPopoverViewDelegate>delegate;
@end

@protocol IntroPopoverViewDelegate<NSObject>
@optional
- (void)cancelIntroButtonClicked:(IntroPopVC*)IntroPopVC;
@end