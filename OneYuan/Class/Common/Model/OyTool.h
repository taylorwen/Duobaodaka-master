//
//  OyTool.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OyTool : NSObject
@property(nonatomic,readonly)BOOL          bIsForReview;
@property(nonatomic,readonly)NSString      *libDownUrl;
@property(nonatomic,readonly)NSString      *libVersion;
+ (instancetype)ShardInstance;
- (void)getUmengParam;
@end
