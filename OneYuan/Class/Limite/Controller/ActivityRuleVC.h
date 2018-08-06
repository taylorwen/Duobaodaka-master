//
//  ActivityRuleVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/24.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActivityRulePopoverViewDelegate;

@interface ActivityRuleVC : UIViewController
@property (assign, nonatomic) id <ActivityRulePopoverViewDelegate>delegate;
@end

@protocol ActivityRulePopoverViewDelegate<NSObject>
@optional
- (void)cancelLimiteButtonClicked:(ActivityRuleVC*)homePopOverVC;
- (void)goNextLimiteButtonClicked:(NSString*)goodsID code:(NSString*)codeId VC:(ActivityRuleVC*)homeOverVC;
@end