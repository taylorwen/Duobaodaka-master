//
//  AllProCollectionCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"

typedef enum
{
    ProCollectionType_All,
    ProCollectionType_Search
}ProCollectionType;

@interface AllProCollectionCell : UICollectionViewCell
- (void)setProItem:(AllProItme*)item type:(ProCollectionType)type;
@end
