//
//  SuccessfulProCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/15.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"
#import "ChargeModel.h"

@protocol successfulProCellDelegate <NSObject>
- (void)myCodesClicked:(NSString*)codes;

@end

@interface SuccessfulProCell : UITableViewCell
@property(nonatomic,weak)id<successfulProCellDelegate> delegate;
- (void)setSuccess:(CartItem*)item Codes:(BuyRequestModel*)codeItem;
@end
