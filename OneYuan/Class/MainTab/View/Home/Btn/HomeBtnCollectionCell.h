//
//  HomeBtnCollectionCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeBtnCellDelegate
- (void)btnHomeClick:(int)index;
@end

@interface HomeBtnCollectionCell : UICollectionViewCell
@property(nonatomic,weak)id<HomeBtnCellDelegate> delegate;
@end
