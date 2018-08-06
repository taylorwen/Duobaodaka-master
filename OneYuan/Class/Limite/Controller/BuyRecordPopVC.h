//
//  BuyRecordPopVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Limite3Model.h"

@protocol BuyRecordPopoverViewDelegate;

@interface BuyRecordPopVC : UIViewController
- (id)initWithUserID:(HuaFeiModel*)item;
@property (assign, nonatomic) id <BuyRecordPopoverViewDelegate>delegate;
@end

@protocol BuyRecordPopoverViewDelegate<NSObject>
@optional
- (void)cancelLimiteButtonClicked:(BuyRecordPopVC*)homePopOverVC;
- (void)goNextLimiteButtonClicked:(NSString*)goodsID code:(NSString*)codeId VC:(BuyRecordPopVC*)homeOverVC;
@end