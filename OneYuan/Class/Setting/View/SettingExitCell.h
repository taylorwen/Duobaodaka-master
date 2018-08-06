//
//  SettingExitCell.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingExitCellDelegate <NSObject>
- (void)btnExitClick;
@end

@interface SettingExitCell : UITableViewCell
@property(nonatomic,weak)id<SettingExitCellDelegate> delegate;
@end
