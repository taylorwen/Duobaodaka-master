//
//  ShowOrderEditVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseVC.h"
#import "MineShowOrderModel.h"

typedef void(^submitSuccessBlock)(void);

@interface ShowOrderEditVC : OneBaseVC

@property(nonatomic, copy)submitSuccessBlock myBlock;

- (instancetype)initWithOrder:(MineUnshowOrderItem *)order;

@end
