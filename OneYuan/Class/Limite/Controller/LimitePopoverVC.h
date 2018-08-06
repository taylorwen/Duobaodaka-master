//
//  LimitePopoverVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/21.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Limite3Model.h"

@protocol LimitePopoverViewDelegate;

@interface LimitePopoverVC : UIViewController
- (id)initWithUserID:(HuaFeiModel*)item;
@property (assign, nonatomic) id <LimitePopoverViewDelegate>delegate;
@end

@protocol LimitePopoverViewDelegate<NSObject>
@optional
- (void)cancelLimiteButtonClicked:(LimitePopoverVC*)homePopOverVC;
- (void)goNextLimiteButtonClicked:(NSString*)goodsID code:(NSString*)codeId VC:(LimitePopoverVC*)homeOverVC;
@end