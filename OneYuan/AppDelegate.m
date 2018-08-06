//
//  AppDelegate.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInstance.h"
#import "TabHomeVC.h"
#import "TabMineVC.h"
#import "TabNewestVC.h"
#import "TabProductVC.h"
#import "TabShopCartVC.h"
#import "CartModel.h"
#import "OyTool.h"
#import "OYDownLibVC.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <BeeCloud/BeeCloud.h>
#import <BCAliPay/BCAliPay.h>
#import <BCWXPay/BCWXPay.h>
#import "ZWIntroductionViewController.h"
#import "sys/utsname.h"         //判断手机型号
#import "LoginModel.h"
#import "UserModel.h"
#import "HomePopOverVC.h"
#import "UIViewController+MJPopupViewController.h"
#import "BBLaunchAdMonitor.h"
#import "UserModel.h"
#import "DelegateModel.h"
#import "DSNavigationBar.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import <SDImageCache.h>

#define oyUseLib    0

@interface AppDelegate () <UITabBarControllerDelegate,HomePopoverViewDelegate>
{
    NSString* deviceString;
    HomePopOverVC       *popVC;
    NSMutableArray* arrAdsList;
}
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@property (strong, nonatomic) UIImageView *adImageView;
@end

@implementation AppDelegate

- (UIViewController*)loadFramework
{
    NSLog(@"%@",NSHomeDirectory());
    NSString* libFile = [NSString stringWithFormat:@"%@/Documents/OY.framework",NSHomeDirectory()];
    //判断一下有没有这个文件的存在　如果没有直接跳出
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:libFile]) {
        NSLog(@"There isn't have the file");
        return nil;
    }
    
    //复制到程序中
    NSError *error = nil;
    
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:libFile];
    if (frameworkBundle && [frameworkBundle load]) {
        NSLog(@"bundle load framework success.");
    }else {
        NSLog(@"bundle load framework err:%@",error);
        return nil;
    }
    
    Class pacteraClass = NSClassFromString(@"OYMainClass");
    if (!pacteraClass) {
        NSLog(@"Unable to get TestDylib class");
        return nil;
    }
    
    NSObject *pacteraObject = [pacteraClass new];//必须new
    NSArray* vcs = [pacteraObject performSelector:@selector(getMainTabVC:appDelegate:) withObject:_window withObject:self];
    
    [frameworkBundle unload];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = vcs;
    tabBarController.delegate = self;
    
    
    // customise TabBar UI Effect
    [UITabBar appearance].tintColor = wordColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_TEXT_NOR_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_TEXT_HLT_COLOR} forState:UIControlStateSelected];
    
    // customise NavigationBar UI Effect
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(10., 10.)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.backgroundColor = [UIColor whiteColor];

    return tabBarController;
}

- (UITabBarController*)setRootVC:(BOOL)bShowCart
{
    TabHomeVC *homeVC = [[TabHomeVC alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UIImage *unselectedImage = [UIImage imageNamed:@"tab-home"];
    UIImage *selectedImage = [UIImage imageNamed:@"tab-home-s"];
    
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeVC.tabBarItem.tag = 0;
    
    TabProductVC *proVC = [[TabProductVC alloc] init];
    UINavigationController *proNav = [[UINavigationController alloc] initWithRootViewController:proVC];
    unselectedImage = [UIImage imageNamed:@"tab-pro"];
    selectedImage = [UIImage imageNamed:@"tab-pro-s"];
    
    proNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"所有奖品"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    proNav.tabBarItem.tag = 1;
    
    TabNewestVC * newVc = [[TabNewestVC alloc] init];
    UINavigationController * newNav = [[UINavigationController alloc] initWithRootViewController:newVc];
    unselectedImage = [UIImage imageNamed:@"tab-new"];
    selectedImage = [UIImage imageNamed:@"tab-new-s"];
    
    newNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"最新揭晓"
                                                       image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    newNav.tabBarItem.tag = 2;
    
    TabShopCartVC * cartVc = [[TabShopCartVC alloc] init];
    UINavigationController * cartNav = [[UINavigationController alloc] initWithRootViewController:cartVc];
    unselectedImage = [UIImage imageNamed:@"tab-cart"];
    selectedImage = [UIImage imageNamed:@"tab-cart-s"];
    
    cartNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"清单"
                                                      image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    cartNav.tabBarItem.tag = 3;
    
    TabMineVC * mineVc = [[TabMineVC alloc] init];
    UINavigationController * mineNav = [[UINavigationController alloc] initWithRootViewController:mineVc];
    unselectedImage = [UIImage imageNamed:@"tab-mine"];
    selectedImage = [UIImage imageNamed:@"tab-mine-s"];
    
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心"
                                                       image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    mineNav.tabBarItem.tag = 4;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSString* switchSTR = [[NSUserDefaults standardUserDefaults]objectForKey:@"versionStatus"];
    if ([switchSTR isEqualToString:@"1"])
        tabBarController.viewControllers = @[homeNav,proNav,newNav,cartNav,mineNav];
    else
        tabBarController.viewControllers = @[homeNav,proNav,newNav,mineNav];
    tabBarController.delegate = self;
    
    // customise TabBar UI Effect
    [UITabBar appearance].tintColor = BG_COLOR;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_TEXT_NOR_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_TEXT_HLT_COLOR} forState:UIControlStateSelected];
    
    // customise NavigationBar UI Effect
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(10., 10.)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.backgroundColor = [UIColor whiteColor];
    return tabBarController;
}

- (void)setCartNum
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]){
        UITabBarController* tabVC = (UITabBarController*)self.window.rootViewController;
        UINavigationController* navVC = [tabVC.viewControllers objectAtIndex:3];
        __weak typeof (navVC) wNav = navVC;
        [CartModel quertCart:nil value:nil block:^(NSArray* result){
            if(result.count > 0)
                wNav.tabBarItem.badgeValue  = [NSString stringWithFormat:@"%d",(int)result.count];
            else
                wNav.tabBarItem.badgeValue  = nil;
        }];
 
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    [[SDImageCache sharedImageCache] setMaxCacheSize:20];
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];
    [self CheckPublishStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadApp) name:kDidShowCart object:nil];
    UIViewController *rootViewController = [self setRootVC:YES];
    [[self window] setRootViewController:rootViewController];
    [self setCartNum];
    
    //判断是否为第一次登陆
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        NSLog(@"第一次");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadApp) name:kDidShowCart object:nil];
        UIViewController *rootViewController = [self setRootVC:YES];
        [[self window] setRootViewController:rootViewController];
        [self setCartNum];
        
        [self getAdsFromStart];     //存储广告图
        //判断设备型号是否为4s,4s使用不同的介绍页图片
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];//设置成yes以后再也不进入进入引导页;
        
    }else{
        NSLog(@"不是第一次");
        
        //进入主界面;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadApp) name:kDidShowCart object:nil];
        UIViewController *rootViewController = [self setRootVC:YES];
        [[self window] setRootViewController:rootViewController];
        [self setCartNum];
    }
    
        //正式环境的ID
    [BeeCloud initWithAppID:beeCloudAppId andAppSecret:beeCloudAppSecret];
    [BeeCloud setWillPrintLog:YES];
    
    [[UserInstance ShardInstnce] isUserStillOnline];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //设置友盟数据统计和社交分享
    [self setUmeng];
    //检查App发布状态
    
    //设置极光推送
//    [self setJPush:launchOptions];
    //判断用户是否登录，如果已登录，则刷新用户数据
    if ([UserInstance ShardInstnce].uid)
    {
        [self checkUserInfo];
    }
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    if ([UserInstance ShardInstnce].image_url) {
        NSString *path = [oyImageBaseUrl stringByAppendingString:[UserInstance ShardInstnce].image_url];
        [BBLaunchAdMonitor showAdAtPath:path
                                 onView:self.window
                           timeInterval:3.
                       detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"}];
    }
    
    return YES;
}

//获取开机3秒广告
- (void)getAdsFromStart
{
    [UserModel getStartAds:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSArray* list = [StartAdsModel arrayOfModelsFromDictionaries:@[dataDict] error:NULL];
        
        arrAdsList = [NSMutableArray arrayWithArray:list];
        NSLog(@"%@",arrAdsList);
        StartAdsModel* itemImage = [arrAdsList objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:itemImage.image_url forKey:@"image_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UserInstance ShardInstnce] isUserStillOnline];
        
    }failure:^(NSError* error){
        NSLog(@"%@",error);
    }];
}

//检查是否已经上线
- (void)CheckPublishStatus
{
    NSDictionary* dict = @{@"version":@"1.6.0"};
    [UserModel getPublishStatus:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        NSMutableArray* arrStatus = [UserPublishStatus arrayOfModelsFromDictionaries:@[dataDict] error:NULL];
        UserPublishStatus* statusInfo = [arrStatus objectAtIndex:0];
        if ([parser.resultCode isEqualToString:@"200"]) {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:statusInfo.versionStatus forKey:@"versionStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UserInstance ShardInstnce] isUserStillOnline];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadApp) name:kDidShowCart object:nil];
            UIViewController *rootViewController = [self setRootVC:YES];
            [[self window] setRootViewController:rootViewController];
            [self setCartNum];
        }
        
    }failure:^(NSError* error){
        
    }];
}

#pragma mark - thidr part
#pragma mark - umeng
- (void)setUmeng
{
    //设置友盟数据统计模块
    NSString* umApp = UmengAppkey;      //自行设置key
    [MobClick startWithAppkey:umApp reportPolicy:SENDWIFIONLY channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [OyTool ShardInstance];
    [MobClick updateOnlineConfig];
    [UMFeedback setAppkey:umApp];
    
    //设置友盟社会化分享模块
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialData openLog:YES];
    
    //设置微信AppId，设置分享url
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"http://duobaodaka.com/"];
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:@"http://duobaodaka.com/"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    if (BCPayUrlWeChat == [BCUtil getUrlType:url])
    {
//        return [BCWXPay handleOpenUrl:url];
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    else if (BCPayUrlAlipay == [BCUtil getUrlType:url])
    {
        return [BCAliPay handleOpenUrl:url];
    }
    else
    {
        return [UMSocialSnsService handleOpenURL:url];
    }
    return  YES;
}

- (void)reloadApp
{
    UIViewController* vcMain = [self loadFramework];
    if (vcMain && oyUseLib)
    {
        [[self window] setRootViewController:vcMain];
    }
    else
    {
        UIViewController *rootViewController = [self setRootVC:YES];
        [[self window] setRootViewController:rootViewController];
        [self setCartNum];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //从后台唤醒
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //保留后台进程
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidNotifyFromBack object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//需要重新写一个接口，每次启动App的时候，使用uid去刷新一下个人数据；
- (void)checkUserInfo
{
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid};
    [UserModel getUserInfo:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        //JSON解析开始
        UserInfoModel* parser = [[UserInfoModel alloc] initWithDictionary:dataDict  error:NULL];
        OneBaseParser *status = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([status.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:parser.mobile       forKey:@"mobile"];
            [userDefaults setObject:parser.mobilecode   forKey:@"mobilecode"];
            [userDefaults setObject:parser.email        forKey:@"email"];
            [userDefaults setObject:parser.emailcode    forKey:@"emailcode"];
            [userDefaults setObject:parser.groupid      forKey:@"groupid"];
            [userDefaults setObject:parser.jingyan      forKey:@"jingyan"];
            [userDefaults setObject:parser.money        forKey:@"money"];
            [userDefaults setObject:parser.passcode     forKey:@"passcode"];
            [userDefaults setObject:parser.password     forKey:@"password"];
            [userDefaults setObject:parser.qianming     forKey:@"qianming"];
            [userDefaults setObject:parser.reg_key      forKey:@"reg_key"];
            [userDefaults setObject:parser.score        forKey:@"score"];
            [userDefaults setObject:parser.time         forKey:@"time"];
            [userDefaults setObject:parser.uid          forKey:@"uid"];
            [userDefaults setObject:parser.user_ip      forKey:@"user_ip"];
            [userDefaults setObject:parser.username     forKey:@"username"];
            [userDefaults setObject:parser.yaoqing      forKey:@"yaoqing"];
            [userDefaults setObject:parser.addgroup     forKey:@"addgroup"];
            [userDefaults setObject:parser.band         forKey:@"band"];
            [userDefaults setObject:parser.img          forKey:@"img"];
            [userDefaults setObject:parser.groupName    forKey:@"groupName"];
            [userDefaults setObject:parser.login_time   forKey:@"login_time"];        //新增
            
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
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([tabBarController selectedIndex] == 0){
        TabHomeVC *home = [[TabHomeVC alloc]init];
        [home viewWillAppear:YES];
    }else if ([tabBarController selectedIndex] == 2)
    {
        TabNewestVC *new = [[TabNewestVC alloc]init];
        [new viewWillAppear:YES];
    }
}

@end
