//
//  AllProView.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllProViewDelegate <NSObject>
- (void)doClickProduct:(NSString*)goodsId code:(NSString*)codeId;
@end

@interface AllProView : UIView
@property(nonatomic,assign)int proType;
@property(nonatomic,weak)id<AllProViewDelegate> delegate;
- (id)initWithOrder:(CGRect)frame indexOrder:(int)indexOrder;
- (void)setTypeAndOrder:(int)type sort:(int)sort;
- (void)getDatas:(void (^)(void))block;
@end
