//
//  SettingExitCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingExitCell.h"
#import "UserInstance.h"

@interface SettingExitCell ()
{
    __weak id<SettingExitCellDelegate> delegate;
}
@end

@implementation SettingExitCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* btnExit = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, mainWidth - 40, 40)];
        [btnExit setBackgroundColor:mainColor];
        [btnExit setTitle:@"退出登录" forState:UIControlStateNormal];
        btnExit.layer.cornerRadius = 6;
        [btnExit addTarget:self action:@selector(btnExitAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnExit];
    }
    return self;
}

- (void)btnExitAction
{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"是否确认退出当前用户？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
        
        NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:nil forKey:@"uid"];
        [userdefaults setObject:nil forKey:@"auth_key"];
        [userdefaults synchronize];
        
        [[UserInstance ShardInstnce] logout];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUserLogout object:nil];
        if(delegate)
        {
            [delegate btnExitClick];
        }
        
    }], nil] show];

}

@end
