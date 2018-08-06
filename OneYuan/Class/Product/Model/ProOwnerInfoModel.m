//
//  ProOwnerInfoModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/21.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProOwnerInfoModel.h"

@implementation OwnerInfo
@synthesize code,code_tmp,company,company_code,company_money,email,gonumber,goucode,huode,pid,ip,mobile,moneycount,pay_type,q_end_time,shopid,shopname,shopqishu,uphoto,username;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation OwnerInfoStatus
@synthesize resultMessage,resultCode;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProOwnerInfoModel

+ (void)getOwnerInfo:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetProductOwnerInfo];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

@end
