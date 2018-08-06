//
//  LotteryModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LotteryModel.h"

@implementation HistoryLotteryModel
@synthesize gonumber,huode,pid,ip,q_end_time,q_uid,q_user_code,qishu,shopid,shopqishu,sid,status,uid,uphoto,username,shengyutime;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation LotteryModel
+ (void)getHistoryLotterylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyHistoryGoods];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
