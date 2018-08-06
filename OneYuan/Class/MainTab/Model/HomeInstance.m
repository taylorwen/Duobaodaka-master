//
//  HomeInstance.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeInstance.h"

@interface HomeInstance()
{
    HomeAd    *listAd1;
    NSArray             *listNewing;
    NSArray             *hotlist;
}
@end


static HomeInstance* home;

@implementation HomeInstance
@synthesize listAd1,listNewing,hotlist;

+(HomeInstance*)ShardInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        home = [[HomeInstance alloc] init];
    });
    return home;
}

@end
