//
//  HomePopOverVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePopoverViewDelegate;

@interface HomePopOverVC : UIViewController
@property (assign, nonatomic) id <HomePopoverViewDelegate>delegate;
@end

@protocol HomePopoverViewDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(HomePopOverVC*)homePopOverVC;
- (void)goNextButtonClicked:(NSString*)goodsID code:(NSString*)codeId VC:(HomePopOverVC*)homeOverVC;
@end