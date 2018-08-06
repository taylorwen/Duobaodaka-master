//
//  SettingAboutusVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/11.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingAboutusVC.h"
#import "SettingSecureVC.h"

@interface SettingAboutusVC ()

@end

@implementation SettingAboutusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIImageView* logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoAbout"]];
    logo.frame = CGRectMake(mainWidth/4, mainWidth*0.25+10, mainWidth/2, mainWidth*0.25);
    [self.view addSubview:logo];
    
    UILabel* version = [[UILabel alloc]initWithFrame:CGRectMake(0, mainWidth*0.5+15, mainWidth, 30)];
    NSString *vsion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version.text        = [NSString stringWithFormat: @"夺宝大咖iOS V%@",vsion];
    version.textColor   = txtColor;
    version.font        = [UIFont systemFontOfSize:12];
    version.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:version];
    
    
    UILabel* lblDeclare = [[UILabel alloc]initWithFrame:CGRectMake(16, self.view.frame.size.height-180, mainWidth-32, 30)];
    lblDeclare.text        = @"特别说明: 苹果公司(Apple Inc.)不是夺宝大咖的赞助商，并且苹果公司也不会以任何形式参与其中!";
    lblDeclare.textColor   = txtColor;
    lblDeclare.font        = [UIFont systemFontOfSize:12];
    lblDeclare.textAlignment = NSTextAlignmentCenter;
    lblDeclare.lineBreakMode = NSLineBreakByWordWrapping;
    lblDeclare.numberOfLines = 2;
    [self.view addSubview:lblDeclare];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-64-30, mainWidth-20, 1.0)];
    line.backgroundColor = BG_GRAY_COLOR;
    [self.view addSubview:line];
    
    UILabel* lblCopy = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-64-25, mainWidth-20, 25)];
    lblCopy.text        = @"Copyright © 2011 - 2015, 版权所有 沪ICP备15020404号-4";
    lblCopy.textColor   = txtColor;
    lblCopy.font        = [UIFont systemFontOfSize:10];
    lblCopy.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCopy];
    
    

}

- (void)secureClicked
{
    SettingSecureVC* vc = [[SettingSecureVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
