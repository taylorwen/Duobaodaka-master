//
//  UserInstance.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInstance : NSObject

@property (nonatomic,copy)NSString* mobile;
@property (nonatomic,copy)NSString* password;
@property (nonatomic,copy)NSString* addgroup;
@property (nonatomic,copy)NSString* band;
@property (nonatomic,copy)NSString* email;
@property (nonatomic,copy)NSString* emailcode;
@property (nonatomic,copy)NSString* groupid;
@property (nonatomic,copy)NSString* img;
@property (nonatomic,copy)NSString* jingyan;
@property (nonatomic,copy)NSString* login;
@property (nonatomic,copy)NSString* mobilecode;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* passcode;
@property (nonatomic,copy)NSString* qianming;
@property (nonatomic,copy)NSString* reg_key;
@property (nonatomic,copy)NSString* score;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* uid;
@property (nonatomic,copy)NSString* user_ip;
@property (nonatomic,copy)NSString* username;
@property (nonatomic,copy)NSString* yaoqing;
@property (nonatomic,copy)NSString* groupName;
@property (nonatomic,copy)NSString* image_url;
@property (nonatomic,copy)NSString* auth_key;
@property (nonatomic,copy)NSString* versionStatus;

+(UserInstance*)ShardInstnce;

- (void)logout;
- (void)isUserStillOnline;
@end
