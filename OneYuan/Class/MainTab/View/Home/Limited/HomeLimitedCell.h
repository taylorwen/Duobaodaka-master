//
//  HomeLimitedCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol LimitedProRefreshDelegate <NSObject>

-(void)limitedProTriggerRefresh;

@end

@interface HomeLimitedCell : UICollectionViewCell
@property(nonatomic,weak)id <LimitedProRefreshDelegate> delegate;
- (void)setLimited:(HomeLimitedProModel*)item;
@end
