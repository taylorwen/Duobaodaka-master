//
//  SettingWifiCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingWifiCell.h"

@implementation SettingWifiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch* swWifi = [[UISwitch alloc] initWithFrame:CGRectMake(mainWidth - 60, 5, mainWidth - 50, 34)];
        [swWifi setTintColor:mainColor];
        [swWifi setOnTintColor:mainColor];
        [swWifi addTarget:self action:@selector(btnOpenWifi:) forControlEvents:UIControlEventValueChanged];
        BOOL on = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoMapMode] boolValue];
        [swWifi setOn:on];
        [self addSubview:swWifi];
    }
    return self;
}

- (void)btnOpenWifi:(id)sender
{
    UISwitch* btn = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:btn.on] forKey:kNoMapMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
