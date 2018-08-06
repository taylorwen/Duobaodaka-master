//
//  SingeAdCollectionViewCell.m
//  MasterDuoBao
//
//  Created by 黄锋 on 15/9/25.
//  Copyright © 2015年 wenzhan. All rights reserved.
//

#import "SingeAdCollectionViewCell.h"

@interface SingeAdCollectionViewCell ()

@property(nonatomic, copy)tapAction myBlock;

@end

@implementation SingeAdCollectionViewCell

- (void)addEGOImageView:(EGOImageView *)egoImg tapAction:(tapAction)tapBlock
{
    _myBlock = tapBlock;
    egoImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
    [egoImg addGestureRecognizer:tapGesture];
    [self addSubview:egoImg];
}

- (void)viewTapAction
{
    if (_myBlock) {
        _myBlock();
    }
}

@end
