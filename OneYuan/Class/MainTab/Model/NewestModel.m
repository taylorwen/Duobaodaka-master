//
//  NewestModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "NewestModel.h"

@implementation NewestProItme
@synthesize brandid,canyurenshu,cateid,gonumber,huode,ip, pid,q_end_time,q_showtime,q_uid,q_user_code,qishu,shenyurenshu,thumb,title,uphoto,username,zongrenshu,sid,money,shengyutime;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation NewestProList
@synthesize count,Rows;
+ (Class)Rows_class {
    return [NewestProItme class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation NewestModel

+(void)getAllNewest:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url;
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
        url = [oyBaseNewUrl stringByAppendingString:oyGetNewLottery];
    }else
    {
        url = [oyBasePHPUrl stringByAppendingString:oyGetNewestLotteryOffline];
    }
    
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+(void)getAllHistory:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyHistoryGoods];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
