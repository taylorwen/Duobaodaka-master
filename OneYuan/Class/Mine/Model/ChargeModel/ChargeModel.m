//
//  ChargeModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/28.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ChargeModel.h"

@implementation ChargeOrder
@synthesize code,money,pay_type,pid,scookies,score,status,time,uid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ChargeResult
@synthesize code,money,pay_type,pid,scookies,score,status,time,uid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation BuyRequestModel
@synthesize sid,gonumber,pid,qishu,yunjiage,codes;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation BuySuccessResult
@synthesize codes,gonumber,pid,qishu,sid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ChargeModel
+(void)getChargeOrder:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMemberOrderList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
+(void)getChargeResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMemberChargeResult];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+(void)getBuyResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMemberBuyList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+(void)getVerifyResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* base = @"http://m.duobaowu.cn/";
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewVerifyPaymentResult];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
