//
//  HomePopOverVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomePopOverVC.h"
#import "HomeModel.h"

@interface HomePopOverVC ()
{
    NSMutableArray      *arrGuidePro;
    UIImageView* background;
    NSString        *goodsId;
    NSString        *codeId;
}
@end

@implementation HomePopOverVC
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

    background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:background];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth*0.8, mainHeight*0.24, 30, 30)];
    [close setImage:[UIImage imageNamed:@"btn1Home"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UIButton* next = [[UIButton alloc]initWithFrame:CGRectMake(0, mainHeight*0.54, mainWidth, 80)];
    next.backgroundColor = [UIColor clearColor];
    [next addTarget:self action:@selector(goToNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    
    [self loadGuidePro];
}

- (void)loadGuidePro
{
    [[XBToastManager ShardInstance]showprogress];
    [HomeModel getHomeGuide:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        HomeGuideProModel* guideItem = [[HomeGuideProModel alloc]initWithDictionary:datadict error:&error];
        NSURL* url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:guideItem.image_url_hdpi]];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        double rate = image.size.height/image.size.width;
        background.frame = CGRectMake(0, (self.view.frame.size.height-mainWidth*rate)/2, mainWidth, mainWidth*rate);
        [background setImage_oy:oyImageBaseUrl image:guideItem.image_url_hdpi];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];

}

- (void)closePopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

- (void)goToNext
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goNextButtonClicked: code: VC:)]) {
        [self.delegate goNextButtonClicked:goodsId code:codeId VC:self];
    }
}

@end
