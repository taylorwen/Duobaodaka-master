//
//  HeadAdCollectionViewCell.m
//  MasterDuoBao
//
//  Created by 黄锋 on 15/9/23.
//  Copyright © 2015年 wenzhan. All rights reserved.
//

#import "HeadAdCollectionViewCell.h"
//#import "EGOImageView.h"

@interface HeadAdCollectionViewCell ()

@property(nonatomic, strong) UICollectionView *cv;

@end

@implementation HeadAdCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 创建视图，进行相关赋值
        _cycleScrollView = [[KBHomeCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.frame.size.height) animationDuration:3];
        [self addSubview:_cycleScrollView];
    }
    return self;
}

@end
