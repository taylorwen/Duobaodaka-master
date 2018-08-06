//
//  TabMineVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabMineVC.h"
#import "LoginVC.h"
#import "UserModel.h"
#import "UserInstance.h"
#import "MineLoginView.h"
#import "MineUserView.h"
#import "MineBuylistVC.h"
#import "MineMyOrderVC.h"
#import "MineShowOrderVC.h"
#import "MineMoneyDetailVC.h"
#import "MineMyAddressVC.h"
#import "SettingVC.h"
#import "MineChargeVC.h"
#import "PersonCenterVC.h"
#import "RegisterVC.h"
#import "RegisterVC.h"
#import "TabMinePopVC.h"
#import "MineModel.h"

@interface TabMineVC () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,MineLoginViewDelegate,MineUserViewDelegate,TabMinePopoverViewDelegate>
{
    __block UITableView     *tbView;
    
    NSArray *arrTitles;
    NSArray *arrImages;
    TabMinePopVC*   mineVC;
    QQListModel*    qqItem;
    NSMutableArray* qqList;
}
@end

@implementation TabMineVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UserInstance ShardInstnce] isUserStillOnline];
    if ([UserInstance ShardInstnce].uid)
    {
        [self checkUserInfo];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginOk) name:kDidLoginOk object:nil];
    __weak typeof (self) wSelf = self;
    self.title = @"个人中心";
    
    arrTitles = @[@[@"夺宝记录",@"我的奖品",@"我的晒单"],@[@"账户明细",@"收货地址"],@[@"我的申明"]];
    arrImages = @[@[@"me1",@"me2",@"me3"],@[@"me6",@"me7"],@[@"me6"]];
    //添加导航栏右侧按钮
    [self actionCustomRightBtnWithNrlImage:@"btnsetting" htlImage:@"btnsetting" title:@"" action:^{
        SettingVC* vc = [[SettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [wSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [self getServiceQQNumber];
}

- (void)didLoginOk
{
    [tbView reloadData];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section ==1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 150;
    return 6;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (![UserInstance ShardInstnce].uid)
        {
            MineLoginView* v = [[MineLoginView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 130)];
            v.delegate = self;
            return v;
        }
        else
        {
            MineUserView* v = [[MineUserView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 130)];
            v.delegate = self;
            return v;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  nil;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray* arr = (NSArray*)[arrTitles objectAtIndex:indexPath.section];
    NSArray* imgArr = (NSArray*)[arrImages objectAtIndex:indexPath.section];
    NSString* title = nil;
    NSString* image = nil;
//    title = [arrTitles objectAtIndex:indexPath.row];
//    image = [arrImages objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"         %@",[arr objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
    img.image = [UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    [cell addSubview:img];
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
    line.backgroundColor = myLineColor;
    [cell addSubview:line];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"accountCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = @"         账户明细";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
            cell.detailTextLabel.text = @"查询充值、消费记录";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
            img.image = [UIImage imageNamed:@"me6"];
            [cell addSubview:img];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"addressCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = @"         收货地址";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
            cell.detailTextLabel.text = @"添加、修改收获地址";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
            img.image = [UIImage imageNamed:@"me7"];
            [cell addSubview:img];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
            return cell;

        }
    }
    if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"serviceQQCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"         在线客服";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
        cell.detailTextLabel.text = @"联系客服、反馈问题";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        img.image = [UIImage imageNamed:@"icon_kefu"];
        [cell addSubview:img];
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
        line.backgroundColor = myLineColor;
        [cell addSubview:line];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                MineBuylistVC* vc = [[MineBuylistVC alloc] init];//夺宝记录
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
        }
        else if (indexPath.row == 1)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                MineMyOrderVC* vc = [[MineMyOrderVC alloc] init];//中奖记录
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
        }
        else if (indexPath.row == 2)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                MineShowOrderVC* vc = [[MineShowOrderVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                MineMoneyDetailVC* vc = [[MineMoneyDetailVC alloc] init];//钱包
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
        }
        
        if (indexPath.row == 1)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                MineMyAddressVC* vc = [[MineMyAddressVC alloc] initWithType:MineAddressType_Common OrderId:nil];//收货地址
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    else if (indexPath.section == 2)
    {
        if ([UserInstance ShardInstnce].uid)
        {
            mineVC = nil;
            mineVC = [[TabMinePopVC alloc]init];
            mineVC.delegate = self;
            [self presentPopupViewController:mineVC animationType:MJPopupViewAnimationFade];
        }
        else
        {
            RegisterVC* vc = [[RegisterVC alloc]init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.tabBarController presentViewController:nav animated:YES completion:nil];
        }
    }
    
}

//弹出QQ客服的处理事件
- (void)cancelTabMineButtonClicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
}
- (void)goNextTabMineButton1Clicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    QQListModel* item = [qqList objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",item.qq];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}

- (void)goNextTabMineButton2Clicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    QQListModel* item = [qqList objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",item.qq];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)goNextTabMineButton3Clicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    QQListModel* item = [qqList objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",item.qq];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)goNextTabMineButton4Clicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    QQListModel* item = [qqList objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",item.qq];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)goNextTabMineButton5Clicked:(TabMinePopVC*)tabPopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tabPopOverVC = nil;
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"拨打客服电话"  message:@"热线电话服务时间为周一到周五的9：00-18：00" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *number = @"4006086666";
        NSString *phone = [[NSString alloc] initWithFormat:@"tel://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

#pragma mark - login view delegate
- (void)doLogin
{
    RegisterVC* vc = [[RegisterVC alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}

- (void)btnPayAction
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        MineChargeVC* vc = [[MineChargeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        SCLAlertView* alert = [[SCLAlertView alloc] init];
        alert.showAnimationType = FadeIn;
        [alert showWarning:self.tabBarController title:@"提示" subTitle:@"请前往官方网站完成充值" closeButtonTitle:@"好的" duration:0];
    }
}

- (void)imgHeadClicked
{
    PersonCenterVC* vc = [[PersonCenterVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkUserInfo
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [UserModel getUserInfo:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        //JSON解析开始
        UserInfoModel* parser = [[UserInfoModel alloc] initWithDictionary:dataDict  error:NULL];
        OneBaseParser *status = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([status.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:parser.mobile forKey:@"mobile"];
            [userDefaults setObject:parser.mobilecode forKey:@"mobilecode"];
            [userDefaults setObject:parser.email forKey:@"email"];
            [userDefaults setObject:parser.emailcode forKey:@"emailcode"];
            [userDefaults setObject:parser.groupid forKey:@"groupid"];
            [userDefaults setObject:parser.jingyan forKey:@"jingyan"];
            [userDefaults setObject:parser.money forKey:@"money"];
            [userDefaults setObject:parser.passcode forKey:@"passcode"];
            [userDefaults setObject:parser.password forKey:@"password"];
            [userDefaults setObject:parser.qianming forKey:@"qianming"];
            [userDefaults setObject:parser.reg_key forKey:@"reg_key"];
            [userDefaults setObject:parser.score forKey:@"score"];
            [userDefaults setObject:parser.time forKey:@"time"];
            [userDefaults setObject:parser.uid forKey:@"uid"];
            [userDefaults setObject:parser.user_ip forKey:@"user_ip"];
            [userDefaults setObject:parser.username forKey:@"username"];
            [userDefaults setObject:parser.yaoqing forKey:@"yaoqing"];
            [userDefaults setObject:parser.addgroup forKey:@"addgroup"];
            [userDefaults setObject:parser.band forKey:@"band"];
            [userDefaults setObject:parser.img forKey:@"img"];
            [userDefaults setObject:parser.groupName forKey:@"groupName"];
            [userDefaults setObject:parser.login_time forKey:@"login_time"];        //新增
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UserInstance ShardInstnce] isUserStillOnline];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
            
        }
        else{
            [[XBToastManager ShardInstance] hideprogress];
            if ([status.resultCode isEqualToString:@"204"])
            {
                [[XBToastManager ShardInstance] showtoast:@""];
            }
            else
                [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@""]];
        }
    } failure:^(NSError* error){
        
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@""];
    }];
    
}

//获取客服电话
- (void)getServiceQQNumber
{
    [MineModel getServiceQQNumber:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [QQListModel arrayOfModelsFromDictionaries:@[datadict] error:NULL];
        OneBaseParser* p = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([p.resultCode isEqualToString:@"200"]) {
            if (list == nil)
            {
                return ;
            }else
            {
                qqList = [NSMutableArray arrayWithArray:list];
            }
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

@end
