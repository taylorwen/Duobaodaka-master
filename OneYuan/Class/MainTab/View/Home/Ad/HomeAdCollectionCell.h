//
//  HomeAdCollectionCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol HomeAdCollCellDelegate
- (void)adClick:(HomeAd*)ad;
@end

@interface HomeAdCollectionCell : UICollectionViewCell
@property(nonatomic,weak)id<HomeAdCollCellDelegate> delegate;
- (void)getAds:(NSMutableArray*)arrNames model:(NSArray*)ads;
@end
