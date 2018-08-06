//
//  FreeBuySuccessVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/21.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "FreeBuySuccessVC.h"
#import "LimitedLotteryWebVC.h"

@interface FreeBuySuccessVC ()

@end

@implementation FreeBuySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百元话费，免费夺取";
    self.view.backgroundColor = [UIColor redColor];
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        
        [wSelf.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
//        LimitedLotteryWebVC* vc = [[LimitedLotteryWebVC alloc]init];
//        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        [wSelf.navigationController presentViewController:vc animated:YES completion:nil];
    }];
    
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth*0.6)];
    bg.image = [UIImage imageNamed:@"super_share_success1"];
    [self.view addSubview:bg];
    
    UIImageView* biankuang = [[UIImageView alloc]initWithFrame:CGRectMake(16, mainWidth*0.6+10, mainWidth-32, (mainWidth-32)*0.5)];
    biankuang.image = [UIImage imageNamed:@"super_share_success_biankuang"];
    [self.view addSubview:biankuang];
    
    UILabel* gongxi = [[UILabel alloc]initWithFrame:CGRectMake(0, mainWidth*0.5+60, mainWidth, 30)];
    gongxi.textColor = [UIColor yellowColor];
    gongxi.font = [UIFont systemFontOfSize:29];
    gongxi.textAlignment = NSTextAlignmentCenter;
    gongxi.text = @"😊恭喜您   ";
    [self.view addSubview:gongxi];
    
    UILabel* success = [[UILabel alloc]initWithFrame:CGRectMake(0, mainWidth*0.5+60+50, mainWidth, 30)];
    success.textColor = [UIColor yellowColor];
    success.font = [UIFont systemFontOfSize:20];
    success.textAlignment = NSTextAlignmentCenter;
    success.text = @"成功参与了免费夺话费";
    [self.view addSubview:success];
    
    UILabel* wait = [[UILabel alloc]initWithFrame:CGRectMake(0, mainWidth*0.5+60+50+40, mainWidth, 30)];
    wait.textColor = [UIColor yellowColor];
    wait.font = [UIFont systemFontOfSize:20];
    wait.textAlignment = NSTextAlignmentCenter;
    wait.text = @"请等待揭晓";
    [self.view addSubview:wait];
    
    UIButton* btnRace = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/4, self.view.frame.size.height-127, mainWidth/2, 49)];
    btnRace.layer.masksToBounds = YES;
    btnRace.layer.cornerRadius = 8;
    [btnRace setBackgroundColor:[UIColor yellowColor]];
    [btnRace setTitle:@"提高中奖几率"             forState:UIControlStateNormal];
    [btnRace setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    btnRace.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnRace addTarget:self action:@selector(improveSuccessRateClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRace];
}

- (void)improveSuccessRateClicked
{
    LimitedLotteryWebVC* vc = [[LimitedLotteryWebVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
