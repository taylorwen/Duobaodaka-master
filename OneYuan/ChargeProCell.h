//
//  PayproCell.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/20.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

@protocol ChargeProCellDelegate
-(void)getChargeMoneyAmount:(int)index;
-(void)textfieldChangeMoney:(int)index;
@end

@interface ChargeProCell : UITableViewCell

@property(nonatomic,weak)id<ChargeProCellDelegate> delegate;

@property(nonatomic,strong)UIButton* wushi;
@property(nonatomic,strong)UIButton* yibai;
@property(nonatomic,strong)UIButton* liangbai;
@property(nonatomic,strong)UIButton* wubai;
@property(nonatomic,strong)UIButton* yiqian;
@property(nonatomic)       int        money;
@end

