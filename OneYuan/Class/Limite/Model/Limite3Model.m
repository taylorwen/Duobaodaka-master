//
//  Limite3Model.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "Limite3Model.h"

@implementation ThreeProModel
@synthesize _id,canyurenshu,money,open_time,qishu,shenyurenshu,sid,thumb,title,xsjx_time,yunjiage,zongrenshu,username,q_end_time,q_user_code;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ThreeProStatus
@synthesize proArr,resultCode,resultMessage;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HuaFeiModel
@synthesize brandid,canyurenshu,cateid,money,pid,q_end_time,q_uid,qishu,server_time,shenyurenshu,sid,status,thumb,title,xsjx_time,xsjx_time1,yunjiage,zongrenshu,open_time;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProStatusModel
@synthesize canyurenshu,img,mobile,open_time,q_uid,q_user_code,qishu,server_time,shenyurenshu,sid,status,thumb,title,username,xsjx_time,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation AutoLotteryModel
@synthesize canyurenshu,img,mobile,open_time,q_uid,q_user_code,qishu,server_time,shenyurenshu,sid,thumb,title,username,xsjx_time,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation BuyRecordModel
@synthesize go_time,gonumber,huode,qishu,status,xsjx_time;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation Limite3Model
+ (void)getLimite3Products:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetLimite3Pro];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getLimiteTimePeriod:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetLimiteGoodList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getLimiteHuafei:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetLimiteGoodStatus];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getSharedUser:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetSharedUser];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getautoBuy:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetautoBuy];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getautoLottery:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetautoLottery];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getBuyRecordList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetLimitedActivityBuyRecord];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
