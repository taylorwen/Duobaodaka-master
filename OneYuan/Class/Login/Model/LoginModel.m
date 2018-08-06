//
//  HomeViewController.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginParser
@synthesize mobile,password,addgroup,band,emailcode,email,groupid,img,jingyan,login,mobilecode,money,passcode,qianming,reg_key,score,time,uid,username,user_ip,yaoqing,login_time,groupName,auth_key;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation LoginStatusParser
@synthesize resultCode,resultMessage;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation LoginModel

+ (void)doLogin:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyLogin];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getUserIp:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMineIPAddress];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

@end
