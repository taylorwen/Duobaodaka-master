//
//  AllProTypeView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllProTypeViewDelegate
- (void)selectedTypeCode:(int)code;
@end

@interface AllProTypeView : UIView
@property(nonatomic,weak)id<AllProTypeViewDelegate> delegate;
@end
