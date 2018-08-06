//
//  HomePopOverVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "IntroPopVC.h"
#import "HomeModel.h"
#import "ZWIntroductionViewController.h"
#import "sys/utsname.h"         //判断手机型号

@interface IntroPopVC ()
{
    NSMutableArray      *arrGuidePro;
    UIImageView* background;
    NSString        *goodsId;
    NSString        *codeId;
    NSString* deviceString;
}
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@end

@implementation IntroPopVC
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self deviceString];
    
    UIScrollView* scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height)];
    scorllView.contentSize = CGSizeMake(mainWidth*3, mainWidth);
    scorllView.backgroundColor = [UIColor whiteColor];
    scorllView.pagingEnabled = YES;
    
    scorllView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:scorllView];
    
    UIImageView* image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [scorllView addSubview:image1];
    
    UIImageView* image2 = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [scorllView addSubview:image2];
    
    UIImageView* image3 = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth*2, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [scorllView addSubview:image3];
    
    if ([deviceString isEqualToString:@"iPhone4,1"])
    {
        image1.image = [UIImage imageNamed:@"img_index_01txt"];
        image2.image = [UIImage imageNamed:@"img_index_02txt"];
        image3.image = [UIImage imageNamed:@"img_index_03txt"];
    }
    else
    {
        image1.image = [UIImage imageNamed:@"img_index_01bg"];
        image2.image = [UIImage imageNamed:@"img_index_02bg"];
        image3.image = [UIImage imageNamed:@"img_index_03bg"];
    }
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth*2+(mainWidth-150)/2, (self.view.frame.size.height-80), 150, 40)];
    [close setTitle:@"立即夺宝" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    close.layer.cornerRadius = 5;
    close.layer.borderColor = [UIColor whiteColor].CGColor;
    close.layer.borderWidth = 0.5;
    [close addTarget:self action:@selector(closeIntroPopup) forControlEvents:UIControlEventTouchUpInside];
    [scorllView addSubview:close];
    
}

- (void)closeIntroPopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelIntroButtonClicked:)]) {
        [self.delegate cancelIntroButtonClicked:self];
    }
}

//获取设备型号
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

@end
