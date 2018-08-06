//
//  HomeCateCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/2.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeRankingCellDelegate 

- (void)btnHomeRankingClick:(int)index;

@end

@interface HomeCateCell : UICollectionViewCell
@property(nonatomic,weak)id<HomeRankingCellDelegate> delegate;
@end
