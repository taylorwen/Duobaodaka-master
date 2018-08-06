//
//  AllProItemCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"

typedef enum
{
    ProCellType_All,
    ProCellType_Search
}ProCellType;

@interface AllProItemCell : UITableViewCell

- (void)setProItem:(AllProItme*)item type:(ProCellType)type;
@end
