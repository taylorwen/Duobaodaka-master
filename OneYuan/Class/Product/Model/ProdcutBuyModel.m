//
//  ProdcutBuyModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//
#import "ProdcutBuyModel.h"

@implementation ProdcutBuyItem
@synthesize code,code_tmp,company,company_code,company_money,email,gonumber,goucode,huode,pid,ip, mobile,moneycount,pay_type,shopid,shopname,shopqishu,status,time,uid,uphoto,username;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProdcutBuyList
+(Class)Rows_class
{
    return [ProdcutBuyItem class];
}
@end

@implementation ProdcutBuyModel

+ (void)getGoodBuyList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGoodsBuyHistory];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getGoodBuyCode:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetUserCode];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

@end
