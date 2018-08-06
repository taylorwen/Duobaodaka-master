//
//  HomeViewController.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginParser :  OneBaseParser
@property (nonatomic,copy)NSString* mobile;
@property (nonatomic,copy)NSString* password;
@property (nonatomic,copy)NSString* addgroup;   // 用户加入的圈子组1|2|3,
@property (nonatomic,copy)NSString* band;       //用户权限组
@property (nonatomic,copy)NSString* email;
@property (nonatomic,copy)NSString* emailcode;
@property (nonatomic,copy)NSString* groupid;
@property (nonatomic,copy)NSString* img;        //用户头像
@property (nonatomic,copy)NSString* jingyan;
@property (nonatomic,copy)NSString* login;
@property (nonatomic,copy)NSString* mobilecode;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* passcode;   //找回密码验证码
@property (nonatomic,copy)NSString* qianming;
@property (nonatomic,copy)NSString* reg_key;    //注册参数
@property (nonatomic,copy)NSString* score;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* uid;        //用户ID
@property (nonatomic,copy)NSString* user_ip;    //用户IP地址
@property (nonatomic,copy)NSString* username;
@property (nonatomic,copy)NSString* yaoqing;
@property (nonatomic,copy)NSString* login_time;
@property (nonatomic,copy)NSString* groupName;
@property (nonatomic,copy)NSString* auth_key;
@end

@interface LoginStatusParser : OneBaseParser
@property (nonatomic,copy)NSString* resultCode;
@property (nonatomic,copy)NSString* resultMessage;
@end

@interface LoginModel : NSObject

+ (void)doLogin:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUserIp:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
