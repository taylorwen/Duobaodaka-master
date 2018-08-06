//
//  HomeAdView.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/7.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAdViewDelegate
- (void)adClick:(NSString*)pid myLink:(NSString*)link;
@end

@interface HomeAdView : UIView
@property(nonatomic,weak)id<HomeAdViewDelegate> delegate;
- (void)getAds;
@end
