//
//  NewestingCollCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/3.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestModel.h"

@protocol NewestProRefreshDelegate <NSObject>
-(void)NewestingTriggerRefresh;

@end

@interface NewestingCollCell : UICollectionViewCell
@property(nonatomic,weak)id<NewestProRefreshDelegate> delegate;

- (void)setNewesting:(NewestProItme*)newing;
@end
