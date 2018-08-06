//
//  Product10Cell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "AllProModel.h"

typedef enum
{
    HomeTenCollectionType_All,
    HomeTenCollectionType_Search
}HomeTenCollectionType;

@interface Product10Cell : UICollectionViewCell
- (void)setTenPros:(HomeTenModel*)ten;
@end
