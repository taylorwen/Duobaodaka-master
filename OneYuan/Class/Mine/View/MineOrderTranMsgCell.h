//
//  MineOrderTranMsgCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderTransModel.h"

@interface MineOrderTranMsgCell : UITableViewCell

- (void)setTrans:(MineMyOrderTransInfo*)info index:(int)index last:(BOOL)last;
@end
