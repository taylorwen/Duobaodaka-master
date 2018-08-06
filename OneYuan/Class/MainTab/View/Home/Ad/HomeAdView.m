//
//  HomeAdView.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/7.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeAdView.h"
#import "JxbAdPageView.h"
#import "HomeModel.h"

@interface HomeAdView ()<JxbAdPageViewDelegate>
{
    __weak id<HomeAdViewDelegate> delegate;
    JxbAdPageView               *adPage;
    __block NSMutableArray      *arrNames;

}
@end
@implementation HomeAdView
@synthesize delegate;

- (void)drawRect:(CGRect)rect {
    adPage = [[JxbAdPageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    adPage.delegate = self;
    [self addSubview:adPage];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)getAds
{
    
    NSDictionary* dict = @{@"mobile":@"18602164376"};
    [HomeModel getAds:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSArray *adArr = [HomeAd arrayOfModelsFromDictionaries:@[dataDict]];
        arrNames = [NSMutableArray array];
        for (HomeAd* ad in adArr) {
            NSString* urlBase = @"http://duobaowu.cn/statics/uploads/";
            NSString* url = [urlBase stringByAppendingString:ad.img];
            [arrNames addObject:url];
            
            if([OyTool ShardInstance].bIsForReview)
            {
                [adPage setAds:@[@"http://www.duobaowu.cn/statics/uploads/photo/member.jpg"]];
            }
            else
                [adPage setAds:arrNames];
        }
    } failure:^(NSError* error){
        
    }];
    
}

- (void)click:(int)index
{
    if(delegate)
    {
        if([OyTool ShardInstance].bIsForReview)
        {
            return;
        }
        HomeAd* ad = [arrNames objectAtIndex:index];
        [delegate adClick:ad.pid myLink:ad.link];  //点击打开的是一个html网页，不是原生页面,需要从网页字符串中提取出数字，作为商品的id，没有数字的，则没有点击事件；
    }
}

@end
