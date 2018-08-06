//
//  HomeInstance.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

@interface HomeInstance : NSObject

@property(nonatomic,strong) HomeAd              *listAd1;
@property(nonatomic,strong) NSArray             *listNewing;
@property(nonatomic,strong) NSArray             *hotlist;



+(HomeInstance*)ShardInstnce;
@end
