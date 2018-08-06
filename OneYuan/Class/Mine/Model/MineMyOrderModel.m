//
//  MineMyOrderModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyOrderModel.h"

@implementation MineMyOrderItem
@synthesize brandid,canyurenshu,cateid,gonumber,huode,pid,ip,q_end_time,q_showtime,q_uid,q_user_code,qishu,shenyurenshu,sid,thumb,title,uphoto,username,zongrenshu,shengyutime,status,go_status;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMyOrderList
@synthesize count,listItems;

+ (Class)listItems_class {
    return [MineMyOrderItem class];
}
@end

@implementation MineMyOrderModel

+ (void)getUserOrderlist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetUserOwnedProduct];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)doConfirmOrder:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewConfirmAddressStatus];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

@end
