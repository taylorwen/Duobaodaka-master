//
//  UserInstance.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "UserInstance.h"
#import "UserModel.h"

static UserInstance* user = nil;

@interface UserInstance ()
{
    __block NSString* mobile;
    __block NSString* password;
    __block NSString* addgroup;
    __block NSString* band;
    __block NSString* email;
    __block NSString* emailcode;
    __block NSString* groupid;
    __block NSString* img;
    __block NSString* jingyan;
    __block NSString* login;
    __block NSString* mobilecode;
    __block NSString* money;
    __block NSString* passcode;
    __block NSString* qianming;
    __block NSString* reg_key;
    __block NSString* score;
    __block NSString* time;
    __block NSString* uid;
    __block NSString* user_ip;
    __block NSString* username;
    __block NSString* yaoqing;
    __block NSString* groupName;
    __block NSString* auth_key;
    __block NSString* versionStatus;
}

@end

@implementation UserInstance
@synthesize mobilecode,mobile,password,addgroup,band,email,emailcode,groupid,img,jingyan,login,money,passcode,qianming,reg_key,score,time,uid,username,user_ip,yaoqing,groupName,image_url,auth_key,versionStatus;

/**
 *  用户实例化
 */
+(UserInstance*)ShardInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserInstance alloc] init];
    });
    return user;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        /**
         *  通知中心
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotifyApns:) name:kDidNotifyApns object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isUserStillOnline) name:kDidReloadUser object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDidUserLogout object:nil];
    }
    return self;
}

- (void)doNotifyApns:(NSNotification*)noti
{
    NSString* alter = noti.object;
    [[[UIAlertView alloc] initWithTitle:@"" message:alter delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

- (void)logout
{
    mobile = nil;
    password = nil;
    addgroup = nil;
    band = nil;
    email = nil;
    emailcode = nil;
    groupid = nil;
    img = nil;
    jingyan = nil;
    login = nil;
    mobilecode = nil;
    money = nil;
    passcode = nil;
    qianming = nil;
    reg_key = nil;
    score = nil;
    time = nil;
    uid = nil;
    user_ip = nil;
    username = nil;
    yaoqing = nil;
    groupName = nil;
    auth_key = nil;
    
}

- (void)isUserStillOnline
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    mobile = [userDefaultes         stringForKey:@"mobile"];
    password = [userDefaultes       stringForKey:@"password"];
    addgroup = [userDefaultes       stringForKey:@"addgroup"];
    band = [userDefaultes           stringForKey:@"band"];
    email = [userDefaultes          stringForKey:@"email"];
    emailcode = [userDefaultes      stringForKey:@"emailcode"];
    groupid = [userDefaultes        stringForKey:@"groupid"];
    img = [userDefaultes            stringForKey:@"img"];
    jingyan = [userDefaultes        stringForKey:@"jingyan"];
    login = [userDefaultes          stringForKey:@"login"];
    mobilecode = [userDefaultes     stringForKey:@"mobilecode"];
    money = [userDefaultes          stringForKey:@"money"];
    passcode = [userDefaultes       stringForKey:@"passcode"];
    qianming = [userDefaultes       stringForKey:@"qianming"];
    reg_key = [userDefaultes        stringForKey:@"reg_key"];
    score = [userDefaultes          stringForKey:@"score"];
    time = [userDefaultes           stringForKey:@"time"];
    uid = [userDefaultes            stringForKey:@"uid"];
    user_ip = [userDefaultes        stringForKey:@"user_ip"];
    username = [userDefaultes       stringForKey:@"username"];
    yaoqing = [userDefaultes        stringForKey:@"yaoqing"];
    groupName = [userDefaultes      stringForKey:@"groupName"];
    image_url = [userDefaultes      stringForKey:@"image_url"];
    auth_key = [userDefaultes       stringForKey:@"auth_key"];
    versionStatus = [userDefaultes  stringForKey:@"versionStatus"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
}

@end
