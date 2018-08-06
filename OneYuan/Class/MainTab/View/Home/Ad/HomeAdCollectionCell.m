//
//  HomeAdCollectionCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeAdCollectionCell.h"
#import "JxbAdPageView.h"
#import "HomeModel.h"
#import "LoopImageScrollView.h"

@interface HomeAdCollectionCell ()<LoopImageScrollViewDelegate>
{
    __weak id<HomeAdCollCellDelegate> delegate;
    __block  NSArray            *adArr;
    __block  HomeAd             *myAds;
    __block  LoopImageScrollView *mainView;
}
@end
@implementation HomeAdCollectionCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mainView = [[LoopImageScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        mainView.delegate = self;
        [self addSubview:mainView];
        
    }
    return self;
}

- (void)getAds:(NSMutableArray*)arrNames model:(NSArray*)ads
{
    if (ads == nil) {
        return;
    }
    adArr = ads;
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
            NSString* urls;
            for (int i=0; i<ads.count; i++)
            {
                HomeAd* adModel = [ads objectAtIndex:i];
                urls = adModel.img;
                [array addObject:urls];
            }
            mainView.imageURLArray = array;
            
        }
        else
        {
            mainView.imageURLArray = @[@"http://121.41.101.108/statics/uploads/banner/20150728/shishicai.jpg",@"http://121.41.101.108/statics/uploads/banner/20150728/shaidan.jpg"];
        }
}

-(void)loopCurrentIndex:(NSInteger)index
{
    if(delegate)
    {
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"0"])
        {
            return;
        }
        HomeAd *ad = [adArr objectAtIndex:index];
        [delegate adClick:ad];
    }
}
@end
