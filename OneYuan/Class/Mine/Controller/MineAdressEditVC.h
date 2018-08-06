//
//  MineAdressEditVC.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/1.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyAddressModel.h"

@protocol MineMyAddressEditVCDelegate <NSObject>
-(void)refreshAddress;
@end

@interface MineAdressEditVC : OneBaseVC
- (id)initWithAddress:(MineMyAddressItem*)item;
@property(nonatomic,weak)id<MineMyAddressEditVCDelegate> delegate;

@end
