//
//  HomeLimitedCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeLimitedCell.h"
#import "HomeModel.h"

@interface HomeLimitedCell ()
{
    NSTimer     *timer;
    UILabel     *lblTime;
    UILabel     *lblTime1;
    UILabel     *lblTime2;
    UIImageView *imgTimeBG;
    UIImageView *imgTimeBG1;
    UIImageView *imgTimeBG2;
    UILabel     *point;
    UILabel     *point1;
    
    NSInteger    nowSeconds;
    UIImageView* limitedImg;
}
@end

@implementation HomeLimitedCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderColor = myLineColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        
        limitedImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.frame.size.height)];
//        [self addSubview:limitedImg];
        
        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, mainWidth*0.17-20, mainWidth*0.17-20)];
        image.image = [UIImage imageNamed:@"alertImage"];
        [self addSubview:image];
        
        UILabel* lblAlert = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth*0.17, 0, mainWidth-10-mainWidth*0.17, self.frame.size.height)];
        lblAlert.textColor = [UIColor redColor];
        lblAlert.textAlignment = NSTextAlignmentLeft;
        lblAlert.font = [UIFont systemFontOfSize:12];
        lblAlert.lineBreakMode = NSLineBreakByWordWrapping;
        lblAlert.numberOfLines = 2;
        lblAlert.text = @"苹果公司不会以任何形式参与到夺宝大咖中，本产品所有活动及商品均与苹果公司无关。";
        [self addSubview:lblAlert];
    }
    return self;
}

- (void)setLimited:(HomeLimitedProModel*)item
{
    if (!item) {
        return;
    }
    [limitedImg setImage_oy:nil image:item.image];
    
    NSString* str = [oyImageBaseUrl stringByAppendingString:item.image];
    NSLog(@"%@",str);
    
}
@end
