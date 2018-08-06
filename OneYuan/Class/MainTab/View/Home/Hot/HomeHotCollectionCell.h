//
//  HomeHotCollectionCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "AllProModel.h"
typedef enum
{
    HomeCollectionType_All,
    HomeCollectionType_Search
}HomeCollectionType;

@interface HomeHotCollectionCell : UICollectionViewCell
- (void)setHots:(HomeHotest*)hot;
@end
